namespace Nezam.CES.Data.Models;

public partial class TblLegalMembersActivityScope
{
    public int Id { get; set; }

    public int LegalMemberId { get; set; }

    public int ScopeId { get; set; }

    public int Master { get; set; }

    public string? Comments { get; set; }

    public int? Sal { get; set; }
}
