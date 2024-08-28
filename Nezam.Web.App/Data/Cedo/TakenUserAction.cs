using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class TakenUserAction
{
    public int Id { get; set; }

    public int ActionId { get; set; }

    public int StepId { get; set; }

    public virtual UserActionTaskAction Action { get; set; } = null!;

    public virtual FlowStep Step { get; set; } = null!;
}
