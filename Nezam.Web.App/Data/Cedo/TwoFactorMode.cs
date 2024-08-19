using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class TwoFactorMode
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public virtual ICollection<ProjectLoginSetting> ProjectLoginSettings { get; set; } = new List<ProjectLoginSetting>();
}
