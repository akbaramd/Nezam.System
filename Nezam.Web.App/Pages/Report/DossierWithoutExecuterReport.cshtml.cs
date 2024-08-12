using System.Data.SqlClient;
using System.Globalization;
using Dapper;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Velzon.Controllers;
using Velzon.Models;

namespace Velzon.Pages.Report
{
    [Authorize]
    public class DossierWithoutExecuterReportModel : PageModel
    {
        private readonly string _connectionString =
            "Data Source=192.168.200.7\\SQL2019;Initial Catalog=CEDOWA-RT-V2;Persist Security Info=True;User ID=sa;Password=vhdSAM@15114;MultipleActiveResultSets=True;App=EntityFramework;TrustServerCertificate=True";

        [BindProperty] public ReportFilterViewModel FilterModel { get; set; } = default!;

        public WebReport WebReport { get; set; } = default!;

     
        public void OnGet()
        {
          // Initialize FilterModel
          if (FilterModel == null)
          {
            FilterModel = new ReportFilterViewModel
            {
              StartDate = ConvertToPersianDateString(DateTime.Now.AddMonths(-1)),
              EndDate = ConvertToPersianDateString(DateTime.Now),
              Year = DateTime.Now.Year
            };
          }

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

            // Use Dapper to execute the query
            IEnumerable<ConstructionLicenseReportModel> data;
            using (var connection = new SqlConnection(_connectionString))
            {
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

                data = connection.Query<ConstructionLicenseReportModel>(query, new 
                { 
                    StartDate = startDate, 
                    EndDate = endDate, 
                    SyncCode = FilterModel.SelectedSyncCode, 
                    DossierTypeId = FilterModel.SelectedDossierTypeId 
                });
            }

            // Convert the result to DataTable
            var dataTable = data.ToDataTable();

            // Create a new WebReport instance
            WebReport = new WebReport();

            WebReport.Toolbar.ShowPrint = false;
            WebReport.Toolbar.Exports.ExportTypes = Exports.Excel2007;
            WebReport.Toolbar.Exports.ShowPreparedReport = false;
            WebReport.Toolbar.Exports.Show = true;

            // Load the report file
            WebReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled.frx"));

            // Register the DataTable as a data source for the report
            WebReport.Report.RegisterData(dataTable, "MyDataSource");

            // Enable the data source
            var dataSource = WebReport.Report.GetDataSource("MyDataSource");
            dataSource.Enabled = true;

            // Set Gregorian dates as parameters
            WebReport.Report.SetParameterValue("StartAt", ConvertToPersianDateString(startDate));
            WebReport.Report.SetParameterValue("EndAt", ConvertToPersianDateString(endDate));

            return Page();
        }

        public IActionResult OnPostDownloadPdf()
        {
            if (!ModelState.IsValid)
            {
                PopulateFilterDropdowns(FilterModel);
                return Page();
            }

            DateTime startDate = ConvertPersianToGregorian(FilterModel.StartDate);
            DateTime endDate = ConvertPersianToGregorian(FilterModel.EndDate);

            IEnumerable<ConstructionLicenseReportModel> data;
            using (var connection = new SqlConnection(_connectionString))
            {
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

                data = connection.Query<ConstructionLicenseReportModel>(query, new 
                { 
                    StartDate = startDate, 
                    EndDate = endDate, 
                    SyncCode = FilterModel.SelectedSyncCode, 
                    DossierTypeId = FilterModel.SelectedDossierTypeId 
                });
            }

            var dataTable = data.ToDataTable();
            var webReport = new WebReport();

            webReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled.frx"));
            webReport.Report.RegisterData(dataTable, "MyDataSource");
            webReport.Report.GetDataSource("MyDataSource").Enabled = true;
            webReport.Report.SetParameterValue("StartAt", ConvertToPersianDateString(startDate));
            webReport.Report.SetParameterValue("EndAt", ConvertToPersianDateString(endDate));
            webReport.Report.Prepare();

            using (MemoryStream pdfStream = new MemoryStream())
            {
                var pdfExport = new PDFSimpleExport();
                webReport.Report.Export(pdfExport, pdfStream);
                pdfStream.Position = 0;

                return File(pdfStream.ToArray(), "application/pdf", "DossierReport.pdf");
            }
        }

        private void PopulateFilterDropdowns(ReportFilterViewModel model)
        {
            using var connection = new SqlConnection(_connectionString);
            connection.Open();

            var dossierTypesQuery = "SELECT Id, Title FROM [cedo].[DossierType]";
            var dossierTypes = connection.Query(dossierTypesQuery).Select(x => new SelectListItem
            {
                Value = x.Id.ToString(), Text = x.Title
            }).ToList();
            dossierTypes.Insert(0, new SelectListItem { Value = "0", Text = "همه" });

            var citiesQuery = "SELECT SyncCode, Name FROM [cedo].[Cities] WHERE SyncCode IS NOT NULL";
            var cities = connection.Query(citiesQuery).Select(x => new SelectListItem
            {
                Value = x.SyncCode.ToString(), Text = x.Name
            }).ToList();
            cities.Insert(0, new SelectListItem { Value = "0", Text = "همه" });

            model.DossierTypes = dossierTypes;
            model.Cities = cities;
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