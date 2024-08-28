using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class InstanceUserGroupMember
{
    public int Id { get; set; }

    public int GroupId { get; set; }

    public Guid UserId { get; set; }

    public virtual InstanceUserGroup Group { get; set; } = null!;

    public virtual ParaUser User { get; set; } = null!;
}
