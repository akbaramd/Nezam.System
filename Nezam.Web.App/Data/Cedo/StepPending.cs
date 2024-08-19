using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class StepPending
{
    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public int StatusId { get; set; }

    public Guid? OwnerId { get; set; }
}
