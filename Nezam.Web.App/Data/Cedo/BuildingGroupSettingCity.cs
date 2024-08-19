using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BuildingGroupSettingCity
{
    public int Id { get; set; }

    public int BuildingGroupSettingId { get; set; }

    public int? CityId { get; set; }

    public virtual BuildingGroupSetting BuildingGroupSetting { get; set; } = null!;

    public virtual City? City { get; set; }
}
