using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class StepRecordLog
{
    public int Id { get; set; }

    public string? RecordId { get; set; }

    public string? Entity { get; set; }

    public DateTime DateTime { get; set; }

    public virtual FlowStep IdNavigation { get; set; } = null!;

    public virtual StepRecordDataLog? StepRecordDataLog { get; set; }
}
