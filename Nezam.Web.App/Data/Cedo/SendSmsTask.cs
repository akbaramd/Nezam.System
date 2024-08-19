using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SendSmsTask
{
    public int Id { get; set; }

    public int? SmsAccountId { get; set; }

    public string MobileNumber { get; set; } = null!;

    public string Message { get; set; } = null!;

    public virtual NodeTask IdNavigation { get; set; } = null!;

    public virtual SmsAccount? SmsAccount { get; set; }
}
