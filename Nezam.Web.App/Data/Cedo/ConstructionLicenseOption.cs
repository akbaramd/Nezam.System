using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class ConstructionLicenseOption
{
    public int Id { get; set; }

    public string? Key { get; set; }

    public string? Value { get; set; }

    public DateTime RegDate { get; set; }

    public int ConstructionLicenseId { get; set; }

    public virtual ConstructionLicense ConstructionLicense { get; set; } = null!;
}
