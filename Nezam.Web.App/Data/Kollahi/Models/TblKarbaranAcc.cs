namespace Nezam.CES.Data.Models;

public partial class TblKarbaranAcc
{
    public int Id { get; set; }

    public int? KarbarId { get; set; }

    public byte? AccessRole { get; set; }

    public byte? AccessLevel { get; set; }
}
