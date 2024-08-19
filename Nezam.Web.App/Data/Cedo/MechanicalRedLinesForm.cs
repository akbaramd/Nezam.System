﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class MechanicalRedLinesForm
{
    public int Id { get; set; }

    public int InvolvedMemberId { get; set; }

    public bool Item1 { get; set; }

    public bool Item2 { get; set; }

    public bool Item3 { get; set; }

    public string? Description { get; set; }

    public DateTime RegDate { get; set; }

    public virtual InvolvedMember InvolvedMember { get; set; } = null!;
}
