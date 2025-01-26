namespace Nezam.CES.Data.Models;

public partial class TblElection
{
    public int Id { get; set; }

    public long? OzviyatNo { get; set; }

    public DateTime? Dsabt { get; set; }

    public int? ElectionId { get; set; }

    public virtual TblEngineer? OzviyatNoNavigation { get; set; }
}
