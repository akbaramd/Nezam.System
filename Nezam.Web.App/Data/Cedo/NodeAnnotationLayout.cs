using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class NodeAnnotationLayout
{
    public int Id { get; set; }

    public double Width { get; set; }

    public double Height { get; set; }

    public double OffsetX { get; set; }

    public double OffsetY { get; set; }

    public virtual FlowNode IdNavigation { get; set; } = null!;
}
