using Microsoft.AspNetCore.Mvc.Rendering;
using System.ComponentModel.DataAnnotations;

namespace Velzon.Models;

public class ReportFilterViewModel
{
  [Required(ErrorMessage = "تاریخ شروع را وارد کنید")]
  public string StartDate { get; set; } = default!;

  [Required(ErrorMessage = "تاریخ پایان را وارد کنید")]
  public string EndDate { get; set; } = default!;

  [Required(ErrorMessage = "سال را وارد کنید")]
  public int Year { get; set; }

  [Required(ErrorMessage = "نوع پرونده را انتخاب کنید")]
  public int SelectedDossierTypeId { get; set; }

  public List<SelectListItem> DossierTypes { get; set; } = new List<SelectListItem>();

  [Required(ErrorMessage = "شهر را انتخاب کنید")]
  public int SelectedSyncCode { get; set; } = default!;

  public List<SelectListItem> Cities { get; set; } = new List<SelectListItem>();
}
