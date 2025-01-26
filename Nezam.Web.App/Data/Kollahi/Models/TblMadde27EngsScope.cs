namespace Nezam.CES.Data.Models;

public partial class TblMadde27EngsScope
{
    public long OzviyatNo { get; set; }

    public int DNemayandegiCod { get; set; }

    public string? Comments { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
