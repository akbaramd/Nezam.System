using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ControllerType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<Controller> Controllers { get; set; } = new List<Controller>();
}
