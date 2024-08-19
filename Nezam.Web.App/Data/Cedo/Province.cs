using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Province
{
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public int? SyncCode { get; set; }

    public virtual ICollection<City> Cities { get; set; } = new List<City>();
}
