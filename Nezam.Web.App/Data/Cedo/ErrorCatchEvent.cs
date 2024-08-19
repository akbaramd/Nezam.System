using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ErrorCatchEvent
{
    public int Id { get; set; }

    public string? ErrorType { get; set; }

    public virtual FlowEvent IdNavigation { get; set; } = null!;
}
