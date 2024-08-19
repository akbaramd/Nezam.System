using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SupervisionStepItemOption
{
    public int Id { get; set; }

    public int SupervisionStepItemId { get; set; }

    public string ItemOption { get; set; } = null!;

    public virtual SupervisionStepItem SupervisionStepItem { get; set; } = null!;
}
