using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowStepStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<FlowStep> FlowSteps { get; set; } = new List<FlowStep>();
}
