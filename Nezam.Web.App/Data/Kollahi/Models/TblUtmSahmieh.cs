namespace Nezam.CES.Data.Models;

public partial class TblUtmSahmieh
{
    public int Id { get; set; }

    public long? Utminfoid { get; set; }

    public int EngCod { get; set; }
    public TblUtmEng Eng { get; set; }= default!;
    public DateTime? SabtDat { get; set; }

    public string? Comments { get; set; }

    public int? State { get; set; }

    public int? KarbarId { get; set; }
}
