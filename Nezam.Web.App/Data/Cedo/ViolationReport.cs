using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ViolationReport
{
    public int Id { get; set; }

    public int ConstructionLicenseId { get; set; }

    public int ReporterMemberId { get; set; }

    public DateTime ReportDate { get; set; }

    public bool IsCheckedOut { get; set; }

    public bool IsCommunicated { get; set; }

    public virtual ConstructionLicense ConstructionLicense { get; set; } = null!;

    public virtual InvolvedMember ReporterMember { get; set; } = null!;

    public virtual ICollection<ViolationReportDetail> ViolationReportDetails { get; set; } = new List<ViolationReportDetail>();
}
