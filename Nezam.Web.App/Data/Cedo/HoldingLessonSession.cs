﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class HoldingLessonSession
{
    public Guid Id { get; set; }

    public Guid HoldingLessonId { get; set; }

    public DateTime Date { get; set; }

    public virtual ICollection<AttendeeSession> AttendeeSessions { get; set; } = new List<AttendeeSession>();

    public virtual HoldingLesson HoldingLesson { get; set; } = null!;
}
