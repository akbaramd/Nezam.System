using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BuildingUnit
{
    public int Id { get; set; }

    public int FloorId { get; set; }

    public int UsageTypeId { get; set; }

    public int UnitCount { get; set; }

    public double Area { get; set; }

    public virtual Floor Floor { get; set; } = null!;

    public virtual UsageType UsageType { get; set; } = null!;
}
