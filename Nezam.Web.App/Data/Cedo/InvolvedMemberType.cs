using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class InvolvedMemberType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<InvolvedMember> InvolvedMembers { get; set; } = new List<InvolvedMember>();
}
