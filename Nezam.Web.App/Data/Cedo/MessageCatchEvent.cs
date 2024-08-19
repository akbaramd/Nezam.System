using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class MessageCatchEvent
{
    public int Id { get; set; }

    public string MessageName { get; set; } = null!;

    public virtual FlowEvent IdNavigation { get; set; } = null!;
}
