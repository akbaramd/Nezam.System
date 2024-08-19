using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class VwMemberCapacityDetail
{
    public float WorkItem { get; set; }

    public float Metraj { get; set; }

    public bool Released { get; set; }

    public int? QuotaYear { get; set; }

    public string Service { get; set; } = null!;

    public string Field { get; set; } = null!;

    public string? Description { get; set; }

    public DateTime RegDate { get; set; }
}
