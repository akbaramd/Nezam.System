using System.ComponentModel.DataAnnotations;
using CedoLib.Report;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Velzon.Data.Cedo;
using Velzon.Models;

namespace Velzon.Pages.Report
{
  [Authorize]
  public class DossierAccountingReport(IServiceProvider provider) : PageModel
  {
    private readonly IServiceProvider _provider = provider;

    [BindProperty] public DossierAccountingFilterModel FilterModel { get; set; } = default!;

    public WebReport? WebReport { get; set; }
    public string ErrorMessage { get; set; } = string.Empty; // Property to hold the error message

    public void OnGet() { }

    public async Task<IActionResult> OnPostGenerateReport()
    {
      try
      {
        await SetupWebReportAsync();
      }
      catch (Exception ex)
      {
        ErrorMessage = "خطا در تولید گزارش: " + ex.Message; // Set the error message in Persian
        WebReport = null; // Ensure the report is not loaded
      }

      return Page();
    }

    public async Task<IActionResult> OnPostDownloadPdf()
    {
      try
      {
        await SetupWebReportAsync();

        using var pdfStream = new MemoryStream();
        var pdfExport = new PDFSimpleExport();
        WebReport?.Report.Export(pdfExport, pdfStream);
        pdfStream.Position = 0;

        return File(pdfStream.ToArray(), "application/pdf", $"{FilterModel.DossierNumber}_{Guid.NewGuid()}.pdf");
      }
      catch (Exception ex)
      {
        ErrorMessage = "خطا در تولید گزارش PDF: " + ex.Message; // Set the error message in Persian
        WebReport = null; // Ensure the report is not loaded
        return Page();
      }
    }

    private async Task SetupWebReportAsync()
    {
      var reportVm = await GetReportDataAsync();

      if (reportVm == null)
      {
        throw new Exception("مجوز ساخت یافت نشد.");
      }

      WebReport = new WebReport();
      WebReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "Untitled4.frx"));

      RegisterDataSources(WebReport.Report, reportVm);
      SetReportParameters(WebReport.Report, reportVm);
      WebReport.Report.Prepare();
    }

    private async Task<BillReportVm> GetReportDataAsync()
    {
      var ds = _provider.GetRequiredService<CedoContext>();
      var cl = ds.ConstructionLicenses.FirstOrDefault(x =>
        x.DossierNumber != null && x.DossierNumber.Equals(FilterModel.DossierNumber));

      if (cl == null)
      {
        throw new Exception("پرونده با این شماره یافت نشد.");
      }

      return await BillReportHelper.GetDossierInitialBillReportDataAsync(_provider, cl.Id);
    }

    private void RegisterDataSources(FastReport.Report report, BillReportVm reportVm)
    {
      report.RegisterData(FetchTblChangeData(reportVm).ToDataTable(), "tbl_change");
      report.RegisterData((reportVm.IntialBillDetails ?? new List<BillDetailReportVM>()).ToList().ToDataTable(),
        "IntialBillDetails");
      report.RegisterData((reportVm.SupervisorBillDetails ?? new List<BillDetailReportVM>()).ToList().ToDataTable(),
        "SupervisorBillDetails");
      report.RegisterData((reportVm.OtherBillDetails ?? new List<BillDetailReportVM>()).ToList().ToDataTable(),
        "OtherBillDetails");
      report.RegisterData((reportVm.BillPaymentDetails ?? new List<BillPaymentReportVM>()).ToList().ToDataTable(),
        "BillPaymentDetails");
    }

    private void SetReportParameters(FastReport.Report report, BillReportVm reportVm)
    {
      var reportParameters = FetchParameters(reportVm);

      foreach (var prop in reportParameters.GetType().GetProperties())
      {
        report.SetParameterValue(prop.Name, prop.GetValue(reportParameters));
      }
    }

  private ReportParameters FetchParameters(BillReportVm reportVm)
{
    // Calculate sums with fallbacks to 0 if collections are null
    long sumIntialBillDetails = reportVm.IntialBillDetails?.Sum(x => x.Amount + x.Tax) ?? 0;
    long sumOtherBillDetails = reportVm.OtherBillDetails?.Sum(x => x.Amount + x.Tax) ?? 0;
    long sumSupervisorBillDetails = reportVm.SupervisorBillDetails?.Sum(x => x.Amount + x.Tax) ?? 0;

    // Total sum of all bills
    long totalSumBills = sumIntialBillDetails + sumOtherBillDetails + sumSupervisorBillDetails;

    // Format the total sum to a string with commas as thousand separators
    string formattedSumBills = totalSumBills.ToString("##,###");

    // Fallback to an empty string if the formatted sum is empty or invalid
    string sumBills = !string.IsNullOrEmpty(formattedSumBills) ? formattedSumBills : string.Empty;

    // Calculate the sum of bill payments
    long sumBillPaymentDetails = reportVm.BillPaymentDetails?.Sum(x => x.Amount) ?? 0;
    string formattedSumBillPayments = sumBillPaymentDetails.ToString("##,###");

    // Determine the comment based on comparison
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

        // Calculate individual sums with fallbacks
        SumIntialBillDetails = sumIntialBillDetails.ToString("##,###"),
        SumSupervisorBillDetails = sumSupervisorBillDetails.ToString("##,###"),
        OtherBillDetails = sumOtherBillDetails.ToString("##,###"),

        // Total sum of all bills
        SumBills = sumBills,

        // Sum of bill payments
        SumBillPaymentDetails = formattedSumBillPayments,

        // Comment based on comparison
        comments = comment
    };
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
  }
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


