using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowStarterTask
{
    public int Id { get; set; }

    public int FlowId { get; set; }

    public string? StartupArgScript { get; set; }

    public virtual Flow Flow { get; set; } = null!;

    public virtual NodeTask IdNavigation { get; set; } = null!;
}
