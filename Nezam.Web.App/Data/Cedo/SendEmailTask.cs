using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SendEmailTask
{
    public int Id { get; set; }

    public int? EmailAccountId { get; set; }

    public string ReceiverAddress { get; set; } = null!;

    public string Subject { get; set; } = null!;

    public string Message { get; set; } = null!;

    public virtual EmailAccount? EmailAccount { get; set; }

    public virtual NodeTask IdNavigation { get; set; } = null!;
}
