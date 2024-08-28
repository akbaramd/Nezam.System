using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class CategoryManpowerSkillCard
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ManpowerSkillCard> ManpowerSkillCards { get; set; } = new List<ManpowerSkillCard>();
}