public class Dtbl1Model
{
  public byte[] ArmSazman { get; set; } = default!;
}

public class ReportParameters
{
  public string maliat_rate { get; set; } = string.Empty;
  public string karbar_name { get; set; } = string.Empty;
  public string comments { get; set; } = string.Empty;
  public string sahm_nezarat { get; set; } = string.Empty;
  public string sahm_tarrahi { get; set; } = string.Empty;
  public string sahm_mojri { get; set; } = string.Empty;
  public string sahm_mechanic_khak { get; set; } = string.Empty;
  public string sum_sahm_1 { get; set; } = string.Empty;
  public string sahm_shanasname { get; set; } = string.Empty;
  public string sahm_nezarat_eng { get; set; } = string.Empty;
  public string sahm_nagshebardar { get; set; } = string.Empty;
  public string sum_sahm_2 { get; set; } = string.Empty;
  public string maliat_afzoodeh_shenasname { get; set; } = string.Empty;
  public string sum_maliyat_afzoodeh { get; set; } = string.Empty;
  public string tedad_tabage { get; set; } = string.Empty;
  public string tedad_sagf { get; set; } = string.Empty;
  public string trackcode { get; set; } = string.Empty;
  public string maliat_afzoodeh_sahm_nezarat { get; set; } = string.Empty;
  public string maliat_afzoodeh_sahm_tarrahi { get; set; } = string.Empty;
  public string maliat_afzoodeh_sahm_mojri { get; set; } = string.Empty;
  public string pardakht_saderat { get; set; } = string.Empty;
  public string pardakht_tejarat { get; set; } = string.Empty;
  public string bedehi_saderat { get; set; } = string.Empty;
  public string bedehi_tejarat { get; set; } = string.Empty;
  public string kol_saderat { get; set; } = string.Empty;
  public string kol_tejarat { get; set; } = string.Empty;
  public string sumCol1 { get; set; } = string.Empty;
  public string sumCol2 { get; set; } = string.Empty;
  public string malek_mob_no { get; set; } = string.Empty;
  public string malek_phone_no { get; set; } = string.Empty;
  public string malek_address { get; set; } = string.Empty;
  public string malek_mellicode { get; set; } = string.Empty;
  public string maliat_arzesh_rate { get; set; } = string.Empty;
  public string avarez_arzesh_rate { get; set; } = string.Empty;
  public string avarez_afzoodeh_shenasname { get; set; } = string.Empty;
  public string avarez_afzoodeh_sahm_nezarat { get; set; } = string.Empty;
  public string avarez_afzoodeh_sahm_tarrahi { get; set; } = string.Empty;
  public string avarez_afzoodeh_sahm_mojri { get; set; } = string.Empty;
  public string sahm_sandog_hemayati { get; set; } = string.Empty;
  public string shahrdari_name { get; set; } = string.Empty;
  public string bank_sazman { get; set; } = string.Empty;
  public string bank_erjaa { get; set; } = string.Empty;
  public string varizi_bank_sazman { get; set; } = string.Empty;
  public string varizi_bank_erjaa { get; set; } = string.Empty;
  public string bank_sazman_motamarkez { get; set; } = string.Empty;
  public string sum_sahm_daftar { get; set; } = string.Empty;
  public string varizi_bank_sazman_ostan { get; set; } = string.Empty;
  public string kol_tejarat_ostan { get; set; } = string.Empty;
  public string bedehi_tejarat_ostan { get; set; } = string.Empty;
  public string pardakht_tejarat_ostan { get; set; } = string.Empty;
  public string Dprint { get; set; } = string.Empty;
  public string avarez_afzoodeh_nagshebardar { get; set; } = string.Empty;
  public string sahm_nagshebardar_sazman { get; set; } = string.Empty;
  public string maliat_afzoodeh_nagshebardar { get; set; } = string.Empty;
  public string Sum_maliyat { get; set; } = string.Empty;
  public string Sum_avarez { get; set; } = string.Empty;
  public string sum_mablag_taaviz_naghshe { get; set; } = string.Empty;
  public string maliat_sum_mablag_taaviz_naghshe { get; set; } = string.Empty;
  public string avarez_sum_mablag_taaviz_naghshe { get; set; } = string.Empty;
  public string sahm_Geo_nazer { get; set; } = string.Empty;
  public string maliat_mechanic_khak { get; set; } = string.Empty;
  public string avarez_mechanic_khak { get; set; } = string.Empty;
  public string dossierNumber { get; set; } = string.Empty;
  public string sum_khak { get; set; } = string.Empty;
  public string controlTarrahLabel { get; set; } = string.Empty;
  public String SumIntialBillDetails { get; set; } = string.Empty;
  public String SumSupervisorBillDetails { get; set; } = string.Empty;
  public String SumBillPaymentDetails { get; set; } = string.Empty;
  public String SumBills { get; set; } = string.Empty;
  public String OtherBillDetails { get; set; } = string.Empty;
}

public class DossierAccountingFilterModel
{
  [Required(ErrorMessage = "شماره پرونده را وارد کنید")]
  public string DossierNumber { get; set; } = default!;
}
