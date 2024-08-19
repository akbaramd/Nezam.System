using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ScriptExecuteTask
{
    public int Id { get; set; }

    public string? Script { get; set; }

    public virtual NodeTask IdNavigation { get; set; } = null!;
}
