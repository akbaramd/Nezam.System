using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Localization;
using Nezam.System.Web.Extensions;
using Nezam.System.Web.Models;

namespace Nezam.System.Web.Pages.Admin.Roles
{
    [Authorize(Policy = "ManageUsers")]
    public class CreateModel : PageModel
    {
        private readonly RoleManager<IdentityRole<Guid>> _roleManager;
        private readonly IStringLocalizer<GlobalResource> _globalLocalizer;

        public CreateModel(RoleManager<IdentityRole<Guid>> roleManager, IStringLocalizer<GlobalResource> globalLocalizer)
        {
            _roleManager = roleManager;
            _globalLocalizer = globalLocalizer;
            AvailableClaims = new List<LocalizerModel>();
            SelectedClaims = new List<string>();
        }

        [BindProperty]
        [Required(ErrorMessage = "نام نقش الزامی است.")]
        public string RoleName { get; set; } = string.Empty;

        [BindProperty]
        public List<string> SelectedClaims { get; set; }

        public List<LocalizerModel> AvailableClaims { get; set; }

        public Task OnGetAsync()
        {
            AvailableClaims = PolicyRegistrationHelper
                .ExtractPoliciesFromControllersAndPages()
                .Select(policy => new LocalizerModel
                {
                    Title = _globalLocalizer[policy],
                    Value = policy
                })
                .ToList();

            return Task.CompletedTask;
        }

        public async Task<IActionResult> OnPostAsync()
        {
            if (!ModelState.IsValid)
            {
                return Partial("_ValidationSummary", this); // Return the validation errors view
            }

            var role = new IdentityRole<Guid>
            {
                Name = RoleName
            };

            var createRoleResult = await _roleManager.CreateAsync(role);

            if (!createRoleResult.Succeeded)
            {
                foreach (var error in createRoleResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this); // Return the validation errors view
            }

            foreach (var claim in SelectedClaims)
            {
                var addClaimResult = await _roleManager.AddClaimAsync(role, new Claim(claim, "true"));
                if (!addClaimResult.Succeeded)
                {
                    foreach (var error in addClaimResult.Errors)
                    {
                        ModelState.AddModelError(string.Empty, error.Description);
                    }
                    return Partial("_ValidationSummary", this); // Return the validation errors view
                }
            }

            // If successful, return JSON result
            return new JsonResult(new { success = true });
        }
    }
}
