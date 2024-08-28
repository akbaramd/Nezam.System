using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class CostTypeOrder
{
    public int Id { get; set; }

    public int Order { get; set; }

    public virtual CostType IdNavigation { get; set; } = null!;
}
