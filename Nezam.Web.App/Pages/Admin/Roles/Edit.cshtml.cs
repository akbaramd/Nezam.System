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
    public class EditModel : PageModel
    {
        private readonly RoleManager<IdentityRole<Guid>> _roleManager;
        private readonly IStringLocalizer<GlobalResource> _globalLocalizer;

        public EditModel(RoleManager<IdentityRole<Guid>> roleManager, IStringLocalizer<GlobalResource> globalLocalizer)
        {
            _roleManager = roleManager;
            _globalLocalizer = globalLocalizer;
            AvailableClaims = new List<LocalizerModel>();
            SelectedClaims = new List<string>();
        }

        [BindProperty]
        [Required(ErrorMessage = "نام نقش الزامی است.")]
        public string? RoleName { get; set; } = string.Empty;

        [BindProperty]
        public List<string> SelectedClaims { get; set; }

        public List<LocalizerModel> AvailableClaims { get; set; }

        public async Task<IActionResult> OnGetAsync(Guid id)
        {
            var role = await _roleManager.FindByIdAsync(id.ToString());

            if (role == null)
            {
                return NotFound();
            }

            RoleName = role.Name;

            var claims = await _roleManager.GetClaimsAsync(role);
            SelectedClaims = claims.Select(c => c.Type).ToList();

            AvailableClaims = PolicyRegistrationHelper
                .ExtractPoliciesFromControllersAndPages()
                .Select(policy => new LocalizerModel
                {
                    Title = _globalLocalizer[policy],
                    Value = policy
                })
                .ToList();

            return Page();
        }

        public async Task<IActionResult> OnPostAsync(Guid id)
        {
            if (!ModelState.IsValid)
            {
                return Partial("_ValidationSummary", this); // Return the validation errors view
            }

            var role = await _roleManager.FindByIdAsync(id.ToString());

            if (role == null)
            {
                return NotFound();
            }

            role.Name = RoleName;
            var updateRoleResult = await _roleManager.UpdateAsync(role);

            if (!updateRoleResult.Succeeded)
            {
                foreach (var error in updateRoleResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this); // Return the validation errors view
            }

            var currentClaims = await _roleManager.GetClaimsAsync(role);
            var claimsToRemove = currentClaims.Where(c => !SelectedClaims.Contains(c.Type)).ToList();
            var claimsToAdd = SelectedClaims.Where(c => !currentClaims.Any(cc => cc.Type == c)).ToList();

            foreach (var claim in claimsToRemove)
            {
                var removeClaimResult = await _roleManager.RemoveClaimAsync(role, claim);
                if (!removeClaimResult.Succeeded)
                {
                    foreach (var error in removeClaimResult.Errors)
                    {
                        ModelState.AddModelError(string.Empty, error.Description);
                    }
                    return Partial("_ValidationSummary", this); // Return the validation errors view
                }
            }

            foreach (var claim in claimsToAdd)
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
