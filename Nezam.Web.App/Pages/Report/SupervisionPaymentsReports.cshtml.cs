using System.ComponentModel.DataAnnotations;
using System.Drawing;
using System.Globalization;
using CedoLib.Report;
using DevExpress.Data.Linq.Helpers;
using FastReport.Export.Html;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data;
using Nezam.System.Web.Data.Cedo;
using Nezam.System.Web.Models;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using Velzon;

namespace Nezam.System.Web.Pages.Report;

[Authorize(Policy = "SupervisionPaymentsReports")]
public class SupervisionPaymentsReports : PageModel
{
    private readonly IServiceProvider _provider;

    public SupervisionPaymentsReports(IServiceProvider provider)
    {
        _provider = provider;
    }

    [BindProperty] public SupervisionPaymentsFilterModel FilterModel { get; set; } = new SupervisionPaymentsFilterModel();

    public List<SupervisionPaymentsDataVm> FilteredData { get; set; } = new List<SupervisionPaymentsDataVm>();
    public List<SelectListItem> Cities { get; set; } = new List<SelectListItem>();
    public List<SelectListItem> ServiceFields { get; set; } = new List<SelectListItem>();

    public async Task OnGetAsync()
    {
        // Populate the CitySyncCode dropdown
        var ds = _provider.GetRequiredService<CedoContext>();
        Cities = await ds.Cities
            .Select(c => new SelectListItem
            {
                Value = c.SyncCode.ToString(),
                Text = c.Name
            })
            .ToListAsync();
        
        ServiceFields = await ds.ServiceFields
          .Select(c => new SelectListItem
          {
            Value = c.Id.ToString(),
            Text = c.Title
          })
          .ToListAsync();
    }

