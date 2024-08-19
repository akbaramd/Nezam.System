using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class MenuItemViewLinkSetting
{
    public int Id { get; set; }

    public int EntityViewId { get; set; }

    public bool ShowInWindow { get; set; }

    public virtual ProjectView EntityView { get; set; } = null!;

    public virtual MenuItem IdNavigation { get; set; } = null!;
}
