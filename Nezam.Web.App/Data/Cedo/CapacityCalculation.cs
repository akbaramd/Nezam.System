using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class CapacityCalculation
{
    public int Id { get; set; }

    public int BuildingGroupSettingId { get; set; }

    public int ServiceTypeId { get; set; }

    public int? ServiceFieldId { get; set; }

    public double WorkItem { get; set; }

    public int MaxWorkItem { get; set; }

    public int Order { get; set; }

    public virtual BuildingGroupSetting BuildingGroupSetting { get; set; } = null!;

    public virtual ServiceField? ServiceField { get; set; }

    public virtual ServiceType ServiceType { get; set; } = null!;
}
