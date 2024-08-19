﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Payment
{
    public long Amount { get; set; }

    public string? Rrn { get; set; }

    public int ConstructionLicenseId { get; set; }

    public string? DossierNumber { get; set; }

    public string LicenseNumber { get; set; } = null!;

    public int PaymentStatusId { get; set; }
}
