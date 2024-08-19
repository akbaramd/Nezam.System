using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class StudyGrade
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public int SyncCode { get; set; }

    public virtual ICollection<StudyRecord> StudyRecords { get; set; } = new List<StudyRecord>();
}
