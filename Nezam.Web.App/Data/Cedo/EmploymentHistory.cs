using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class EmploymentHistory
{
    public int Id { get; set; }

    public int MemberId { get; set; }

    public DateTime StartDate { get; set; }

    public DateTime? EndDate { get; set; }

    public string Description { get; set; } = null!;

    public virtual Member Member { get; set; } = null!;
}
