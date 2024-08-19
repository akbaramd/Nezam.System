using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class PersonnelPost
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<LegalMemberPersonnel> LegalMemberPersonnel { get; set; } = new List<LegalMemberPersonnel>();
}
