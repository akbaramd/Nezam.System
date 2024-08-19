using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class GasBranchUser
{
    public Guid Id { get; set; }

    public int BranchId { get; set; }

    public virtual GasBranchOffice Branch { get; set; } = null!;

    public virtual ParaUser IdNavigation { get; set; } = null!;
}
