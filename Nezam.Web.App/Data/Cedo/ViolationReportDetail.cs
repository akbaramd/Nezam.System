using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ViolationReportDetail
{
    public int Id { get; set; }

    public int ViolationReportId { get; set; }

    public int MainSubjectId { get; set; }

    public string Subject { get; set; } = null!;

    public string Detail { get; set; } = null!;

    public virtual ViolationReportSubjectType MainSubject { get; set; } = null!;

    public virtual ViolationReport ViolationReport { get; set; } = null!;
}
