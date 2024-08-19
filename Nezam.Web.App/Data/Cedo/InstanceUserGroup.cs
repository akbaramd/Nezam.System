using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class InstanceUserGroup
{
    public int Id { get; set; }

    public virtual ICollection<FlowInstance> FlowInstances { get; set; } = new List<FlowInstance>();

    public virtual ICollection<InstanceUserGroupMember> InstanceUserGroupMembers { get; set; } = new List<InstanceUserGroupMember>();
}
