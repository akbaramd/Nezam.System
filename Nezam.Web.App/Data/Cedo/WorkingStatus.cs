using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class WorkingStatus
{
    public int Id { get; set; }

    public string? Title { get; set; }

    public virtual ICollection<PersonelDossier> PersonelDossiers { get; set; } = new List<PersonelDossier>();
}
