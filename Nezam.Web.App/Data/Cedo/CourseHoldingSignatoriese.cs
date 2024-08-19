﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class CourseHoldingSignatoriese
{
    public Guid Id { get; set; }

    public Guid SignatoryId { get; set; }

    public Guid CourseHoldingId { get; set; }

    public int Order { get; set; }

    public virtual CourseHolding CourseHolding { get; set; } = null!;

    public virtual Signatory Signatory { get; set; } = null!;
}
