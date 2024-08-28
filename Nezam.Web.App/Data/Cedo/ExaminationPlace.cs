using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class ExaminationPlace
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<Examination> Examinations { get; set; } = new List<Examination>();
}
