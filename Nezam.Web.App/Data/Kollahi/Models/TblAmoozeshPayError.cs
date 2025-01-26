namespace Nezam.CES.Data.Models;

public partial class TblAmoozeshPayError
{
    public long Id { get; set; }

    public DateTime? Dat { get; set; }

    public int? PayId { get; set; }

    public string? ErrorDsc { get; set; }
}
