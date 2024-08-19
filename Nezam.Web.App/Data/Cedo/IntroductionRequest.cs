using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class IntroductionRequest
{
    public int Id { get; set; }

    public int MemberId { get; set; }

    public DateTime RequestDate { get; set; }

    public string? Description { get; set; }

    public int StatusId { get; set; }

    public string Receiver { get; set; } = null!;

    public int TargetId { get; set; }

    public virtual Member Member { get; set; } = null!;

    public virtual IntroductionRequestStatus Status { get; set; } = null!;

    public virtual IntroductionTarget Target { get; set; } = null!;
}
