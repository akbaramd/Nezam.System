using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class FlowInstanceStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowInstance> FlowInstances { get; set; } = new List<FlowInstance>();
}