  public async Task<IActionResult> OnPostAsync()
{
    var ds = _provider.GetRequiredService<CedoContext>();

    // Convert Persian dates to Gregorian
    var startAt = ConvertPersianDateToGregorian(FilterModel.StartAt);
    var endAt = ConvertPersianDateToGregorian(FilterModel.EndAt);
    
    // Query filtered data without conditional access expressions
    var res = ds.ConstructionLicenses
        .Include(cl => cl.Estate)
            .ThenInclude(e => e.Municipality)
                .ThenInclude(m => m.City)
        .Include(cl => cl.InvolvedMembers)
            .ThenInclude(im => im.SupervisionStepPayments)
                .ThenInclude(isp => isp.SupervisionStep)
        .Include(cl => cl.InvolvedMembers)
            .ThenInclude(im => im.SupervisionStepPayments)
                .ThenInclude(isp => isp.PaymentStatus)
        .Include(cl => cl.InvolvedMembers)
            .ThenInclude(im => im.MemberService)
                .ThenInclude(ms => ms.ActivityLicense)
                    .ThenInclude(al => al.Member)
                        .ThenInclude(mem => mem.User)
                            .ThenInclude(u => u.UserProfile)
        .Include(cl => cl.InvolvedMembers)
            .ThenInclude(im => im.MemberService)
                .ThenInclude(ms => ms.ServiceField)
        .Include(cl => cl.InvolvedMembers)
            .ThenInclude(im => im.MemberService)
                .ThenInclude(ms => ms.ActivityLicense)
                    .ThenInclude(al => al.Member)
                        .ThenInclude(mem => mem.MemberBankAcounts)
                        .Where(cl => cl.Estate.Municipality.City != null &&
                                     cl.DossierDate >= startAt &&
                                     cl.DossierDate <= endAt &&
                                     (FilterModel.CitySyncCodes == null || FilterModel.CitySyncCodes.Count == 0 || (cl.Estate.Municipality.City.SyncCode.HasValue && FilterModel.CitySyncCodes.Contains(cl.Estate.Municipality.City.SyncCode.Value))) &&
                                     (string.IsNullOrEmpty(FilterModel.DossierNumber) || cl.DossierNumber == FilterModel.DossierNumber) &&
                                     (string.IsNullOrEmpty(FilterModel.MembershipNumber) || cl.InvolvedMembers.Any(im => im.MemberService.ActivityLicense.Member.MembershipCode == FilterModel.MembershipNumber)) &&
                                     (FilterModel.ServiceFields == null || FilterModel.ServiceFields.Count == 0 || cl.InvolvedMembers.Any(im =>im.MemberService.ServiceFieldId.HasValue && FilterModel.ServiceFields.Contains(im.MemberService.ServiceFieldId.Value))));



    var ress =  res
      .SelectMany(cl => cl.InvolvedMembers)
      .Select(im => new SupervisionDataVm()
      {
        ConstructionLicenseId = im.ConstructionLicenseId,
        CityName =
          im.ConstructionLicense.Estate.Municipality.City != null
            ? im.ConstructionLicense.Estate.Municipality.City.Name
            : null,
        DossierNumber = im.ConstructionLicense.DossierNumber,
        DossierSerial = im.ConstructionLicense.DossierSerial,
        InvolvedMemberId = im.Id,
        FirstName =
          im.MemberService.ActivityLicense.Member.User.UserProfile != null
            ? im.MemberService.ActivityLicense.Member.User.UserProfile!.FirstName
            : null,
        LastName =
          im.MemberService.ActivityLicense.Member.User.UserProfile != null
            ? im.MemberService.ActivityLicense.Member.User.UserProfile!.LastName
            : null,
        Field = im.MemberService.ServiceField != null ? im.MemberService.ServiceField.Title : null,
        MembershipCode = im.MemberService.ActivityLicense.Member.MembershipCode,
        DossierFormalCode = im.ConstructionLicense.DossierFormalCode,
        MemberFormalCode = im.MemberService.ActivityLicense.Member.FormalCode,
        Payments = im.SupervisionStepPayments.Where(isp => !isp.IsCoordinatorPayment).ToList(),
        BankAccounts = im.MemberService.ActivityLicense.Member.MemberBankAcounts.ToList()
      })
      .Where(x => x.Payments.Any());
    

    // Convert to IEnumerable to perform grouping and other operations in memory
    FilteredData = ress.Select(x => new SupervisionPaymentsDataVm
        {
            ConstructionLicenseId = x.ConstructionLicenseId,
            CityName = x.CityName ?? "",
            DossierNumber = x.DossierNumber ?? "",
            DossierSerial = x.DossierSerial ?? "",
            InvolvedMemberId = x.InvolvedMemberId,
            FirstName = x.FirstName ?? "",
            LastName = x.LastName ?? "",
            Field = x.Field ?? "",
            MembershipCode = x.MembershipCode ?? "",
            DossierFormalCode = x.DossierFormalCode ?? "",
            MemberFormalCode = x.MemberFormalCode ?? "",
            Payment1Amount = x.Payments.Where(p => p.SupervisionStep == null).Max(p => (decimal?)p.Amount) ?? 0,
            Payment1Remaining = x.Payments.Where(p => p.SupervisionStep == null).Max(p => (decimal?)p.RemainingAmount) ?? 0,
            Payment1Status = x.Payments.Where(p => p.SupervisionStep == null).Max(p => p.PaymentStatus.Title) ?? "",
            Payment2Amount = x.Payments.Where(p => p.SupervisionStep != null && p.SupervisionStep.FormNumber == 2 && new[] { 1, 3, 4, 5, 6 }.Contains(p.SupervisionStep!.FieldId)).Max(p => (decimal?)p.Amount) ?? 0,
            Payment2Remaining = x.Payments.Where(p => p.SupervisionStep != null && p.SupervisionStep.FormNumber == 2 && new[] { 1, 3, 4, 5, 6 }.Contains(p.SupervisionStep!.FieldId)).Max(p => (decimal?)p.RemainingAmount) ?? 0,
            Payment2Status = x.Payments.Where(p => p.SupervisionStep != null && p.SupervisionStep.FormNumber == 2 && new[] { 1, 3, 4, 5, 6 }.Contains(p.SupervisionStep.FieldId)).Max(p => p.PaymentStatus.Title) ?? "",
            Payment3Amount = x.Payments.Where(p => p.SupervisionStep != null && p.SupervisionStep.FormNumber == 3 && new[] { 1, 3, 4, 5, 6 }.Contains(p.SupervisionStep.FieldId)).Max(p => (decimal?)p.Amount) ?? 0,
            Payment3Remaining = x.Payments.Where(p => p.SupervisionStep != null && p.SupervisionStep.FormNumber == 3 && new[] { 1, 3, 4, 5, 6 }.Contains(p.SupervisionStep.FieldId)).Max(p => (decimal?)p.RemainingAmount) ?? 0,
            Payment3Status = x.Payments.Where(p => p.SupervisionStep != null && p.SupervisionStep.FormNumber == 3 && new[] { 1, 3, 4, 5, 6 }.Contains(p.SupervisionStep.FieldId)).Max(p => p.PaymentStatus.Title) ?? "",
            FinalRemainingAmount = x.Payments.Any() ?x.Payments.OrderBy(x=>x.Id).Last().RemainingAmount : 0,
            AccountNumber1 = x.BankAccounts.Any(mba => mba.BankAcountTypeId == 1)?x.BankAccounts.First(mba => mba.BankAcountTypeId == 1).AcountNumber : string.Empty,
            AccountNumber2 = x.BankAccounts.Any(mba => mba.BankAcountTypeId == 5)?x.BankAccounts.First(mba => mba.BankAcountTypeId == 5).AcountNumber : string.Empty,
        }
        
    )
    .ToList();

    // Repopulate the CitySyncCode dropdown after post
    Cities = await ds.Cities
        .Select(c => new SelectListItem
        {
            Value = c.SyncCode.ToString(),
            Text = c.Name ?? ""
        })
        .ToListAsync();



    ExcelPackage.LicenseContext = LicenseContext.Commercial;
        var package = new ExcelPackage();
    var worksheet = package.Workbook.Worksheets.Add("SupervisionPaymentsReport");

     worksheet.View.RightToLeft = true;

    // Set Persian font (B Nazanin) for all cells
    worksheet.Cells.Style.Font.Name = "B Nazanin";
    worksheet.Cells.Style.Font.Size = 12;

    // Add header with Persian titles
    worksheet.Cells[1, 1].Value = "شماره پروانه";
    worksheet.Cells[1, 2].Value = "نام شهر";
    worksheet.Cells[1, 3].Value = "شماره پرونده";
    worksheet.Cells[1, 4].Value = "سال پرونده"; // Year of the Dossier
    worksheet.Cells[1, 5].Value = "سری پرونده"; // Series of the Dossier
    worksheet.Cells[1, 6].Value = "شماره عضویت";
    worksheet.Cells[1, 7].Value = "نام";
    worksheet.Cells[1, 8].Value = "نام خانوادگی";
    worksheet.Cells[1, 9].Value = "رشته";
    worksheet.Cells[1, 10].Value = "کد تفصیلی پرونده";
    worksheet.Cells[1, 11].Value = "کد تفصیلی کاربر";
    worksheet.Cells[1, 12].Value = "مبلغ پرداخت اول";
    worksheet.Cells[1, 13].Value = "مبلغ باقی‌مانده پرداخت اول";
    worksheet.Cells[1, 14].Value = "وضعیت پرداخت اول";
    worksheet.Cells[1, 15].Value = "مبلغ پرداخت دوم";
    worksheet.Cells[1, 16].Value = "مبلغ باقی‌مانده پرداخت دوم";
    worksheet.Cells[1, 17].Value = "وضعیت پرداخت دوم";
    worksheet.Cells[1, 18].Value = "مبلغ پرداخت سوم";
    worksheet.Cells[1, 19].Value = "مبلغ باقی‌مانده پرداخت سوم";
    worksheet.Cells[1, 20].Value = "وضعیت پرداخت سوم";
    worksheet.Cells[1, 21].Value = "مبلغ باقی‌مانده";
    worksheet.Cells[1, 22].Value = "شماره حساب 1";
    worksheet.Cells[1, 23].Value = "شماره حساب 2";
    
    
// Format header
using (var range = worksheet.Cells[1, 1, 1, 23])
{
    range.Style.Font.Bold = true;
    range.Style.Fill.PatternType = ExcelFillStyle.Solid;
    range.Style.Fill.BackgroundColor.SetColor(Color.LightGray);
    range.Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
}

// Add rows
for (var i = 0; i < FilteredData.Count; i++)
{
    var item = FilteredData[i];
    worksheet.Cells[i + 2, 1].Value = item.ConstructionLicenseId;
    worksheet.Cells[i + 2, 2].Value = item.CityName;
    worksheet.Cells[i + 2, 3].Value = item.DossierNumber;

    // Split "شماره سریال" into "سال پرونده" and "سری پرونده"
    var serialParts = item.DossierSerial?.Split('-');
    worksheet.Cells[i + 2, 4].Value = serialParts?.Length > 1 ? serialParts[1] : string.Empty; // Year of the Dossier
    worksheet.Cells[i + 2, 5].Value = serialParts?.Length > 2 ? serialParts[2] : string.Empty; // Series of the Dossier

    worksheet.Cells[i + 2, 6].Value = item.MembershipCode;
    worksheet.Cells[i + 2, 7].Value = item.FirstName;
    worksheet.Cells[i + 2, 8].Value = item.LastName;
    worksheet.Cells[i + 2, 9].Value = item.Field;
    worksheet.Cells[i + 2, 10].Value = item.DossierFormalCode;
    worksheet.Cells[i + 2, 11].Value = item.MemberFormalCode;

    // Payment 1 - Light Green
    worksheet.Cells[i + 2, 12].Value = item.Payment1Amount;
    worksheet.Cells[i + 2, 12].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 12].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(198, 239, 206)); // Light green

