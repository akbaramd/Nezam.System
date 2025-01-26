namespace Nezam.CES.Data.Models;

public partial class TblPayankarlist
{
    public long Id { get; set; }

    public int MapId { get; set; }

    public int Sal { get; set; }

    public long OzviyatNo { get; set; }

    public string? Tarikh { get; set; }

    public string? Comments { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
