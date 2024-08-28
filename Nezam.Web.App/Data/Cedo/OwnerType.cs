using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class OwnerType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<Owner> Owners { get; set; } = new List<Owner>();
}
