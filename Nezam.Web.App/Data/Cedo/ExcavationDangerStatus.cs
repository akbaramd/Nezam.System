using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ExcavationDangerStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ConstructionLicense> ConstructionLicenses { get; set; } = new List<ConstructionLicense>();
}
