namespace Nezam.CES.Data.Models;

public partial class TblEngineersBimePayment
{
    public long Id { get; set; }

    public long OzviyatNo { get; set; }

    public int Sal { get; set; }

    public int MonthCod { get; set; }

    public int? TedadRooz { get; set; }

    public long? MablagBedehi { get; set; }

    public string? VarizDat { get; set; }

    public string? FishNo { get; set; }

    public string? SeriFish { get; set; }

    public long? MablagVariz { get; set; }

    public DateTime? SabtDat { get; set; }

    public DateTime? VarizEnDat { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
