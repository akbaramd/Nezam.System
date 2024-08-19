using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowActor
{
    public Guid Id { get; set; }

    public int FlowVersionId { get; set; }

    public string Title { get; set; } = null!;

    public string? Color { get; set; }

    public string? LookupScript { get; set; }

    public int Strategy { get; set; }

    public bool Forwardable { get; set; }

    public virtual ICollection<FlowNode> FlowNodes { get; set; } = new List<FlowNode>();

    public virtual FlowVersion FlowVersion { get; set; } = null!;
}
