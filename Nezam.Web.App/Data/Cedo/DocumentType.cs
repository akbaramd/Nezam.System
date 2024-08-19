using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class DocumentType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<ConstructionLicenseDocument> ConstructionLicenseDocuments { get; set; } = new List<ConstructionLicenseDocument>();

    public virtual ICollection<GasRequestSplitDocument> GasRequestSplitDocuments { get; set; } = new List<GasRequestSplitDocument>();
}
