﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class AttributePropertyValue
{
    public int Id { get; set; }

    public int PropertyAttributeId { get; set; }

    public string PropertyName { get; set; } = null!;

    public string PropertyValue { get; set; } = null!;

    public virtual PropertyAttribute PropertyAttribute { get; set; } = null!;
}
