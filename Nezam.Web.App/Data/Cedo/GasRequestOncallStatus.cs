﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class GasRequestOncallStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<GasRequestOncallDescription> GasRequestOncallDescriptions { get; set; } = new List<GasRequestOncallDescription>();
}
