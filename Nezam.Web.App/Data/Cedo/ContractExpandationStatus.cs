﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ContractExpandationStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ContractExpandation> ContractExpandations { get; set; } = new List<ContractExpandation>();
}
