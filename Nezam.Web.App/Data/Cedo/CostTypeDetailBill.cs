using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class CostTypeDetailBill
{
    public int Id { get; set; }

    public int CostTypeDetailId { get; set; }

    public int BillTypeId { get; set; }

    public virtual BillType BillType { get; set; } = null!;

    public virtual CostTypeDetail CostTypeDetail { get; set; } = null!;
}
