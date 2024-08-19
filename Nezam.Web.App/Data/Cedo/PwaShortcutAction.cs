using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class PwaShortcutAction
{
    public int Id { get; set; }

    public int SettingId { get; set; }

    public int ActionId { get; set; }

    public string? Name { get; set; }

    public string? Description { get; set; }

    public virtual ControllerAction Action { get; set; } = null!;

    public virtual PwaSetting Setting { get; set; } = null!;
}
