using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class IntroductionTarget
{
    public int Id { get; set; }

    public string OrgTitle { get; set; } = null!;

    public string ReceiverDescription { get; set; } = null!;

    public string ReceiverTitle { get; set; } = null!;

    public virtual ICollection<IntroductionRequest> IntroductionRequests { get; set; } = new List<IntroductionRequest>();
}
