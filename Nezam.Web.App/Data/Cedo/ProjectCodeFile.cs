using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ProjectCodeFile
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string? Content { get; set; }

    public int ParentDirectoryId { get; set; }

    public DateTime? LastChanged { get; set; }

    public virtual ProjectCodeDirectory ParentDirectory { get; set; } = null!;
}
