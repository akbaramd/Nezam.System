using System.ComponentModel.DataAnnotations;

namespace Velzon.Enums;

public enum CostTypes
{
  [Display(Name = "شناسنامه فنی و ملکی")]
  TechnicalCertificate = 1,

  [Display(Name = "بیمه طراحان")]
  DesignControl = 2,

  [Display(Name = "کنترل نظارت")]
  SupervisionControl = 3,

  [Display(Name = "حق الزحمه نظارت")]
  Supervisioning = 4,

  [Display(Name = "کنترل مجری")]
  ExecutorControl = 5,

  [Display(Name = "بیمه")]
  Insurance = 6,

  [Display(Name = "مکانیک خاک")]
  GeoTechnic = 7,

  [Display(Name = "نظارت نقشه برداری")]
  SurveySupervision = 8,

  [Display(Name = "کنترل نظارت نقشه برداری")]
  SurveyControl = 9,

  [Display(Name = "عودت مبلغ")]
  ReturnAmount = 10,

  [Display(Name = "آزمایش بتن")]
  ConcreteLab = 11,

  [Display(Name = "کنترل طراحی تعویض نقشه")]
  ChangePlanDesignControl = 12,

  [Display(Name = "کارشناسی تعویض نقشه")]
  ChangePlanJudge = 13,

  [Display(Name = "کارشناسی تعویض ناظر")]
  ChangeSupervisorJudge = 14,

  [Display(Name = "کارشناسی فسخ قرارداد مجری")]
  ExecuterTerminationExpert = 15,

  [Display(Name = "شرکت در دوره آموزشی")]
  CourseAttendee = 100,

  [Display(Name = "شرکت مجدد در دوره آموزشی")]
  ReCourseAttendee = 101,

  [Display(Name = "گزینه اختیاری دوره")]
  CourseOption = 102,

  [Display(Name = "صورتحساب نقشه برداری تفکیک")]
  SeparationPlan = 201,

  [Display(Name = "ممیزی گاز")]
  GasAudit = 301,

  [Display(Name = "کنترل نقشه گاز")]
  GasPlanControl = 302,

  [Display(Name = "سهم سازمان")]
  GasOrgShare = 303,

  [Display(Name = "فیش مجدد گاز")]
  GasRebill = 304,

  [Display(Name = "آنکالی گاز")]
  GasOncall = 305,

}