using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ParaUserLogin
{
    public string LoginProvider { get; set; } = null!;

    public string ProviderKey { get; set; } = null!;

    public string? ProviderDisplayName { get; set; }

    public Guid UserId { get; set; }

    public virtual ParaUser User { get; set; } = null!;
}
