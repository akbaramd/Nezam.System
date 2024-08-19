/************************************************\
| Puya BPMS Code Generator                       |
| Source Type: EntityEnum                        |
| Source Name: BillType                          |
| Source Id: 1069                                |
| Source Sub Id: 0                               |
\************************************************/

using System.ComponentModel.DataAnnotations;

namespace Velzon.Enums
{
    public enum BillTypes
    {
        [Display(Name = "صورتحساب اولیه هزینه های سازمان")]
        OrganizationalCosts = 1,

        [Display(Name = "هزینه های نظارت")]
        SupervisionCosts = 2,

        [Display(Name = "تعدیل صورتحساب اولیه")]
        AdjustingBill = 3,

        [Display(Name = "صورتحساب آزمایش ژئوتکنیک")]
        GeoLabBill = 4,

        [Display(Name = "صورتحساب ارزش افزوده نظارت حقوقی")]
        LegalSupervisorVATCost = 5,

        [Display(Name = "آزمایش بتن")]
        ConcreteLab = 6,

        [Display(Name = "تعویض نقشه")]
        ChangePlan = 7,

        [Display(Name = "هزینه کارشناسی تعویض نقشه")]
        ChangePlanJudge = 8,

        [Display(Name = "کارشناسی تعویض ناظر")]
        ChangeSupervisorJudge = 9,

        [Display(Name = "تعویض ناظر")]
        ChangeSupervisor = 10,

        [Display(Name = "کارشناسی فسخ قرارداد مجری")]
        ExecuterTerminationExpert = 11,

        [Display(Name = "صورتحساب ارزش افزوده تعویض ناظر")]
        ChangeSupervisorVATCost = 12,

        [Display(Name = "صورتحساب ازبیلت")]
        AsBuiltCosts = 13,

        [Display(Name = "شرکت در دوره آموزشی")]
        CourseAttendee = 100,

        [Display(Name = "شرکت مجدد در دوره آموزشی")]
        ReCourseAttendee = 110,

        [Display(Name = "صورتحساب نقشه برداری تفکیک")]
        SeparationPlan = 201,

        [Display(Name = "تعدیل صورتحساب نقشه برداری تفکیک")]
        SeparationPlanAdjusting = 202,

        [Display(Name = "ممیزی گاز")]
        GasAudit = 301,

        [Display(Name = "کنترل نقشه گاز")]
        GasPlanControl = 302,

        [Display(Name = "تعدیل صورتحساب")]
        GasAdjustingBill = 303,

        [Display(Name = "آنکالی گاز")]
        GasOncall = 304,

    }
}

