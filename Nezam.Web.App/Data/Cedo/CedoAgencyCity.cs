using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class CedoAgencyCity
{
    public Guid Id { get; set; }

    public Guid AgencyId { get; set; }

    public int CityId { get; set; }

    public virtual CedoAgency Agency { get; set; } = null!;

    public virtual City City { get; set; } = null!;
}
