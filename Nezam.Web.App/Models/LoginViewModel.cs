using System.ComponentModel.DataAnnotations;

namespace Velzon.Models
{
  public class LoginViewModel
  {
    [Required(ErrorMessage = "وارد کردن نام کاربری الزامی است")]
    [Display(Name = "نام کاربری")]
    public string Username { get; set; } = string.Empty;

    [Required(ErrorMessage = "وارد کردن رمز عبور الزامی است")]
    [DataType(DataType.Password)]
    [Display(Name = "رمز عبور")]
    public string Password { get; set; } = string.Empty;

    [Display(Name = "مرا به خاطر بسپار")]
    public bool RememberMe { get; set; }
  }
}
