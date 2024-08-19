using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class EstateCoordinate
{
    public int Id { get; set; }

    public int ConstructionLicenseId { get; set; }

    public double UtmX { get; set; }

    public double UtmY { get; set; }

    public virtual ConstructionLicense ConstructionLicense { get; set; } = null!;
}
