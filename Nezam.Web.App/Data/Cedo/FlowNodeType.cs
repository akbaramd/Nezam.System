using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowNodeType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowNode> FlowNodes { get; set; } = new List<FlowNode>();
}
