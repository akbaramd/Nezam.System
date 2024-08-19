using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class EmailAccount
{
    public int Id { get; set; }

    public string Title { get; set; } = null!;

    public string SmtpServer { get; set; } = null!;

    public int SmtpServerPort { get; set; }

    public string UserName { get; set; } = null!;

    public string Password { get; set; } = null!;

    public string From { get; set; } = null!;

    public bool IsDefault { get; set; }

    public virtual ICollection<SendEmailTask> SendEmailTasks { get; set; } = new List<SendEmailTask>();
}
