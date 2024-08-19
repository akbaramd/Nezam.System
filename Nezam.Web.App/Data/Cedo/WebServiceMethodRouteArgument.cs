using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class WebServiceMethodRouteArgument
{
    public int Id { get; set; }

    public int MethodId { get; set; }

    public string Name { get; set; } = null!;

    public string ClrDataType { get; set; } = null!;

    public DateTime? LastChanged { get; set; }

    public virtual WebServiceMethod Method { get; set; } = null!;
}
