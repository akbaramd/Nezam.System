using System.ComponentModel.DataAnnotations;

namespace Velzon.Enums;

public enum FloorTypes
{
  [Display(Name = "زیرزمین")]
  Basement = 1,

  [Display(Name = "همکف")]
  GroundFloor = 2,

  [Display(Name = "نیم طبقه")]
  HalfFloor = 3,

  [Display(Name = "طبقه")]
  Floor = 4,

  [Display(Name = "بهار خواب")]
  Attics = 5,

  [Display(Name = "خرپشته")]
  Loft = 6,

}