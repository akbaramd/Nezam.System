﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Operator1
{
    public string Title { get; set; } = null!;

    public string? UserName { get; set; }

    public string Value { get; set; } = null!;

    public string Name { get; set; } = null!;

    public Guid Id { get; set; }
}
