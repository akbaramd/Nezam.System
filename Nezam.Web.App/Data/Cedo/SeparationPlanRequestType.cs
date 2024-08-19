using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SeparationPlanRequestType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<SeparationPlanRequest> SeparationPlanRequests { get; set; } = new List<SeparationPlanRequest>();
}
