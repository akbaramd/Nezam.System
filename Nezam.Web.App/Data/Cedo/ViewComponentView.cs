using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ViewComponentView
{
    public int Id { get; set; }

    public int ViewComponentId { get; set; }

    public int ViewId { get; set; }

    public virtual ProjectView View { get; set; } = null!;

    public virtual ViewComponent2 ViewComponent2 { get; set; } = null!;
}
