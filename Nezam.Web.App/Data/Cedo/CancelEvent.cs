using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class CancelEvent
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string ConfirmMessage { get; set; } = null!;

    public virtual FlowEvent IdNavigation { get; set; } = null!;
}
