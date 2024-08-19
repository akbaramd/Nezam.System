namespace Velzon.Models;
public class PlanControlReportVm
{
  public int? ServiceFieldId { get; set; } = default!;
  public int? ServiceTypeId { get; set; } = default!;
  public int? StatusId { get; set; } = default!;
  public int? MinMetraj { get; set; } = default!;
  public int? MaxMetraj { get; set; } = default!;
  public DateTime? StartDate { get; set; } = default!;
  public DateTime? EndDate { get; set; } = default!;
  public int? DossierStatusId{ get; set; } = default!;
  public int? CityId{ get; set; } = default!;
  public int? MemberId{ get; set; } = default!;   
  public int? EstateTypeId{ get; set; } = default!;   
  public int? FloorCount{ get; set; } = default!; 
  public int? BuildingGroupId{ get; set; } = default!; 
  public int? StepId { get; set; } = default!;
  public bool? DataSent{ get; set; } = default!;
}