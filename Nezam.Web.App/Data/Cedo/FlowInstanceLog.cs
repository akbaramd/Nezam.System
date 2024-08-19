using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowInstanceLog
{
    public int Id { get; set; }

    public int FlowInstanceId { get; set; }

    public int LogTypeId { get; set; }

    public DateTime DateTime { get; set; }

    public string? Message { get; set; }

    public virtual FlowInstance FlowInstance { get; set; } = null!;

    public virtual LogType LogType { get; set; } = null!;
}
