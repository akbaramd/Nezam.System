using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data.Models;

namespace Nezam.System.Web.Pages.Admin.Roles
{
    [Authorize(Policy = "ManageRoles")]
    public class IndexModel : PageModel
    {
        private readonly RoleManager<IdentityRole<Guid>> _roleManager;
        private readonly UserManager<User> _userManager;
        private const int PageSize = 5;  // Adjust page size as needed

        public IndexModel(RoleManager<IdentityRole<Guid>> roleManager, UserManager<User> userManager)
        {
            _roleManager = roleManager;
            _userManager = userManager;
        }

        public List<RoleViewModel> Roles { get; set; } = new();

        [BindProperty(SupportsGet = true)]
        public string SearchQuery { get; set; } = string.Empty;

        [BindProperty(SupportsGet = true)]
        public int CurrentPage { get; set; } = 1;

        public int TotalPages { get; set; }

        public async Task<IActionResult> OnGetAsync()
        {
            var query = _roleManager.Roles.AsQueryable();

            if (!string.IsNullOrEmpty(SearchQuery))
            {
                query = query.Where(r => r.Name != null && r.Name.Contains(SearchQuery));
            }

            var totalRoles = await query.CountAsync();
            TotalPages = (int)Math.Ceiling(totalRoles / (double)PageSize);

            var roles = await query
                .OrderBy(r => r.Name)
                .Skip((CurrentPage - 1) * PageSize)
                .Take(PageSize)
                .ToListAsync();
            

            Roles = roles.Select(r => new RoleViewModel
            {
                Id = r.Id,
                Name = r.Name,
                Claims = _roleManager.GetClaimsAsync(r).Result.Select(c => c.Type).Distinct().ToList()
            }).ToList();

            return Page();
        }

        public async Task<JsonResult> OnPostDeleteAsync(Guid id)
        {
            if (id == Guid.Empty)
            {
                return new JsonResult(new { success = false, message = "شناسه نقش نامعتبر است." });
            }

            var role = await _roleManager.FindByIdAsync(id.ToString());
            if (role == null)
            {
                return new JsonResult(new { success = false, message = "نقش یافت نشد." });
            }

            if (role.Name != null && role.Name.Equals("Developer", StringComparison.OrdinalIgnoreCase))
            {
                return new JsonResult(new { success = false, message = "حذف نقش توسعه‌دهنده امکان‌پذیر نیست." });
            }

            var result = await _roleManager.DeleteAsync(role);
            if (result.Succeeded)
            {
                return new JsonResult(new { success = true, message = "نقش با موفقیت حذف شد." });
            }

            return new JsonResult(new { success = false, message = "خطا در حذف نقش." });
        }
    }

    public class RoleViewModel
    {
        public Guid Id { get; set; }
        public string? Name { get; set; } = string.Empty;
        public List<string> Claims { get; set; } = new();
    }
}
