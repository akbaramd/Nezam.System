using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BuildingGroup
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<BuildingSubGroup> BuildingSubGroups { get; set; } = new List<BuildingSubGroup>();

    public virtual ICollection<LicenseCapacity> LicenseCapacities { get; set; } = new List<LicenseCapacity>();

    public virtual ICollection<WorkItemSetting> WorkItemSettings { get; set; } = new List<WorkItemSetting>();
}
