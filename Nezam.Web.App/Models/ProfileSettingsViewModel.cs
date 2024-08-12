using System.ComponentModel.DataAnnotations;

namespace Velzon.Models;

public class ProfileSettingsViewModel
{
  [Required(ErrorMessage = "نام الزامی است.")]
  [Display(Name = "نام")]
  public string FirstName { get; set; } = string.Empty;

  [Required(ErrorMessage = "نام خانوادگی الزامی است.")]
  [Display(Name = "نام خانوادگی")]
  public string LastName { get; set; }= string.Empty;

  [Required(ErrorMessage = "شماره تلفن الزامی است.")]
  [Phone(ErrorMessage = "شماره تلفن نامعتبر است.")]
  [Display(Name = "شماره تلفن")]
  public string? PhoneNumber { get; set; }= string.Empty;
}