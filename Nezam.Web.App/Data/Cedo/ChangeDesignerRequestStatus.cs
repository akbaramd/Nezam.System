﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ChangeDesignerRequestStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ChangeDesignerRequest> ChangeDesignerRequests { get; set; } = new List<ChangeDesignerRequest>();

    public virtual ICollection<PaymentComeBackRequest> PaymentComeBackRequests { get; set; } = new List<PaymentComeBackRequest>();
}
