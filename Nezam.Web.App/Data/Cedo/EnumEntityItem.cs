using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class EnumEntityItem
{
    public int Id { get; set; }

    public int EntityId { get; set; }

    public int ItemId { get; set; }

    public string? ItemValue { get; set; }

    public string? ItemDisplay { get; set; }

    public virtual DataSourceEntity Entity { get; set; } = null!;
}
