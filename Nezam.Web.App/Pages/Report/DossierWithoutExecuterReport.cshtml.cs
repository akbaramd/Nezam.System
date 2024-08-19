using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using Dapper;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.Extensions.Configuration;
using Velzon.Controllers;
using Velzon.Models;

namespace Velzon.Pages.Report
{
    [Authorize]
    public class DossierWithoutExecuterReportModel(IConfiguration configuration) : PageModel
    {
        private readonly string? _connectionString = configuration.GetConnectionString("DefaultConnection");

        [BindProperty] 
        public ReportFilterViewModel FilterModel { get; set; } = new();

        public WebReport WebReport { get; set; } = new();

        public void OnGet()
        {
            InitializeFilterModel();
            PopulateFilterDropdowns(FilterModel);
        }

        public IActionResult OnPostGenerateReport()
        {
            PopulateFilterDropdowns(FilterModel);
            if (!ModelState.IsValid)
            {
                return Page();
            }

            // Convert Persian dates to Gregorian dates for querying the database
            var startDate = ConvertPersianToGregorian(FilterModel.StartDate);
            var endDate = ConvertPersianToGregorian(FilterModel.EndDate);

            var data = FetchReportData(startDate, endDate, FilterModel.SelectedSyncCode, FilterModel.SelectedDossierTypeId);
            if (data == null)
            {
                return Page();
            }

            SetupWebReport(startDate, endDate, data);
            return Page();
        }

        public IActionResult OnPostDownloadPdf()
        {
            if (!ModelState.IsValid)
            {
                PopulateFilterDropdowns(FilterModel);
                return Page();
            }

            var startDate = ConvertPersianToGregorian(FilterModel.StartDate);
            var endDate = ConvertPersianToGregorian(FilterModel.EndDate);

            var data = FetchReportData(startDate, endDate, FilterModel.SelectedSyncCode, FilterModel.SelectedDossierTypeId);
            if (data == null)
            {
                return Page();
            }

            var pdfContent = GeneratePdf(startDate, endDate, data);
            return File(pdfContent, "application/pdf", "DossierReport.pdf");
        }

        private void InitializeFilterModel()
        {
            FilterModel.StartDate ??= ConvertToPersianDateString(DateTime.Now.AddMonths(-1));
            FilterModel.EndDate ??= ConvertToPersianDateString(DateTime.Now);
            FilterModel.Year = DateTime.Now.Year;
        }

        private void PopulateFilterDropdowns(ReportFilterViewModel model)
        {
            using var connection = new SqlConnection(_connectionString);
            connection.Open();

            model.DossierTypes = connection.Query<SelectListItem>(
                "SELECT Id AS Value, Title AS Text FROM [cedo].[DossierType]"
            ).ToList();
            model.DossierTypes.Insert(0, new SelectListItem { Value = "0", Text = "همه" });

            model.Cities = connection.Query<SelectListItem>(
                "SELECT SyncCode AS Value, Name AS Text FROM [cedo].[Cities] WHERE SyncCode IS NOT NULL"
            ).ToList();
            model.Cities.Insert(0, new SelectListItem { Value = "0", Text = "همه" });
        }

