﻿using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class SqlServerDataSourceConfig
{
    public int Id { get; set; }

    public string Server { get; set; } = null!;

    public string Database { get; set; } = null!;

    public string UserName { get; set; } = null!;

    public string Password { get; set; } = null!;

    public virtual ProjectDataSource IdNavigation { get; set; } = null!;
}
