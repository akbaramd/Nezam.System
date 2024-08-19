using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Department
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<DepartmentUser> DepartmentUsers { get; set; } = new List<DepartmentUser>();

    public virtual ICollection<SupportTicket> SupportTickets { get; set; } = new List<SupportTicket>();
}
