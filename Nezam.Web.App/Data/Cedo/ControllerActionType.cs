using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ControllerActionType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<ControllerAction> ControllerActions { get; set; } = new List<ControllerAction>();
}
