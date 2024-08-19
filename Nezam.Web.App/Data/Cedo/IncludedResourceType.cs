using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class IncludedResourceType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<IncludedResource> IncludedResources { get; set; } = new List<IncludedResource>();
}
