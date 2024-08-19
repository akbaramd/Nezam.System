using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class MessageThrowEvent
{
    public int Id { get; set; }

    public string? InstanceCode { get; set; }

    public string MessageName { get; set; } = null!;

    public string? VariabelsCode { get; set; }

    public virtual FlowEvent IdNavigation { get; set; } = null!;
}
