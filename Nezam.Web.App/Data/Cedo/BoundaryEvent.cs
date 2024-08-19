using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BoundaryEvent
{
    public int Id { get; set; }

    public int BoundarySourceId { get; set; }

    public virtual FlowNode BoundarySource { get; set; } = null!;

    public virtual FlowNode IdNavigation { get; set; } = null!;
}
