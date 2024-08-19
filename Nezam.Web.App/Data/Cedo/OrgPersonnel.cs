using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class OrgPersonnel
{
    public Guid Id { get; set; }

    public virtual ParaUser IdNavigation { get; set; } = null!;

    public virtual ICollection<OrgUnitPersonnel> OrgUnitPersonnel { get; set; } = new List<OrgUnitPersonnel>();
}
