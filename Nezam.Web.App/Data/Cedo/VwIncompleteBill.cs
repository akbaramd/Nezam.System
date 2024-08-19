﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class VwIncompleteBill
{
    public int Id { get; set; }

    public string? DossierNumber { get; set; }

    public string Name { get; set; } = null!;

    public int CostTypeId { get; set; }

    public long Amount { get; set; }

    public int CityId { get; set; }
}
