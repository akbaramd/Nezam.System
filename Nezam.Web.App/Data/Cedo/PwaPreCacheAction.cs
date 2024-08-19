using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class PwaPreCacheAction
{
    public int Id { get; set; }

    public int SettingId { get; set; }

    public int ActionId { get; set; }

    public virtual ControllerAction Action { get; set; } = null!;

    public virtual PwaSetting Setting { get; set; } = null!;
}
