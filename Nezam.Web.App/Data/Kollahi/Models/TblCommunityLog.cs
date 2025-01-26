namespace Nezam.CES.Data.Models;

public partial class TblCommunityLog
{
    public long Id { get; set; }

    public int TypeId { get; set; }

    public long OzviyatNo { get; set; }

    public DateTime? Dat { get; set; }

    public int? KarbarId { get; set; }

    public string? Comments { get; set; }

    public virtual TblEngineer OzviyatNoNavigation { get; set; } = null!;
}
