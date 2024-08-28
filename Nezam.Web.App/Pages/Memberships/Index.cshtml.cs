using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data.Cedo;

namespace Nezam.System.Web.Pages.Memberships
{
  [Authorize(Policy = "ManageMemberships")]
  public class IndexModel : PageModel
  {
    private readonly CedoContext _context;
    private const int PageSize = 20;  // Adjust page size as needed

    public IndexModel(CedoContext context)
    {
      _context = context;
    }

    public List<Member> Members { get; set; } = new();

    [BindProperty(SupportsGet = true)]
    public string SearchQuery { get; set; } = string.Empty;

    [BindProperty(SupportsGet = true)]
    public int CurrentPage { get; set; } = 1;

    public int TotalPages { get; set; }

    public async Task<IActionResult> OnGetAsync()
    {
      var query = _context.Members.AsQueryable();

      if (!string.IsNullOrEmpty(SearchQuery))
      {
        query = query.Where(m =>
          (m.MembershipCode.Contains(SearchQuery)) ||
          (m.User.UserProfile != null && m.User.UserProfile.FirstName.Contains(SearchQuery)) ||
          (m.User.UserProfile != null && m.User.UserProfile.LastName.Contains(SearchQuery)) ||
          (m.User.UserProfile != null && m.User.UserProfile.NationalCode != null && m.User.UserProfile.NationalCode.Contains(SearchQuery)) ||
          (m.User.Email != null && m.User.Email.Contains(SearchQuery))
        );
      }

      var totalMembers = await query.CountAsync();
      TotalPages = (int)Math.Ceiling(totalMembers / (double)PageSize);

      Members = await query
        .Include(m => m.User)
        .ThenInclude(m => m.UserProfile)
        .OrderBy(m => m.User.UserName)
        .Skip((CurrentPage - 1) * PageSize)
        .Take(PageSize)
        .ToListAsync();

      return Page();
    }
  }
}
