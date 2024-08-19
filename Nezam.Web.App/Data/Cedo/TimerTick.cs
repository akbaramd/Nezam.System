using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class TimerTick
{
    public int Id { get; set; }

    public DateTime InvokeAt { get; set; }

    public virtual FlowStep IdNavigation { get; set; } = null!;
}
