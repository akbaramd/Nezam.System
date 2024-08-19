using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Firewall
{
    public int Id { get; set; }

    public bool Enabled { get; set; }

    public bool PreLoadRules { get; set; }

    public virtual ICollection<FirewallRule> FirewallRules { get; set; } = new List<FirewallRule>();
}
