using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class VwUserDeligation
{
    public Guid UserId { get; set; }

    public string Title { get; set; } = null!;

    public string Value { get; set; } = null!;

    public string Name { get; set; } = null!;

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;
}
