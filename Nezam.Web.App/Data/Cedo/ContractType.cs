using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ContractType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<Contract> Contracts { get; set; } = new List<Contract>();
}
