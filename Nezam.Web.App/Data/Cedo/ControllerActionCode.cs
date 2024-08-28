using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class ControllerActionCode
{
    public int Id { get; set; }

    public string? Code { get; set; }

    public DateTime? LastChanged { get; set; }

    public virtual ControllerAction IdNavigation { get; set; } = null!;
}
