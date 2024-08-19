using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class VwHistoryCapacity
{
    public int MemberId { get; set; }

    public string Title { get; set; } = null!;

    public float WorkItem { get; set; }

    public float Metraj { get; set; }

    public int? QuotaYear { get; set; }

    public int? InvolvedMemberId { get; set; }

    public string? Description { get; set; }
}
