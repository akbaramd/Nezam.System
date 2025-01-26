namespace Nezam.CES.Data.Models;

public partial class TblEngineersCardSerial
{
    public long CardId { get; set; }

    public long? EngId { get; set; }

    public int? KarbarId { get; set; }

    public DateTime? Dat { get; set; }

    public int? State { get; set; }

    public string? Comments { get; set; }
}
