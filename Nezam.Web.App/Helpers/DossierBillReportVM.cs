namespace CedoLib.Report;

public class DossierBillReportVM
{
  public int Id { get; set; } = default!;
  public string? DossierNumber { get; set; } = default!;
  public string CityName { get; set; } = default!;
  public string? OwnerName { get; set; } = default!;
  public string? DossierFormalCode { get; set; } = default!;
  public string IntialBillAmount { get; set; } = default!;
  public string? IntialMetraje { get; set; } = default!;
  public string FinalBillAmount { get; set; } = default!;
  public string? FinalMetraje { get; set; } = default!;
  public string PayBackAmount { get; set; } = default!;
  public string SupervisionControlAmount { get; set; } = default!;
  public string DesignControlAmount { get; set; } = default!;
  public string ExecutorControlAmount { get; set; } = default!;
  public string SurveyControlAmount { get; set; } = default!;
  public string OtherAmount { get; set; } = default!;
  public string TechnicalCertificateAmount { get; set; } = default!;
  public string SupervisioningAmount { get; set; } = default!;
  public string SurveySupervisionAmount { get; set; } = default!;
}
