using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class WebServiceMethodType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<WebServiceMethod> WebServiceMethods { get; set; } = new List<WebServiceMethod>();
}
