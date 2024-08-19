using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class LicenseCapacityRemaining
{
    public Guid Id { get; set; }

    public double? Metraj { get; set; }

    public double? WorkItem { get; set; }

    public virtual LicenseCapacity IdNavigation { get; set; } = null!;
}
