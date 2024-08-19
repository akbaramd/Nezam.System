using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ParaUserClaim
{
    public int Id { get; set; }

    public Guid UserId { get; set; }

    public string? ClaimType { get; set; }

    public string? ClaimValue { get; set; }

    public virtual ParaUser User { get; set; } = null!;
}
