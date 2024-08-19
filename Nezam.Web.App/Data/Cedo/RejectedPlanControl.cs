﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class RejectedPlanControl
{
    public int Id { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;

    public string? DossierNumber { get; set; }

    public DateTime RegDate { get; set; }

    public int InvolvedMemberId { get; set; }
}
