using System.ComponentModel.DataAnnotations;

namespace Velzon.Enums;

public enum FloorRegisterSteps
{
  [Display(Name = "ثبت اولیه")]
  InitialRegistration = 1,

  [Display(Name = "ثبت نهایی")]
  FinalRegistration = 2,

  [Display(Name = "ثبت در پروانه شهرداری")]
  CertificateRegistration = 3,

}