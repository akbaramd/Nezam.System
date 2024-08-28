using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class WebServiceMethodType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<WebServiceMethod> WebServiceMethods { get; set; } = new List<WebServiceMethod>();
}
