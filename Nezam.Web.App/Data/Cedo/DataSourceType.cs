using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class DataSourceType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<ProjectDataSource> ProjectDataSources { get; set; } = new List<ProjectDataSource>();
}
