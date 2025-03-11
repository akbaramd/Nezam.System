using System.ComponentModel.DataAnnotations;
using System.Globalization;
using System.Security.Claims;
using FastReport.Export.Html;
using FastReport.Export.PdfSimple;
using FastReport.Web;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data;
using Nezam.System.Web.Data.Cedo;
using Velzon;

namespace Nezam.System.Web.Pages.Report;

[Authorize(Policy = "SearchInvolvedMembersReport")]
public class SearchInvolvedMembersReport : PageModel
{
  private readonly CedoContext _context;

  public SearchInvolvedMembersReport(CedoContext context)
  {
    _context = context;
  }


  public WebReport? WebReport { get; set; }
  public string ErrorMessage { get; set; } = string.Empty;

  [BindProperty] public SearchInvolvedMembersFilterModel FilterModel { get; set; } = new();


  public List<SelectListItem> ServiceTypes { get; set; } = new();
  public List<SelectListItem> ServiceFields { get; set; } = new();
  public List<SelectListItem> InvolvedMemberStatuses { get; set; } = new();
  public List<SelectListItem> DossierTypes { get; set; } = new();

 public void OnGet(string membershipCode)
{
    // Set the MembershipCode from the query string
    if (!string.IsNullOrEmpty(membershipCode))
    {
        FilterModel.MembershipCode = membershipCode;
    }

    // Populate dropdowns
    ServiceTypes = _context.ServiceTypes.Select(st => new SelectListItem { Value = st.Id.ToString(), Text = st.Title })
      .ToList();

    ServiceFields = _context.ServiceFields
      .Select(sf => new SelectListItem { Value = sf.Id.ToString(), Text = sf.Title }).ToList();

    InvolvedMemberStatuses = _context.InvolvedMemberStatuses.Select(st => new SelectListItem
    {
      Value = st.Id.ToString(), Text = st.Title
    }).ToList();

    DossierTypes = _context.DossierTypes.Select(dt => new SelectListItem { Value = dt.Id.ToString(), Text = dt.Title })
      .ToList();
}


  public async Task<JsonResult> OnPostAsync()
  {
    try
    {
      // Get the current user's agencies
      var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
      var appDbContext = HttpContext.RequestServices.GetRequiredService<AppDbContext>();
      var userAgencies = await appDbContext.UserAgencies
        .Where(ua => currentUserId != null && ua.UserId == Guid.Parse(currentUserId))
        .Select(ua => ua.AgencyCode)
        .ToListAsync();

      // Check if the member belongs to one of the user's agencies
      var memberAgencies = await _context.Members
        .Where(m => m.MembershipCode == FilterModel.MembershipCode)
        .SelectMany(m => m.ActivityLicenses)
        .SelectMany(al => al.MemberServices)
        .Where(ms => ms.City != null && ms.City.SyncCode.HasValue)
        .Select(ms => ms.City.SyncCode!.Value)
        .Distinct()
        .ToListAsync();

      // If user has agencies and none match the member's agencies, return access denied
      if (userAgencies.Any() && memberAgencies.Any() && !memberAgencies.Any(ma => userAgencies.Contains(ma)))
      {
        return new JsonResult(new { 
          success = false, 
          errorMessage = "شما دسترسی به اطلاعات اعضای شهرهای دیگر را ندارید." 
        });
      }

      await SetupWebReportAsync(FilterModel.MembershipCode);
      return new JsonResult(new { success = true, reportHtml = await RenderReportAsync() });
    }
    catch (Exception ex)
    {
      return new JsonResult(new { success = false, errorMessage = "Error in generating the report: " + ex.Message });
    }
  }

  public async Task<IActionResult> OnPostDownloadPdf(string membershipCode)
  {
    try
    {
      var involvedMembers = await GetInvolvedMembersAsync(membershipCode);



      await SetupWebReportAsync(membershipCode);

      using var pdfStream = new MemoryStream();
      var pdfExport = new PDFSimpleExport();
      WebReport?.Report.Export(pdfExport, pdfStream);
      pdfStream.Position = 0;

      return File(pdfStream.ToArray(), "application/pdf", $"{membershipCode}_{Guid.NewGuid()}.pdf");
    }
    catch (Exception ex)
    {
      return new JsonResult(new { success = false, errorMessage = "Error in generating PDF report: " + ex.Message });
    }
  }

