using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ComplaintCommunicated
{
    public int Id { get; set; }

    public string ResultText { get; set; } = null!;

    public DateTime RegDate { get; set; }

    public int ComplaintResultStatusId { get; set; }

    public int ComplaintId { get; set; }

    public string Subject { get; set; } = null!;

    public virtual Complaint Complaint { get; set; } = null!;

    public virtual ICollection<ComplaintResultMember> ComplaintResultMembers { get; set; } = new List<ComplaintResultMember>();

    public virtual ComplaintResultStatus ComplaintResultStatus { get; set; } = null!;
}
