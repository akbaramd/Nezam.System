using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class ControllerActionType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<ControllerAction> ControllerActions { get; set; } = new List<ControllerAction>();
}
