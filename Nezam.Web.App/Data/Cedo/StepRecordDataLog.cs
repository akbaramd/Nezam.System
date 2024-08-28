using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class StepRecordDataLog
{
    public int Id { get; set; }

    public string? Log { get; set; }

    public virtual StepRecordLog IdNavigation { get; set; } = null!;
}