    worksheet.Cells[i + 2, 13].Value = item.Payment1Remaining;
    worksheet.Cells[i + 2, 13].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 13].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(198, 239, 206)); // Light green

    worksheet.Cells[i + 2, 14].Value = item.Payment1Status;
    worksheet.Cells[i + 2, 14].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 14].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(198, 239, 206)); // Light green

    // Payment 2 - Medium Green
    worksheet.Cells[i + 2, 15].Value = item.Payment2Amount;
    worksheet.Cells[i + 2, 15].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 15].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(147, 196, 125)); // Medium green

    worksheet.Cells[i + 2, 16].Value = item.Payment2Remaining;
    worksheet.Cells[i + 2, 16].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 16].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(147, 196, 125)); // Medium green

    worksheet.Cells[i + 2, 17].Value = item.Payment2Status;
    worksheet.Cells[i + 2, 17].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 17].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(147, 196, 125)); // Medium green

    // Payment 3 - Dark Green
    worksheet.Cells[i + 2, 18].Value = item.Payment3Amount;
    worksheet.Cells[i + 2, 18].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 18].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(106, 168, 79)); // Dark green

    worksheet.Cells[i + 2, 19].Value = item.Payment3Remaining;
    worksheet.Cells[i + 2, 19].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 19].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(106, 168, 79)); // Dark green

    worksheet.Cells[i + 2, 20].Value = item.Payment3Status;
    worksheet.Cells[i + 2, 20].Style.Fill.PatternType = ExcelFillStyle.Solid;
    worksheet.Cells[i + 2, 20].Style.Fill.BackgroundColor.SetColor(Color.FromArgb(106, 168, 79)); // Dark green

    worksheet.Cells[i + 2, 21].Value = item.FinalRemainingAmount;
    worksheet.Cells[i + 2, 22].Value = item.AccountNumber1;
    worksheet.Cells[i + 2, 23].Value = item.AccountNumber2;
}
worksheet.Cells[worksheet.Dimension.Address].AutoFitColumns();

