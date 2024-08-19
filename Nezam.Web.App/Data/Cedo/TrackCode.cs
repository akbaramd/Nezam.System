using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class TrackCode
{
    public string Name { get; set; } = null!;

    public string? TrackCode1 { get; set; }

    public string? RecordId { get; set; }

    public string? Entity { get; set; }

    public string? UserName { get; set; }

    public string FirstName { get; set; } = null!;

    public string LastName { get; set; } = null!;
}
