namespace Nezam.CES.Data.Models;

public partial class TblCompetenceAmoozeshCourseMember
{
    public long Id { get; set; }

    public long? OzviyatNo { get; set; }

    public int? CourseId { get; set; }

    public DateTime? SabtDat { get; set; }

    public int? KarbarId { get; set; }

    public bool? Active { get; set; }

    public virtual TblEngineer? OzviyatNoNavigation { get; set; }
}
