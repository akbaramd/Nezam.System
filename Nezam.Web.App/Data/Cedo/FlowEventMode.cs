using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowEventMode
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowEvent> FlowEvents { get; set; } = new List<FlowEvent>();
}
