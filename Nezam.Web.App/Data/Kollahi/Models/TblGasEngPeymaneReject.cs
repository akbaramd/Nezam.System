namespace Nezam.CES.Data.Models;

public partial class TblGasEngPeymaneReject
{
    public long Id { get; set; }

    public int? KarbarId { get; set; }

    public DateTime? Dat { get; set; }

    public int? EngCod { get; set; }

    public string? PeymaneMablag { get; set; }
}
