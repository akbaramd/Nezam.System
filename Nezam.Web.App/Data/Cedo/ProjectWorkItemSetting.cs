using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ProjectWorkItemSetting
{
    public int Id { get; set; }

    public int? CityId { get; set; }

    public double WorkItem { get; set; }

    public int MaxCount { get; set; }

    public int? DossierTypeId { get; set; }

    public virtual City? City { get; set; }

    public virtual DossierType? DossierType { get; set; }
}
