using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ParaRoleClaim
{
    public int Id { get; set; }

    public Guid RoleId { get; set; }

    public string? ClaimType { get; set; }

    public string? ClaimValue { get; set; }

    public virtual ParaRole Role { get; set; } = null!;
}
