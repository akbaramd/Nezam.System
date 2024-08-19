﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class RoleMenu
{
    public int Id { get; set; }

    public int MenuId { get; set; }

    public Guid RoleId { get; set; }

    public virtual ProjectMenu Menu { get; set; } = null!;

    public virtual ParaRole Role { get; set; } = null!;
}
