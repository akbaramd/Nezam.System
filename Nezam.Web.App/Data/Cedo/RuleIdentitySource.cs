using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class RuleIdentitySource
{
    public int Id { get; set; }

    public bool? IsAuthenticated { get; set; }

    public virtual FirewallRule IdNavigation { get; set; } = null!;
}
