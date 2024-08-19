﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SupportedCulture
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Name { get; set; } = null!;

    public bool Enabled { get; set; }

    public bool Default { get; set; }

    public virtual ICollection<ProjectTranslation> ProjectTranslations { get; set; } = new List<ProjectTranslation>();
}
