using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class AttendeeOption
{
    public int Id { get; set; }

    public Guid AttendeeId { get; set; }

    public int OptionId { get; set; }

    public virtual Attendee Attendee { get; set; } = null!;

    public virtual HoldingLessonOption Option { get; set; } = null!;
}
