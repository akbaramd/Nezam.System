/****************************************************\
| Puya BPMS Code Generator                           |
| Source Type: EntityEnum                            |
| Source Name: PaymentStatus                         |
| Source Id: 1074                                    |
| Source Sub Id: 0                                   |
\****************************************************/

using System.ComponentModel.DataAnnotations;

namespace Velzon.Enums
{
  public enum PaymentStatuses
  {
    [Display(Name = "منتظر پرداخت")]
    Pending = 1,

    [Display(Name = "تایید شده")]
    Verified = 2,

  }
}
