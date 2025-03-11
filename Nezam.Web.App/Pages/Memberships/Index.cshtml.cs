using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data;
using Nezam.System.Web.Data.Cedo;

namespace Nezam.System.Web.Pages.Memberships
{
  [Authorize(Policy = "ManageMemberships")]
  public class IndexModel : PageModel
  {
    private readonly CedoContext _context;
    private const int PageSize = 20;  // Adjust page size as needed
    private readonly AppDbContext _appDbContext;
    public IndexModel(CedoContext context, AppDbContext appDbContext)
    {
      _context = context;
      _appDbContext = appDbContext;
    }

    public List<Member> Members { get; set; } = new();

    [BindProperty(SupportsGet = true)]
    public string SearchQuery { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true)]
    public int CurrentPage { get; set; } = 1;

    public int TotalPages { get; set; }

    public async Task<IActionResult> OnGetAsync()
    {
      // Get the current user's agencies
      var currentUserId = User.FindFirstValue(ClaimTypes.NameIdentifier);
      var userAgencies = await _appDbContext.UserAgencies
        .Where(ua => currentUserId != null && ua.UserId == Guid.Parse(currentUserId))
        .Select(ua => ua.AgencyCode) // Changed from AgencyCode to AgencyId to match the data model
        .ToListAsync();

      // Start with the base query
      var query = _context.Members
        .Include(x => x.ActivityLicenses)
        .ThenInclude(x => x.MemberServices)
        .ThenInclude(x => x.City)
        .AsQueryable();

      // Filter by user's agencies - only show members whose active license was issued by one of the user's agencies
      if (userAgencies.Any())
      {
        query = query.Where(m =>
          m.ActivityLicenses.Any(license =>
            license != null &&
            (
            
              // Check if any member service's city matches any user agency
              (license.MemberServices != null && 
               license.MemberServices.Any(service => 
                 service.City != null && 
                 service.City.SyncCode != null && 
                 userAgencies.Contains(service.City.SyncCode.Value)))
            )
          ));
      }
      else
      {
        // If the user doesn't have any agencies, show no results
        Members = new List<Member>();
        TotalPages = 0;
        return Page();
      }

      // Apply search filter if provided
      if (!string.IsNullOrEmpty(SearchQuery))
      {
        query = query.Where(m =>
          (m.MembershipCode.Contains(SearchQuery)) ||
          (m.User.UserProfile != null && m.User.UserProfile.FirstName.Contains(SearchQuery)) ||
          (m.User.UserProfile != null && m.User.UserProfile.LastName.Contains(SearchQuery)) ||
          (m.User.UserProfile != null && m.User.UserProfile.NationalCode != null &&
           m.User.UserProfile.NationalCode.Contains(SearchQuery)) ||
          (m.User.Email != null && m.User.Email.Contains(SearchQuery))
        );
      }

      // Calculate pagination
      var totalMembers = await query.CountAsync();
      TotalPages = (int)Math.Ceiling(totalMembers / (double)PageSize);

      // Get the final list of members with includes
      Members = await query
        .Include(m => m.User)
        .ThenInclude(m => m.UserProfile)
        .Include(m => m.ActivityLicenses)
        .ThenInclude(x => x.MemberServices)// Include active license for filtering
        .ThenInclude(x => x.City)// Include active license for filtering
        .OrderBy(m => m.User.UserName)
        .Skip((CurrentPage - 1) * PageSize)
        .Take(PageSize)
        .ToListAsync();

      return Page();
    }
  }
  }
