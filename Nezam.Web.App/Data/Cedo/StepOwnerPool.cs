using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class StepOwnerPool
{
    public int Id { get; set; }

    public int StepId { get; set; }

    public Guid UserId { get; set; }

    public virtual FlowStep Step { get; set; } = null!;

    public virtual ParaUser User { get; set; } = null!;
}
