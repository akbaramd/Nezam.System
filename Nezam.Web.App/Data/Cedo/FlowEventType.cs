using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class FlowEventType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowEvent> FlowEvents { get; set; } = new List<FlowEvent>();
}
