using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class DuplicatedMember
{
    public Guid UserId { get; set; }

    public int? Count { get; set; }
}
