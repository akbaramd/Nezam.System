using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Material
{
    public int Id { get; set; }

    public int MaterialCategoryId { get; set; }

    public string? Title { get; set; }

    public virtual MaterialCategory MaterialCategory { get; set; } = null!;

    public virtual ICollection<MaterialValue> MaterialValues { get; set; } = new List<MaterialValue>();
}
