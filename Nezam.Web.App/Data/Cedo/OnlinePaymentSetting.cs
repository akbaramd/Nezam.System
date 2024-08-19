using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class OnlinePaymentSetting
{
    public int Id { get; set; }

    public int CityId { get; set; }

    public int BillTypeId { get; set; }

    public string LoginAccount { get; set; } = null!;

    public bool IsActive { get; set; }

    public virtual BillType BillType { get; set; } = null!;

    public virtual City City { get; set; } = null!;
}