  private async Task SetupWebReportAsync(string code)
  {
    
    var involvedMembers = await GetInvolvedMembersAsync(code);

    var reportParameters = await GetParameterAsync(code);
    WebReport = new WebReport();
    WebReport.Report.Load(Path.Combine(Directory.GetCurrentDirectory(), "Reports", "InvolvedMembers.frx"));

    RegisterDataSources(WebReport.Report, involvedMembers);
    
    
    foreach (var prop in reportParameters.GetType().GetProperties())
    {
      WebReport.Report.SetParameterValue(prop.Name, prop.GetValue(reportParameters));
    }
    
    WebReport.Report.Prepare();
  }

  private async Task<InvolvedMemberReportParameters> GetParameterAsync(string filterModelMembershipCode)
  {
    var member = await _context.Members.Include(member => member.User).ThenInclude(paraUser => paraUser.UserProfile)
      .Include(member => member.ActivityLicenses).ThenInclude(activityLicense => activityLicense.MemberServices)
      .ThenInclude(memberService => memberService.ServiceField).Include(member => member.ActivityLicenses)
      .ThenInclude(activityLicense => activityLicense.MemberServices).ThenInclude(memberService => memberService.City).FirstOrDefaultAsync(x=>x.MembershipCode.Equals(filterModelMembershipCode));

    return new InvolvedMemberReportParameters()
    {
      FirstName = member?.User.UserProfile?.FirstName??string.Empty,
      LastName = member?.User?.UserProfile?.LastName??string.Empty,
      NationalNumber = member?.User?.UserProfile?.NationalCode??string.Empty,
      PhoneNumber= member?.User?.PhoneNumber??string.Empty,
      MembershipNumber = member?.MembershipCode??string.Empty,
      Agency = string.Join(",", member?.ActivityLicenses?.FirstOrDefault()?.MemberServices.Select(x => x.City.Name ?? string.Empty).Distinct() ?? new List<string>())
    };

  }
private async Task<List<InvolvedMemberViewModel>> GetInvolvedMembersAsync(string membershipCode)
{
  var persianCalendar = new PersianCalendar();
  
  // Get the current user's agencies
  var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
  var appDbContext = HttpContext.RequestServices.GetRequiredService<AppDbContext>();
  var userAgencies = await appDbContext.UserAgencies
    .Where(ua => currentUserId != null && ua.UserId == Guid.Parse(currentUserId))
    .Select(ua => ua.AgencyCode)
    .ToListAsync();
  
  var query = _context.InvolvedMembers
    .Include(im => im.MemberService)
    .ThenInclude(ms => ms.ActivityLicense)
    .ThenInclude(al => al.Member)
    .ThenInclude(m => m.User)
    .ThenInclude(u => u.UserProfile)
    .Include(im => im.ConstructionLicense)
    .ThenInclude(cl => cl.Owners) // Including MainOwner to access FirstName, LastName
    .Include(im => im.ConstructionLicense)
    .ThenInclude(cl => cl.BuildingGroupSetting) // Including BuildingGroupSetting for BuildingGroup
    .ThenInclude(cl => cl!.SubGroup) // Including BuildingGroupSetting for BuildingGroup
    .Include(im => im.ConstructionLicense)
    .ThenInclude(cl => cl.DossierType) // Including DossierType for BuildingType
    .Include(im => im.MemberService.ServiceType)
    .Include(im => im.MemberService.ServiceField)
    .Include(im => im.Status).Include(involvedMember => involvedMember.ConstructionLicense)
    .ThenInclude(constructionLicense => constructionLicense.Floors).ThenInclude(floor => floor.BuildingUnits)
    .Include(x=>x.SupervisionStepForms).ThenInclude(x=>x.Step)
    .Include(im => im.ConstructionLicense.Estate)
    .ThenInclude(e => e.Municipality)
    .ThenInclude(m => m.City)
    .AsQueryable();

  // Filter by user's agencies - only show members whose construction license city matches user's agencies
  if (userAgencies.Any())
  {
    query = query.Where(im => 
      im.ConstructionLicense.Estate != null && 
      im.ConstructionLicense.Estate.Municipality != null && 
      im.ConstructionLicense.Estate.Municipality.City != null && 
      im.ConstructionLicense.Estate.Municipality.City.SyncCode != null &&
      userAgencies.Contains(im.ConstructionLicense.Estate.Municipality.City.SyncCode!.Value));
  }

  if (!string.IsNullOrEmpty(membershipCode))
  {
    query = query.Where(im => im.MemberService.ActivityLicense.Member.MembershipCode == membershipCode || im.MemberService.ActivityLicense.Member.MembershipCode == membershipCode);
  }

  if (FilterModel.Years.HasValue)
  {
    // Get the current Persian year
    
    var currentYear = persianCalendar.GetYear(DateTime.Now);

    // Calculate the starting year (e.g., last 4 years)
    var startYear = currentYear - FilterModel.Years.Value + 1;

    // Filter the query for the last n years
    query = query.Where(im => im.QuotaYear >= startYear);
  }
  if (FilterModel.ServiceTypeId.HasValue)
  {
      query = query.Where(im => im.MemberService.ServiceTypeId == FilterModel.ServiceTypeId.Value);
  }

  if (FilterModel.ServiceFieldId.HasValue)
  {
      query = query.Where(im => im.MemberService.ServiceFieldId == FilterModel.ServiceFieldId.Value);
  }

  if (FilterModel.InvolvedMemberStatusId.HasValue)
  {
      query = query.Where(im => im.StatusId == FilterModel.InvolvedMemberStatusId.Value);
  }

  if (FilterModel.DossierTypeId.HasValue)
  {
      query = query.Where(im => im.ConstructionLicense.DossierTypeId == FilterModel.DossierTypeId.Value );
  }

  var involvedMembersQuery = await query.ToListAsync();



   

  var involvedMembers = involvedMembersQuery.Select(im => new InvolvedMemberViewModel
  {
      MemberId = im.MemberService.ActivityLicense.Member.Id,
      MembershipCode = im.MemberService.ActivityLicense.Member.MembershipCode,
      FirstName = im.ConstructionLicense.MainOwner!.FirstName ?? string.Empty,
      LastName = im.ConstructionLicense.MainOwner!.LastName ?? string.Empty,
      Status = im.Status.Title ?? string.Empty,
      DossierNumber = im.ConstructionLicense.DossierNumber ?? string.Empty,
      DossierDate = ConvertToPersianDate(im.ConstructionLicense?.DossierDate, persianCalendar),
      RefNumber = im.ConstructionLicense?.RefNumber ?? string.Empty,
      LicenseNumber = im.ConstructionLicense?.LicenseNumber ?? string.Empty,
      LicenseDate = ConvertToPersianDate(im.ConstructionLicense?.LicenseDate, persianCalendar),
      RequestDate = ConvertToPersianDate(im.ConstructionLicense?.RequestDate, persianCalendar),
      BeforeWideningArea = im.ConstructionLicense?.BeforeWideningArea,
      AfterWideningArea = im.ConstructionLicense?.AfterWideningArea,
      OccupancyPercentage = im.ConstructionLicense?.OccupancyPercentage,
      LicenseRegDate = ConvertToPersianDate(im.ConstructionLicense?.RegDate, persianCalendar),
      InvolvedMemberStatusTitle = im.Status.Title ?? string.Empty,
      InvolvedMemberRegDate = ConvertToPersianDate(im.RegDate, persianCalendar),
      InvolvedMemberExpireDate = ConvertToPersianDate(im.ExpireDate, persianCalendar),
      IsCoordinator = im.IsCoordinator,
      WorkItem = im.WorkItem,
      Description = im.Description ?? string.Empty,
      ModifiedWorkItem = im.ModifiedWorkItem,
      Metraje = im.Metraje,
      BuildingMetraje = im.ConstructionLicense?.Floors.Where(x => x.FloorRegisterStepId == 1)
                             .Sum(x => x.BuildingUnits.Sum(v => v.Area)),
      QuotaYear = im.QuotaYear,
      ServiceTypeTitle = im.MemberService.ServiceType.Title ?? string.Empty,
      ServiceFieldTitle = im.MemberService.ServiceField != null ? im.MemberService.ServiceField.Title : string.Empty,
      BuildingGroup = im.ConstructionLicense?.BuildingGroupSetting!.SubGroup.Title ?? string.Empty,
      BuildingType = im.ConstructionLicense?.DossierType.Title ?? string.Empty,
      LastCeiling = im.SupervisionStepForms.OrderBy(x=>x.RegDate).LastOrDefault()?.Step.FormNumber.ToString() ?? string.Empty,
  }).ToList();

  // Set the index values
  involvedMembers = involvedMembers.Select((item, index) =>
  {
      item.Index = index + 1; // Index starts from 1
      return item;
  }).ToList();

  return involvedMembers;
}

private string ConvertToPersianDate(DateTime? date, PersianCalendar persianCalendar)
{
    if (date == null) return string.Empty;
    return $"{persianCalendar.GetYear(date.Value)}/{persianCalendar.GetMonth(date.Value):00}/{persianCalendar.GetDayOfMonth(date.Value):00}";
}



