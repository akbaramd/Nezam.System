using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ProjectLoginSetting
{
    public int Id { get; set; }

    public int TwoFactorModeId { get; set; }

    public virtual Project IdNavigation { get; set; } = null!;

    public virtual TwoFactorMode TwoFactorMode { get; set; } = null!;
}
