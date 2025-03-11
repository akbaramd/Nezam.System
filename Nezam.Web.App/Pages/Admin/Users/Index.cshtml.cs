using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Nezam.System.Web.Data.Models;

namespace Nezam.System.Web.Pages.Admin.Users
{
  [Authorize(Policy = "ManageUsers")]
    public class IndexModel : PageModel
    {
        private readonly UserManager<User> _userManager;
        private const int PageSize = 5;  // Adjust page size as needed

        public IndexModel(UserManager<User> userManager)
        {
            _userManager = userManager;
        }

        public List<User> Users { get; set; } = new();

        [BindProperty(SupportsGet = true)] 
        public string SearchQuery { get; set; } = string.Empty;

        [BindProperty(SupportsGet = true)] 
        public int CurrentPage { get; set; } = 1;

        public int TotalPages { get; set; }

        public async Task<IActionResult> OnGetAsync()
        {
            var query = _userManager.Users.AsQueryable();

            if (!string.IsNullOrEmpty(SearchQuery))
            {
                query = query.Where(u =>
                    (u.UserName != null && u.UserName.Contains(SearchQuery)) ||
                    (u.Email != null && u.Email.Contains(SearchQuery)) ||
                    (u.PhoneNumber != null && u.PhoneNumber.Contains(SearchQuery))
                );
            }

            var totalUsers = await query.CountAsync();
            TotalPages = (int)Math.Ceiling(totalUsers / (double)PageSize);

            Users = await query
                .OrderBy(u => u.UserName)
                .Skip((CurrentPage - 1) * PageSize)
                .Take(PageSize)
                .ToListAsync();

            return Page();
        }

        public async Task<JsonResult> OnPostDeleteAsync(string id)
        {
          if (string.IsNullOrEmpty(id))
          {
            return new JsonResult(new { success = false, message = "شناسه کاربر نامعتبر است." });
          }

          var user = await _userManager.FindByIdAsync(id);
          if (user == null)
          {
            return new JsonResult(new { success = false, message = "کاربر یافت نشد." });
          }

          var roles = await _userManager.GetRolesAsync(user);
          if (roles.Contains("developer"))
          {
            return new JsonResult(new { success = false, message = "حذف کاربری با نقش توسعه‌دهنده امکان‌پذیر نیست." });
          }

          var result = await _userManager.DeleteAsync(user);
          if (result.Succeeded)
          {
            return new JsonResult(new { success = true, message = "کاربر با موفقیت حذف شد." });
          }

          return new JsonResult(new { success = false, message = "خطا در حذف کاربر." });
        }
    }
}
