using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class LogType
{
    public int Id { get; set; }

    public string? Title { get; set; }

    public virtual ICollection<FlowInstanceLog> FlowInstanceLogs { get; set; } = new List<FlowInstanceLog>();
}
