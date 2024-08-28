using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class FlowConnectionType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowConnector> FlowConnectors { get; set; } = new List<FlowConnector>();
}
