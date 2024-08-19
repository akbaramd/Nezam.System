using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class VwOperator
{
    public string Title { get; set; } = null!;

    public string Name { get; set; } = null!;

    public Guid DelegateSenderId { get; set; }

    public Guid DelegateRecieverId { get; set; }

    public string Expr1 { get; set; } = null!;

    public string Value { get; set; } = null!;
}
