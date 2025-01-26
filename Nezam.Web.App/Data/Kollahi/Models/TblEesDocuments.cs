namespace Nezam.ESS.backend.Data.Models;

public class TblEesDocuments
{
    public int Id { get; set; }
    public string Title { get; set; } = string.Empty;
    public string FilePath { get; set; }= string.Empty;
    public string TrackingCode { get; set; }= string.Empty;
    public long UserId { get; set; }
    public DateTime? CreatedAt { get; set; }
    public int State { get; set; }
    public int Type { get; set; }
}