﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ArchitectureRedLinesForm
{
    public int Id { get; set; }

    public int InvolvedMemberId { get; set; }

    public bool Item1 { get; set; }

    public bool Item2 { get; set; }

    public bool Item3 { get; set; }

    public bool Item4 { get; set; }

    public bool Item5 { get; set; }

    public bool Item6 { get; set; }

    public bool Item7 { get; set; }

    public bool Item8 { get; set; }

    public bool Item9 { get; set; }

    public string? Description { get; set; }

    public DateTime RegDate { get; set; }

    public bool Item10 { get; set; }

    public bool Item11 { get; set; }

    public virtual InvolvedMember InvolvedMember { get; set; } = null!;
}
