using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class GasCounterType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<GasRequestAuditForm> GasRequestAuditForms { get; set; } = new List<GasRequestAuditForm>();

    public virtual ICollection<GasRequestSplit> GasRequestSplitCounterTypes { get; set; } = new List<GasRequestSplit>();

    public virtual ICollection<GasRequestSplit> GasRequestSplitFinalCounterTypes { get; set; } = new List<GasRequestSplit>();
}
