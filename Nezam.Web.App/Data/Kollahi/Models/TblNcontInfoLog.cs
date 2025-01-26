namespace Nezam.CES.Data.Models;

public partial class TblNcontInfoLog
{
    public long Id { get; set; }

    public int? MapId { get; set; }

    public int? Sal { get; set; }

    public DateTime? Dat { get; set; }

    public int? KarbarId { get; set; }

    public int? CheckedItem { get; set; }

    public bool? CheckedState { get; set; }
}
