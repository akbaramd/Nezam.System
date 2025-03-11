using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using CedoLib.Report;
using FastReport.Export.Html;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data;
using Nezam.System.Web.Data.Cedo;
using Nezam.System.Web.Models;
using Velzon;

namespace Nezam.System.Web.Pages.Report;

[Authorize(Policy = "DossierAccountingReport")]
public class DossierAccountingReport : PageModel
{
    private readonly IServiceProvider _provider;

    public DossierAccountingReport(IServiceProvider provider)
    {
        _provider = provider;
    }

    [BindProperty] public DossierAccountingFilterModel FilterModel { get; set; } = new DossierAccountingFilterModel();

    public WebReport? WebReport { get; set; }
    public string ErrorMessage { get; set; } = string.Empty;

    public void OnGet()
    {
      
    }

    public async Task<JsonResult> OnPostAsync()
    {
        try
        {
            // Get the current user's agencies
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var appDbContext = _provider.GetRequiredService<AppDbContext>();
            var userAgencies = await appDbContext.UserAgencies
                .Where(ua => currentUserId != null && ua.UserId == Guid.Parse(currentUserId))
                .Select(ua => ua.AgencyCode)
                .ToListAsync();
          
            var reportVm = await GetReportDataAsync(FilterModel.DossierNumber, userAgencies);

            if (reportVm == null)
            {
              throw new Exception("پرونده با این شماره یافت نشد یا شما دسترسی به پرونده در شهر دیگر ندارید.");
            }

            await SetupWebReportAsync(reportVm);
            return new JsonResult(new { success = true, reportHtml = await RenderReportAsync() });
        }
        catch (Exception ex)
        {
            return new JsonResult(new { success = false, errorMessage = "خطا در تولید گزارش: " + ex.Message });
        }
    }

    public async Task<IActionResult> OnPostDownloadPdf(string dossierNumber)
    {
        try
        {
            // Get the current user's agencies
            var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
            var appDbContext = _provider.GetRequiredService<AppDbContext>();
            var userAgencies = await appDbContext.UserAgencies
                .Where(ua => currentUserId != null && ua.UserId == Guid.Parse(currentUserId))
                .Select(ua => ua.AgencyCode)
                .ToListAsync();
          
            var reportVm = await GetReportDataAsync(dossierNumber, userAgencies);

            if (reportVm == null)
            {
                throw new Exception("پرونده با این شماره یافت نشد یا شما دسترسی به پرونده در شهر دیگر ندارید.");
            }

            await SetupWebReportAsync(reportVm);

            using var pdfStream = new MemoryStream();
            var pdfExport = new PDFSimpleExport();
            WebReport?.Report.Export(pdfExport, pdfStream);
            pdfStream.Position = 0;

            return File(pdfStream.ToArray(), "application/pdf", $"{reportVm.DossierNumber}_{Guid.NewGuid()}.pdf");
        }
        catch (Exception ex)
        {
            return new JsonResult(new { success = false, errorMessage = "خطا در تولید گزارش PDF: " + ex.Message });
        }
    }

