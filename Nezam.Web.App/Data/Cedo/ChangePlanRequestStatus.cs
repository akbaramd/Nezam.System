using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ChangePlanRequestStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ChangePlanRequest> ChangePlanRequests { get; set; } = new List<ChangePlanRequest>();
}
