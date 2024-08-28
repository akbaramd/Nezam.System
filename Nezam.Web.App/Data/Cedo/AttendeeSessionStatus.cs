using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class AttendeeSessionStatus
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<AttendeeSession> AttendeeSessions { get; set; } = new List<AttendeeSession>();
}
