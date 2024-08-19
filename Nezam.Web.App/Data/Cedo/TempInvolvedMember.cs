using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class TempInvolvedMember
{
    public int Id { get; set; }

    public double? WorkItem { get; set; }

    public double? Metraje { get; set; }

    public bool IsSent { get; set; }
}
