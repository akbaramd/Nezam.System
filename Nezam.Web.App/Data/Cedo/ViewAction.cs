﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ViewAction
{
    public int Id { get; set; }

    public int ActionId { get; set; }

    public int ViewId { get; set; }

    public virtual ControllerAction Action { get; set; } = null!;

    public virtual ProjectView View { get; set; } = null!;
}
