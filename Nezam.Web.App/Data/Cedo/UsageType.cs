using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class UsageType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<BuildingUnit> BuildingUnits { get; set; } = new List<BuildingUnit>();

    public virtual ICollection<ConstructionLicense> ConstructionLicenses { get; set; } = new List<ConstructionLicense>();
}
