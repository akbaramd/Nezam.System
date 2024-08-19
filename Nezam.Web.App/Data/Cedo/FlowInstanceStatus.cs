using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowInstanceStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowInstance> FlowInstances { get; set; } = new List<FlowInstance>();
}
