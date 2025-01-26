namespace Nezam.CES.Data.Models;

public partial class TblEngineersBimeMablagRoozane
{
    public long Id { get; set; }

    public long OzviyatNo { get; set; }

    public int Sal { get; set; }

    public long? DastmozdRoozane { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
