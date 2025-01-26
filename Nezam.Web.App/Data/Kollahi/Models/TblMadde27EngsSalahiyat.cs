namespace Nezam.CES.Data.Models;

public partial class TblMadde27EngsSalahiyat
{
    public long OzviyatNo { get; set; }

    public int TypeCod { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
