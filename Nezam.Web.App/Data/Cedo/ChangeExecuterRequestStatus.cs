using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ChangeExecuterRequestStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ChangeExecuterRequest> ChangeExecuterRequests { get; set; } = new List<ChangeExecuterRequest>();
}
