namespace Nezam.CES.Data.Models;

public partial class TblUpdateLog
{
    public int Id { get; set; }

    public DateTime? Dat { get; set; }

    public int? KarbarId { get; set; }

    public string? Filename { get; set; }
}
