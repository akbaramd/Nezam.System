using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class VwCapacity
{
    public int MemberId { get; set; }

    public string Title { get; set; } = null!;

    public double? WorkItem { get; set; }

    public double? Metraje { get; set; }

    public int? QuotaYear { get; set; }

    public string Status { get; set; } = null!;

    public int Id { get; set; }

    public int ConstructionLicenseId { get; set; }
}
