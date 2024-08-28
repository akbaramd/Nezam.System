using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class FlowStepStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowStep> FlowSteps { get; set; } = new List<FlowStep>();
}
