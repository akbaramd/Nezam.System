namespace Nezam.CES.Data.Models;

public partial class TblMojrianSarparastKargahBan
{
    public int Id { get; set; }

    public long? OzviyatNo { get; set; }

    public int? State { get; set; }

    public string? Comments { get; set; }

    public virtual TblEngineer? OzviyatNoNavigation { get; set; }
}
