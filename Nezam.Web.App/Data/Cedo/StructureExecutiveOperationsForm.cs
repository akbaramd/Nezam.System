﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class StructureExecutiveOperationsForm
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

    public bool Item10 { get; set; }

    public bool Item11 { get; set; }

    public bool Item12 { get; set; }

    public bool Item13 { get; set; }

    public bool Item14 { get; set; }

    public bool Item15 { get; set; }

    public bool Item16 { get; set; }

    public bool Item17 { get; set; }

    public bool Item18 { get; set; }

    public bool Item19 { get; set; }

    public bool Item20 { get; set; }

    public bool Item21 { get; set; }

    public bool Item22 { get; set; }

    public bool Item23 { get; set; }

    public bool Item24 { get; set; }

    public DateTime RegDate { get; set; }

    public virtual InvolvedMember InvolvedMember { get; set; } = null!;
}
