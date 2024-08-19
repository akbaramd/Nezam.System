using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ViewComponent2
{
    public int Id { get; set; }

    public int ProjectId { get; set; }

    public string Name { get; set; } = null!;

    public string? Code { get; set; }

    public DateTime? LastChanged { get; set; }

    public virtual Project Project { get; set; } = null!;

    public virtual ICollection<ViewComponentView> ViewComponentViews { get; set; } = new List<ViewComponentView>();
}
