namespace Nezam.CES.Data.Models;

public partial class ZtblMaliKhadamatType
{
    public int Id { get; set; }

    public string? Title { get; set; }

    /// <summary>
    /// ztbl_mali_khadamat_cat
    /// </summary>
    public int? CodKhadamatCat { get; set; }

    public int? CodReshteh { get; set; }
}
