using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ProjectHelp
{
    public int Id { get; set; }

    public string? Summary { get; set; }

    public virtual ICollection<DocumentIndex> DocumentIndices { get; set; } = new List<DocumentIndex>();

    public virtual Project IdNavigation { get; set; } = null!;
}
