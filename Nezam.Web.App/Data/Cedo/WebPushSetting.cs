using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class WebPushSetting
{
    public Guid Id { get; set; }

    public virtual ParaUser IdNavigation { get; set; } = null!;

    public virtual ICollection<WebPushSubscription> WebPushSubscriptions { get; set; } = new List<WebPushSubscription>();
}
