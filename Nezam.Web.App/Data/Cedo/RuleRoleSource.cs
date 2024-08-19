using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class RuleRoleSource
{
    public int Id { get; set; }

    public int RuleId { get; set; }

    public Guid RoleId { get; set; }

    public bool IsNot { get; set; }

    public virtual ParaRole Role { get; set; } = null!;

    public virtual FirewallRule Rule { get; set; } = null!;
}
