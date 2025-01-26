using System.ComponentModel;
using System.ComponentModel.DataAnnotations;

namespace Nezam.CES.Data.Models;

public class TblUtmLogs
{
    [Key]
    public long Id { get; set; }

    public string Type { get; set; } = default!;
    public string Title { get; set; } = default!;
    public string Payload { get; set; } = default!;
    public DateTime RegDate { get; set; } = default!;

}