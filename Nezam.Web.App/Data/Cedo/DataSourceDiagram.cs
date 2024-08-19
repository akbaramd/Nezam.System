using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class DataSourceDiagram
{
    public int Id { get; set; }

    public int DataSourceId { get; set; }

    public string Name { get; set; } = null!;

    public virtual ProjectDataSource DataSource { get; set; } = null!;

    public virtual ICollection<DiagramEntity> DiagramEntities { get; set; } = new List<DiagramEntity>();
}
