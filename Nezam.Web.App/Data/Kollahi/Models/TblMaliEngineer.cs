namespace Nezam.CES.Data.Models;

public partial class TblMaliEngineer
{
    public long OzviyatNo { get; set; }

    public long MaliTafsili { get; set; }

    public bool? BankSodoor { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
