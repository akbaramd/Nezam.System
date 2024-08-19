using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowInstancePauseLog
{
    public int Id { get; set; }

    public int InstanceId { get; set; }

    public DateTime Time { get; set; }

    public string Description { get; set; } = null!;

    public virtual FlowInstance Instance { get; set; } = null!;
}
