using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class PreviousStep
{
    public int Id { get; set; }

    public int StepId { get; set; }

    public int PrevStepId { get; set; }

    public virtual FlowStep PrevStep { get; set; } = null!;

    public virtual FlowStep Step { get; set; } = null!;
}
