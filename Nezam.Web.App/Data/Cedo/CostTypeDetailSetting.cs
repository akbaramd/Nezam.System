using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class CostTypeDetailSetting
{
    public int Id { get; set; }

    public int CostTypeDetailId { get; set; }

    public int? BuildingSubGroupId { get; set; }

    public double Percentage { get; set; }

    public virtual BuildingSubGroup? BuildingSubGroup { get; set; }

    public virtual CostTypeDetail CostTypeDetail { get; set; } = null!;
}
