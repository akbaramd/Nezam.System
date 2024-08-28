using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class WebServiceType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<WebService> WebServices { get; set; } = new List<WebService>();
}
