﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BuildingWorker
{
    public int Id { get; set; }

    public string? Responsibility { get; set; }

    public string? FullName { get; set; }

    public string? EmploymentLicenseNumber { get; set; }

    public string? AddressAndPhone { get; set; }

    public int InvolvedMemberId { get; set; }

    public virtual InvolvedMember InvolvedMember { get; set; } = null!;
}
