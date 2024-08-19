﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SentSmse
{
    public int Id { get; set; }

    public int SmsAccountId { get; set; }

    public string? ReceiverNumber { get; set; }

    public string? Message { get; set; }

    public virtual SmsAccount SmsAccount { get; set; } = null!;
}
