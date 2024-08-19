using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class RuleDestination
{
    public int Id { get; set; }

    public int RuleId { get; set; }

    public string Url { get; set; } = null!;

    public string Protocol { get; set; } = null!;

    public string Method { get; set; } = null!;

    public virtual FirewallRule Rule { get; set; } = null!;
}
