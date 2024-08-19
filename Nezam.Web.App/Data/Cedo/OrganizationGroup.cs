using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class OrganizationGroup
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<PersonelGroup> PersonelGroups { get; set; } = new List<PersonelGroup>();
}
