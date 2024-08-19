using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class BuildingCertificateTimeout
{
    public int Id { get; set; }

    public int CheckDuration { get; set; }

    public bool IsActive { get; set; }

    public DateTime? NextCheckDate { get; set; }
}
