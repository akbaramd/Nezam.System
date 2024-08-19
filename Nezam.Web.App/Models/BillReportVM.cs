using System.Globalization;

namespace Velzon.Models
{
  public class BillReportVm
  {
    public string? DossierNumber {get; set;} =default!;
    public string? DossierSerial {get; set;} =default!;
    public string DossierType {get; set;} =default!;
    public string OwnerName {get; set;} =default!;
    public string? OwnerPhone {get; set;} =default!;
    public string? OwnerNationalCode {get; set;} =default!;
    public string MunicipalityName {get; set;} =default!;
    public string LicenseNumber {get; set;} =default!;
    public string? RegDate {get; set;} =default!;
    
    public string? PersianRegDate
    {
      get
      {
        if (DateTime.TryParse(RegDate, out DateTime gregorianDate))
        {
          var persianCalendar = new PersianCalendar();
          int year = persianCalendar.GetYear(gregorianDate);
          int month = persianCalendar.GetMonth(gregorianDate);
          int day = persianCalendar.GetDayOfMonth(gregorianDate);
          int hour = gregorianDate.Hour;
          int minute = gregorianDate.Minute;

          // Format the Persian date and time as yyyy/MM/dd HH:mm
          return $"{year}/{month:D2}/{day:D2} {hour:D2}:{minute:D2}";
        }
        return null;
      }
    }
    public string? Address {get; set;} =default!;
    public string? OwnerMobile{get; set;} =default!;
    public string Metraje {get; set;} =default!;
    public string? BuildingGroup {get; set;} =default!;
    public string FloorCount {get; set;} =default!;
    public List<BillDetailReportVM>? IntialBillDetails {get; set;} =default!;
    public List<BillDetailReportVM>? SupervisorBillDetails {get; set;} =default!;
    public List<BillDetailReportVM>? OtherBillDetails {get; set;} =default!;
    public List<BillPaymentReportVM>? BillPaymentDetails {get; set;} =default!;
  }

  public class BillDetailReportVM 
  {
    public int Index {get; set;}
    public string Title { get; set; } = default!;
    public long Amount {get; set;}
    public long Tax {get; set;}
    public string FormatedAmount
    {
      get
      {
        return Amount.ToString("##,###");
      }
    }
  }

  public class BillPaymentReportVM 
  {
    public int Index {get; set;}
    public string? BillPaymentCode {get; set;}= default!;
    public long Amount {get; set;}

    public string FormatedAmount
    {
      get
      {
        return Amount.ToString("##,###");
      }
    }

    public string? RegDate {get; set;} = default!;

    public string? PersianRegDate
    {
      get
      {
        if (DateTime.TryParse(RegDate, out DateTime gregorianDate))
        {
          var persianCalendar = new PersianCalendar();
          int year = persianCalendar.GetYear(gregorianDate);
          int month = persianCalendar.GetMonth(gregorianDate);
          int day = persianCalendar.GetDayOfMonth(gregorianDate);
          int hour = gregorianDate.Hour;
          int minute = gregorianDate.Minute;

          // Format the Persian date and time as yyyy/MM/dd HH:mm
          return $"{year}/{month:D2}/{day:D2} {hour:D2}:{minute:D2}";
        }
        return null;
      }
    }

    public string RRN {get; set;}= default!;
  }
}
