using System;
using System.Collections.Generic;

namespace Nezam.System.Web.Data.Cedo;

public partial class VwNeedExecuterDossier
{
    public int Id { get; set; }

    public string? DossierNumber { get; set; }

    public bool NeedsExecuter { get; set; }

    public string Name { get; set; } = null!;
}
