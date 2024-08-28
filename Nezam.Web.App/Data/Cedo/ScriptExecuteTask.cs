using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class ScriptExecuteTask
{
    public int Id { get; set; }

    public string? Script { get; set; }

    public virtual NodeTask IdNavigation { get; set; } = null!;
}