    private Task SetupWebReportAsync(BillReportVm reportVm)
    {
        WebReport = new WebReport();
        WebReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "DossierAccountingReport.frx"));

        RegisterDataSources(WebReport.Report, reportVm);
        SetReportParameters(WebReport.Report, reportVm);
        WebReport.Report.Prepare();
        return Task.CompletedTask;
    }

    private async Task<BillReportVm?> GetReportDataAsync(string dossierNumber, List<int>? userAgencies = null)
    {
        var ds = _provider.GetRequiredService<CedoContext>();
        
        // Query construction license with city information
        var query = ds.ConstructionLicenses
            .Include(cl => cl.Estate)
            .ThenInclude(e => e.Municipality)
            .ThenInclude(m => m.City)
            .Where(cl => cl.DossierNumber != null && cl.DossierNumber.Equals(dossierNumber));
        
        // Apply agency access control if user has agencies
        if (userAgencies != null && userAgencies.Any())
        {
            query = query.Where(cl => 
                cl.Estate.Municipality.City != null && 
                cl.Estate.Municipality.City.SyncCode.HasValue && 
                userAgencies.Contains(cl.Estate.Municipality.City.SyncCode.Value));
        }
        
        var cl = await query.FirstOrDefaultAsync();

        if (cl == null)
        {
            return null;
        }

        return await BillReportHelper.GetDossierInitialBillReportDataAsync(_provider, cl.Id);
    }

    private void RegisterDataSources(FastReport.Report report, BillReportVm reportVm)
    {
        report.RegisterData(FetchTblChangeData(reportVm).ToDataTable(), "tbl_change");
        report.RegisterData((reportVm.IntialBillDetails ?? new List<BillDetailReportVM>()).ToList().ToDataTable(), "IntialBillDetails");
        report.RegisterData((reportVm.SupervisorBillDetails ?? new List<BillDetailReportVM>()).ToList().ToDataTable(), "SupervisorBillDetails");
        report.RegisterData((reportVm.OtherBillDetails ?? new List<BillDetailReportVM>()).ToList().ToDataTable(), "OtherBillDetails");
        report.RegisterData((reportVm.BillPaymentDetails ?? new List<BillPaymentReportVM>()).ToList().ToDataTable(), "BillPaymentDetails");
    }

    private void SetReportParameters(FastReport.Report report, BillReportVm reportVm)
    {
        var reportParameters = FetchParameters(reportVm);
        foreach (var prop in reportParameters.GetType().GetProperties())
        {
            report.SetParameterValue(prop.Name, prop.GetValue(reportParameters));
        }
    }

    private List<TblChangeModel> FetchTblChangeData(BillReportVm reportVm)
    {
        return new List<TblChangeModel>
        {
            new()
            {
                sabt_date = reportVm.PersianRegDate ?? string.Empty,
                sabt_no = reportVm.DossierSerial ?? string.Empty,
                change = reportVm.DossierType,
                metraj = Convert.ToDouble(reportVm.Metraje),
                gorooh = reportVm.BuildingGroup ?? string.Empty,
                malek_full_name = reportVm.OwnerName,
                dastoor_date = reportVm.PersianRegDate ?? string.Empty,
                dastoor_no = reportVm.LicenseNumber
            }
        };
    }

    private async Task<string> RenderReportAsync()
    {
        using var memoryStream = new MemoryStream();
        WebReport?.Report.Export(new HTMLExport(), memoryStream);
        memoryStream.Position = 0;
        using var reader = new StreamReader(memoryStream);
        return await reader.ReadToEndAsync();
    }

    private ReportParameters FetchParameters(BillReportVm reportVm)
    {
        long sumIntialBillDetails = reportVm.IntialBillDetails?.Sum(x => x.Amount + x.Tax) ?? 0;
        long sumOtherBillDetails = reportVm.OtherBillDetails?.Sum(x => x.Amount + x.Tax) ?? 0;
        long sumSupervisorBillDetails = reportVm.SupervisorBillDetails?.Sum(x => x.Amount + x.Tax) ?? 0;

        long totalSumBills = sumIntialBillDetails + sumOtherBillDetails + sumSupervisorBillDetails;
        string formattedSumBills = totalSumBills.ToString("##,###");
        string sumBills = !string.IsNullOrEmpty(formattedSumBills) ? formattedSumBills : string.Empty;

        long sumBillPaymentDetails = reportVm.BillPaymentDetails?.Sum(x => x.Amount) ?? 0;
        string formattedSumBillPayments = sumBillPaymentDetails.ToString("##,###");

        string comment = string.Empty;
        if (totalSumBills > 0 && sumBillPaymentDetails > 0)
        {
            if (totalSumBills == sumBillPaymentDetails)
            {
                comment = $"مالک {reportVm.OwnerName} برای پرونده {reportVm.DossierNumber} هیچ‌گونه بدهی یا بستانکاری ندارد و صورتحساب‌ها و واریزی‌ها برابر می‌باشند.";
            }
            else if (totalSumBills > sumBillPaymentDetails)
            {
                long debtAmount = totalSumBills - sumBillPaymentDetails;
                string formattedDebtAmount = debtAmount.ToString("##,###");
                comment = $"مالک {reportVm.OwnerName} برای پرونده {reportVm.DossierNumber} دارای بدهی به مبلغ {formattedDebtAmount} ریال می‌باشد.";
            }
            else
            {
                long creditAmount = sumBillPaymentDetails - totalSumBills;
                string formattedCreditAmount = creditAmount.ToString("##,###");
                comment = $"مالک {reportVm.OwnerName} برای پرونده {reportVm.DossierNumber} دارای بستانکاری به مبلغ {formattedCreditAmount} ریال می‌باشد.";
            }
        }

        return new ReportParameters
        {
            dossierNumber = reportVm.DossierNumber ?? string.Empty,
            malek_mellicode = reportVm.OwnerNationalCode ?? string.Empty,
            malek_address = reportVm.Address ?? string.Empty,
            malek_mob_no = reportVm.OwnerMobile ?? string.Empty,
            malek_phone_no = reportVm.OwnerPhone ?? string.Empty,
            shahrdari_name = reportVm.MunicipalityName ?? string.Empty,
            tedad_sagf = reportVm.FloorCount ?? string.Empty,
            tedad_tabage = reportVm.FloorCount ?? string.Empty,
            SumIntialBillDetails = sumIntialBillDetails.ToString("##,###"),
            SumSupervisorBillDetails = sumSupervisorBillDetails.ToString("##,###"),
            OtherBillDetails = sumOtherBillDetails.ToString("##,###"),
            SumBills = sumBills,
            SumBillPaymentDetails = formattedSumBillPayments,
            comments = comment
        };
    }
}

