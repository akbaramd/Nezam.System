namespace Nezam.CES.Data.Models;

public partial class TblGeoNezaratMember
{
    public int Id { get; set; }

    public long? OzviyatNo { get; set; }

    public DateTime? SabtDate { get; set; }

    public bool? ActiveType { get; set; }

    public string? Comments { get; set; }

    public bool? Head { get; set; }

    public int? DNemayandegiCod { get; set; }

    public virtual TblEngineer? OzviyatNoNavigation { get; set; }
}
