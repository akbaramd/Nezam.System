using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class TimerType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<TimerEvent> TimerEvents { get; set; } = new List<TimerEvent>();
}