  private void RegisterDataSources(FastReport.Report report, List<InvolvedMemberViewModel> involvedMembers)
  {
    report.RegisterData(involvedMembers.ToDataTable(), "InvolvedMembers");
  }

  private async Task<string> RenderReportAsync()
  {
    using var memoryStream = new MemoryStream();
    WebReport?.Report.Export(new HTMLExport(), memoryStream);
    memoryStream.Position = 0;
    using var reader = new StreamReader(memoryStream);
    return await reader.ReadToEndAsync();
  }
}

public class SearchInvolvedMembersFilterModel
{
  [Required(ErrorMessage = "Membership Code is required.")]
  public string MembershipCode { get; set; } = default!;

  public int? Years { get; set; } = 3;
  public int? ServiceTypeId { get; set; }
  public int? ServiceFieldId { get; set; }
  public int? InvolvedMemberStatusId { get; set; } = 2;
  public int? DossierTypeId { get; set; }
}

public class InvolvedMemberViewModel
{
  public int Index { get; set; } // This property will hold the index value
  public int MemberId { get; set; }
  public string MembershipCode { get; set; } = default!;
  public string FirstName { get; set; } = default!;
  public string LastName { get; set; } = default!;
  public string Status { get; set; } = default!;
  public string DossierNumber { get; set; } = default!;
  public string? DossierDate { get; set; }
  public string RefNumber { get; set; } = default!;
  public string LicenseNumber { get; set; } = default!;
  public string? LicenseDate { get; set; }
  public string? RequestDate { get; set; }
  public float? BeforeWideningArea { get; set; }
  public float? AfterWideningArea { get; set; }
  public float? OccupancyPercentage { get; set; }
  public string? LicenseRegDate { get; set; }
  public string InvolvedMemberStatusTitle { get; set; } = default!;
  public string InvolvedMemberRegDate { get; set;}= default!;
  public string InvolvedMemberExpireDate { get; set;}= default!;
  public bool IsCoordinator { get; set; }
  public double? WorkItem { get; set; }
  public string Description { get; set; } = default!;
  public bool ModifiedWorkItem { get; set; }
  public double? Metraje { get; set; }
  public double? BuildingMetraje { get; set; }
  public int? QuotaYear { get; set; }
  public string ServiceTypeTitle { get; set; } = default!;
  public string ServiceFieldTitle { get; set; } = default!;
  public string BuildingType { get; set; } = default!; 
  public string LastCeiling { get; set; } = default!; 
  public string BuildingGroup { get; set; } = default!; 
}


public class InvolvedMemberReportParameters
{
  public string FirstName { get; set; } = string.Empty;
  public string LastName { get; set; } = string.Empty;
  public string NationalNumber { get; set; } = string.Empty;
  public string MembershipNumber { get; set; } = string.Empty;
  public string PhoneNumber { get; set; } = string.Empty;
  public string Agency { get; set; } = string.Empty;
}