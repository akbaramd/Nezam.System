using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Sgaletter
{
    public Guid Id { get; set; }

    public int ConstructionLicenseId { get; set; }

    public int LetterTypeId { get; set; }

    public string Subject { get; set; } = null!;

    public string RegNumber { get; set; } = null!;

    public DateTime Date { get; set; }

    public virtual ConstructionLicense ConstructionLicense { get; set; } = null!;

    public virtual SgaletterType LetterType { get; set; } = null!;
}
