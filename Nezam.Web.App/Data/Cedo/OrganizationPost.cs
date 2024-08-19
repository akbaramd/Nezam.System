using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class OrganizationPost
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public bool IsManagement { get; set; }

    public int ParentId { get; set; }

    public virtual OrganizationUnit Parent { get; set; } = null!;

    public virtual ICollection<PersonelPost> PersonelPosts { get; set; } = new List<PersonelPost>();
}
