using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class OwnershipDocumentType
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public virtual ICollection<Estate> Estates { get; set; } = new List<Estate>();

    public virtual ICollection<GasRequest> GasRequests { get; set; } = new List<GasRequest>();
}
