using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class RuleSubnetSource
{
    public int Id { get; set; }

    public int RuleId { get; set; }

    public string Subnet { get; set; } = null!;

    public byte Length { get; set; }

    public bool IsNot { get; set; }

    public virtual FirewallRule Rule { get; set; } = null!;
}