// Apply gray border to all cells in the worksheet (including headers)
using (var range = worksheet.Cells[1, 1, worksheet.Dimension.End.Row, worksheet.Dimension.End.Column])
{
  range.Style.Border.Top.Style = ExcelBorderStyle.Thin;
  range.Style.Border.Bottom.Style = ExcelBorderStyle.Thin;
  range.Style.Border.Left.Style = ExcelBorderStyle.Thin;
  range.Style.Border.Right.Style = ExcelBorderStyle.Thin;
  range.Style.Border.Top.Color.SetColor(Color.Gray);
  range.Style.Border.Bottom.Color.SetColor(Color.Gray);
  range.Style.Border.Left.Color.SetColor(Color.Gray);
  range.Style.Border.Right.Color.SetColor(Color.Gray);
}
    var stream = new MemoryStream();
    package.SaveAs(stream);
    var content = stream.ToArray();
    var fileName = $"SupervisionPaymentsReport_{FilterModel.StartAt}_{FilterModel.EndAt}";

    if (!string.IsNullOrEmpty(FilterModel.DossierNumber))
    {
      fileName += $"_Dossier_{FilterModel.DossierNumber}";
    }

    if (!string.IsNullOrEmpty(FilterModel.MembershipNumber))
    {
      fileName += $"_Membership_{FilterModel.MembershipNumber}";
    }

    fileName += ".xlsx";
    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
}


  private DateTime ConvertPersianDateToGregorian(string persianDate)
  {
    PersianCalendar persianCalendar = new PersianCalendar();
    var dateParts = persianDate.Split('-');
    var year = int.Parse(dateParts[0]);
    var month = int.Parse(dateParts[1]);
    var day = int.Parse(dateParts[2]);
    return persianCalendar.ToDateTime(year, month, day, 0, 0, 0, 0);
  }

}