public class DossierAccountingFilterModel
{
    [Required(ErrorMessage = "شماره پرونده را وارد کنید")]
    public string DossierNumber { get; set; } = default!;
}

public class TblChangeModel
{
    public string sabt_no { get; set; } = string.Empty;
    public long ozviyat_no { get; set; }
    public int gorooh_cod { get; set; }
    public double tedad_cod { get; set; }
    public string name { get; set; } = string.Empty;
    public string fname { get; set; } = string.Empty;
    public string title { get; set; } = string.Empty;
    public double nezarat { get; set; }
    public double tarrahi { get; set; }
    public string daftar_fanni_no { get; set; } = string.Empty;
    public int tafavot_metraj { get; set; }
    public int sal { get; set; }
    public string sabt_date { get; set; } = string.Empty;
    public string malekname { get; set; } = string.Empty;
    public string malekfname { get; set; } = string.Empty;
    public string dastoor_no { get; set; } = string.Empty;
    public string dastoor_date { get; set; } = string.Empty;
    public string pelak_no { get; set; } = string.Empty;
    public double metraj { get; set; }
    public string daftar_no { get; set; } = string.Empty;
    public string mantageh { get; set; } = string.Empty;
    public string gorooh { get; set; } = string.Empty;
    public string change { get; set; } = string.Empty;
    public int metraj_gabl { get; set; }
    public int sal1 { get; set; }
    public int Expr1 { get; set; }
    public string comment { get; set; } = string.Empty;
    public double n_tedad { get; set; }
    public double tkoll { get; set; }
    public double t_tedad { get; set; }
    public string eng_full_name { get; set; } = string.Empty;
    public string eng_mob { get; set; } = string.Empty;
    public string malek_full_name { get; set; } = string.Empty;
    public int pnezarat_cod { get; set; }
    public int ptarrahi_cod { get; set; }
}

public class ReportParameters
{
    public string dossierNumber { get; set; } = string.Empty;
    public string malek_mellicode { get; set; } = string.Empty;
    public string malek_address { get; set; } = string.Empty;
    public string malek_mob_no { get; set; } = string.Empty;
    public string malek_phone_no { get; set; } = string.Empty;
    public string shahrdari_name { get; set; } = string.Empty;
    public string tedad_sagf { get; set; } = string.Empty;
    public string tedad_tabage { get; set; } = string.Empty;
    public string SumIntialBillDetails { get; set; } = string.Empty;
    public string SumSupervisorBillDetails { get; set; } = string.Empty;
    public string OtherBillDetails { get; set; } = string.Empty;
    public string SumBills { get; set; } = string.Empty;
    public string SumBillPaymentDetails { get; set; } = string.Empty;
    public string comments { get; set; } = string.Empty;
}
