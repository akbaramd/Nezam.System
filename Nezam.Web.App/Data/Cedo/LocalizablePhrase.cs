using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class LocalizablePhrase
{
    public int Id { get; set; }

    public string Phrase { get; set; } = null!;

    public virtual ICollection<ProjectTranslation> ProjectTranslations { get; set; } = new List<ProjectTranslation>();
}
