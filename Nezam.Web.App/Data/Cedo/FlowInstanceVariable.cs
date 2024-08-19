using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class FlowInstanceVariable
{
    public int Id { get; set; }

    public int FlowInstanceId { get; set; }

    public string Name { get; set; } = null!;

    public string? Value { get; set; }

    public virtual FlowInstance FlowInstance { get; set; } = null!;
}