public class SupervisionPaymentsFilterModel
{

  public List<int>? CitySyncCodes { get; set; } = new List<int>();

  [Required(ErrorMessage = "تاریخ شروع را انتخاب کنید")]
  public string StartAt { get; set; } = string.Empty; // Persian date format (1402/01/01)

  [Required(ErrorMessage = "تاریخ پایان را انتخاب کنید")]
  public string EndAt { get; set; } = string.Empty; // Persian date format (1402/01/01)

  public string? DossierNumber { get; set; }
  public string? MembershipNumber { get; set; }
  public List<int>? ServiceFields { get; set; } = new List<int>();
}

public class SupervisionDataVm
{
  public int ConstructionLicenseId { get; set; }
  public string? CityName { get; set; }
  public string? DossierNumber { get; set; }
  public string? DossierSerial { get; set; }
  public int InvolvedMemberId { get; set; }
  public string? FirstName { get; set; }
  public string? LastName { get; set; }
  public string? Field { get; set; }
  public string? MembershipCode { get; set; }
  public string? DossierFormalCode { get; set; }
  public string? MemberFormalCode { get; set; }
  public List<SupervisionStepPayment> Payments { get; set; } = new List<SupervisionStepPayment>();
  public List<MemberBankAcount> BankAccounts { get; set; } = new List<MemberBankAcount>();
}

public class SupervisionPaymentsDataVm
{
    public int ConstructionLicenseId { get; set; }          // ID of the construction license
    public string CityName { get; set; } = string.Empty;     // Name of the city
    public string DossierNumber { get; set; } = string.Empty; // Dossier number
    public string DossierSerial { get; set; } = string.Empty; // Dossier serial number
    public int InvolvedMemberId { get; set; }               // ID of the involved member
    public string FirstName { get; set; } = string.Empty;    // First name of the member
    public string LastName { get; set; } = string.Empty;     // Last name of the member
    public string Field { get; set; } = string.Empty;        // Title of the service field
    public string MembershipCode { get; set; } = string.Empty; // Membership code
    public string? DossierFormalCode { get; set; }
    public string? MemberFormalCode { get; set; }

    // Payment details
    public decimal? Payment1Amount { get; set; }             // Amount for the first payment
    public decimal? Payment1Remaining { get; set; }          // Remaining amount for the first payment
    public string? Payment1Status { get; set; } = string.Empty; // Status of the first payment

    public decimal? Payment2Amount { get; set; }             // Amount for the second payment
    public decimal? Payment2Remaining { get; set; }          // Remaining amount for the second payment
    public string? Payment2Status { get; set; } = string.Empty; // Status of the second payment

    public decimal? Payment3Amount { get; set; }             // Amount for the third payment
    public decimal? Payment3Remaining { get; set; }          // Remaining amount for the third payment
    public string? Payment3Status { get; set; } = string.Empty; // Status of the third payment

    // Final remaining amount based on the latest payment
    public decimal? FinalRemainingAmount { get; set; }

    // Bank account numbers
    public string? AccountNumber1 { get; set; }              // Account number of type 1
    public string? AccountNumber2 { get; set; }              // Account number of type 5
}
