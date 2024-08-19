using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ParaUserToken
{
    public Guid UserId { get; set; }

    public string LoginProvider { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string? Value { get; set; }

    public virtual ParaUser User { get; set; } = null!;
}
