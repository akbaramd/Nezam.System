using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class ControllerType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<Controller> Controllers { get; set; } = new List<Controller>();
}
