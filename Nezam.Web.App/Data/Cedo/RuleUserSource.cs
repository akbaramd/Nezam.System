using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class RuleUserSource
{
    public int Id { get; set; }

    public int RuleId { get; set; }

    public Guid UserId { get; set; }

    public bool IsNot { get; set; }

    public virtual FirewallRule Rule { get; set; } = null!;

    public virtual ParaUser User { get; set; } = null!;
}
