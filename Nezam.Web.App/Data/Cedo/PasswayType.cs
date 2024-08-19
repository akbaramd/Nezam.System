using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class PasswayType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<Territory> Territories { get; set; } = new List<Territory>();
}
