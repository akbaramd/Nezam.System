using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class ProjectWebPushSetting
{
    public int Id { get; set; }

    public string VapidPublicKey { get; set; } = null!;

    public string VapidPrivateKey { get; set; } = null!;

    public string GcmSenderId { get; set; } = null!;

    public string ReplyToAddress { get; set; } = null!;

    public virtual Project IdNavigation { get; set; } = null!;
}
