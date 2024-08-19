﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class WebServiceMethodRequestHeader
{
    public int Id { get; set; }

    public int MethodId { get; set; }

    public string Header { get; set; } = null!;

    public string Value { get; set; } = null!;

    public DateTime? LastChanged { get; set; }

    public virtual WebServiceMethod Method { get; set; } = null!;
}