        private IEnumerable<ConstructionLicenseReportModel>? FetchReportData(DateTime startDate, DateTime endDate, int syncCode, int dossierTypeId)
        {
            using var connection = new SqlConnection(_connectionString);
            connection.Open();

            var query = @"
                WITH FirstOwnerCTE AS (
                    SELECT 
                        cl.Id,
                        cl.DossierNumber,
                        cl.DossierSerial,
                        o.FirstName,
                        o.LastName,
                        o.NationalCode,
                        cl.RefNumber,
                        cl.LicenseNumber,
                        cl.TransitionalDossierNumber,
                        cl.TransitionalDossierSerial,
                        cl.DossierTypeId,
                        ROW_NUMBER() OVER (PARTITION BY cl.Id ORDER BY o.Id) AS OwnerRank
                    FROM 
                        [cedo].[ConstructionLicenses] cl
                    INNER JOIN 
                        [cedo].[Estates] e ON cl.EstateId = e.Id
                    INNER JOIN 
                        [cedo].[Owners] o ON o.ConstructionLicenseId = cl.id 
                    INNER JOIN 
                        [cedo].[Municipalities] m ON e.MunicipalityId = m.Id
                    INNER JOIN 
                        [cedo].[Cities] c ON m.CityId = c.Id
                    INNER JOIN 
                        [cedo].[DossierBuildingGroupSettings] dbgs ON cl.Id = dbgs.ConstructionLicenseId
                    LEFT JOIN 
                        [cedo].[Contracts] ct ON cl.Id = ct.ConstructionLicenseId 
                            AND ct.ContractTypeId = 6
                            AND ct.StatusId = 1
                    WHERE 
                        dbgs.NeedExecuter = 1
                        AND cl.LicenseDate BETWEEN @StartDate AND @EndDate
                        AND ct.Id IS NULL
                        AND (@SyncCode = 0 OR c.SyncCode = @SyncCode)
                        AND (@DossierTypeId = 0 OR cl.DossierTypeId = @DossierTypeId)
                        AND cl.StatusId = 1
                )
                SELECT 
                    *
                FROM 
                    FirstOwnerCTE
                WHERE 
                    OwnerRank = 1;
            ";

            return connection.Query<ConstructionLicenseReportModel>(query, new
            {
                StartDate = startDate,
                EndDate = endDate,
                SyncCode = syncCode,
                DossierTypeId = dossierTypeId
            });
        }

        private void SetupWebReport(DateTime startDate, DateTime endDate, IEnumerable<ConstructionLicenseReportModel> data)
        {
            var dataTable = data.ToDataTable();
            WebReport = new WebReport
            {
                Toolbar =
                {
                    ShowPrint = false,
                    Exports =
                    {
                        ExportTypes = Exports.Excel2007,
                        ShowPreparedReport = false,
                        Show = true
                    }
                }
            };

            WebReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled.frx"));
            WebReport.Report.RegisterData(dataTable, "MyDataSource");
            WebReport.Report.GetDataSource("MyDataSource").Enabled = true;
            WebReport.Report.SetParameterValue("StartAt", ConvertToPersianDateString(startDate));
            WebReport.Report.SetParameterValue("EndAt", ConvertToPersianDateString(endDate));
        }

        private byte[] GeneratePdf(DateTime startDate, DateTime endDate, IEnumerable<ConstructionLicenseReportModel> data)
        {
            var webReport = new WebReport();
            webReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled.frx"));

            var dataTable = data.ToDataTable();
            webReport.Report.RegisterData(dataTable, "MyDataSource");
            webReport.Report.GetDataSource("MyDataSource").Enabled = true;
            webReport.Report.SetParameterValue("StartAt", ConvertToPersianDateString(startDate));
            webReport.Report.SetParameterValue("EndAt", ConvertToPersianDateString(endDate));
            webReport.Report.Prepare();

            using var pdfStream = new MemoryStream();
            var pdfExport = new PDFSimpleExport();
            webReport.Report.Export(pdfExport, pdfStream);
            return pdfStream.ToArray();
        }

        private DateTime ConvertPersianToGregorian(string persianDate)
        {
            var persianCalendar = new PersianCalendar();
            var dateParts = persianDate.Split('/');
            return persianCalendar.ToDateTime(
                int.Parse(dateParts[0]),
                int.Parse(dateParts[1]),
                int.Parse(dateParts[2]),
                0, 0, 0, 0);
        }

        private string ConvertToPersianDateString(DateTime date)
        {
            var persianCalendar = new PersianCalendar();
            return $"{persianCalendar.GetYear(date)}/{persianCalendar.GetMonth(date):00}/{persianCalendar.GetDayOfMonth(date):00}";
        }
    }
}

public class ConstructionLicenseReportModel
{
    public long Id { get; set; }
    public string DossierNumber { get; set; } = string.Empty;
    public string FirstName { get; set; } = string.Empty;
    public string LastName { get; set; } = string.Empty;
    public string NationalCode { get; set; } = string.Empty;
    public string EstateId { get; set; } = string.Empty;
    public string DossierSerial { get; set; } = string.Empty;
    public string RefNumber { get; set; } = string.Empty;
    public string LicenseNumber { get; set; } = string.Empty;
    public string TransitionalDossierNumber { get; set; } = string.Empty;
    public string TransitionalDossierSerial { get; set; } = string.Empty;
    public long DossierTypeId { get; set; }
}
