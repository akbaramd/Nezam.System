using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SolutionResource
{
    public int Id { get; set; }

    public byte[]? Migrations { get; set; }

    public byte[]? References { get; set; }

    public byte[]? Resources { get; set; }

    public virtual Project IdNavigation { get; set; } = null!;
}
