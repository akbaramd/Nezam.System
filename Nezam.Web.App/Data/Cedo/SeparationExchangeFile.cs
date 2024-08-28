using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class SeparationExchangeFile
{
    public int Id { get; set; }

    public int RequestId { get; set; }

    public DateTime RegDate { get; set; }

    public DateTime? EmptyExchangeFileDate { get; set; }

    public DateTime? FilledExchangeFileDate { get; set; }

    public string? Serial { get; set; }

    public virtual SeparationPlanRequest Request { get; set; } = null!;
}
