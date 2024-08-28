using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class AdditionalSupervisionField
{
    public int Id { get; set; }

    public Guid SupervisionFieldId { get; set; }

    public int FieldId { get; set; }

    public virtual ServiceField Field { get; set; } = null!;

    public virtual SupervisionField SupervisionField { get; set; } = null!;
}
