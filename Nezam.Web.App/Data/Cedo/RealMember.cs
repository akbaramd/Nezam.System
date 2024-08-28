using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class RealMember
{
    public int Id { get; set; }

    public int HealthStatusId { get; set; }

    public virtual HealthStatus HealthStatus { get; set; } = null!;

    public virtual Member IdNavigation { get; set; } = null!;
}
