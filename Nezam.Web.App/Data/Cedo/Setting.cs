using System;
using System.Collections.Generic;

namespace Velzon.Data.Cedo;

public partial class Setting
{
    public int Id { get; set; }

    public string NewTicketDescription { get; set; } = null!;

    public bool NotifyUserBySms { get; set; }

    public bool NotifyHelpDeskBySms { get; set; }
}
