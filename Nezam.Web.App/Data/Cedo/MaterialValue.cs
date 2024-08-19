using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class MaterialValue
{
    public int Id { get; set; }

    public int MaterialId { get; set; }

    public string? Type { get; set; }

    public string? Standard { get; set; }

    public string? StandardNumber { get; set; }

    public string? Description { get; set; }

    public int InvolvedMemberId { get; set; }

    public virtual InvolvedMember InvolvedMember { get; set; } = null!;

    public virtual Material Material { get; set; } = null!;
}
