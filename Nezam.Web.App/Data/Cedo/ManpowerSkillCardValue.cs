using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ManpowerSkillCardValue
{
    public int Id { get; set; }

    public bool HasIt { get; set; }

    public string? FullName { get; set; }

    public string? SkillCardNumber { get; set; }

    public int InvolvedMemberId { get; set; }

    public int ManpowerSkillCardId { get; set; }

    public virtual InvolvedMember InvolvedMember { get; set; } = null!;

    public virtual ManpowerSkillCard ManpowerSkillCard { get; set; } = null!;
}
