using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ChangeOwnerRequestDetail
{
    public int Id { get; set; }

    public int ChangeOwnerRequestId { get; set; }

    public int OwnerId { get; set; }

    public virtual ChangeOwnerRequest ChangeOwnerRequest { get; set; } = null!;

    public virtual Owner Owner { get; set; } = null!;
}
