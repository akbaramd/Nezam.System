using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.Extensions.Localization;
using Nezam.System.Web.Data.Models;
using Nezam.System.Web.Extensions;
using Nezam.System.Web.Models;

namespace Nezam.System.Web.Pages.Admin.Users;

[Authorize(Policy = "ManageUsers")]
public class CreateModel : PageModel
{
    private readonly UserManager<User> _userManager;
    private readonly RoleManager<IdentityRole<Guid>> _roleManager;
    private readonly IStringLocalizer<GlobalResource> _globalLocalizer;

    public CreateModel(UserManager<User> userManager, RoleManager<IdentityRole<Guid>> roleManager, IStringLocalizer<GlobalResource> globalLocalizer)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _globalLocalizer = globalLocalizer;

        UserRoles = new List<string>();
        UserClaims = new List<Claim>();
        SelectedRoles = new List<string>();
        SelectedClaims = new List<string>();
        AvailableRoles = new List<LocalizerModel>();
        AvailableClaims = new List<LocalizerModel>();
    }

    [BindProperty]
    [Required(ErrorMessage = "نام کاربری الزامی است.")]
    public string UserName { get; set; } = string.Empty;

    [BindProperty]
    [Required(ErrorMessage = "ایمیل الزامی است.")]
    [EmailAddress(ErrorMessage = "ایمیل وارد شده معتبر نیست.")]
    public string Email { get; set; } = string.Empty;

    [BindProperty]
    [Required(ErrorMessage = "رمز عبور الزامی است.")]
    [DataType(DataType.Password)]
    public string Password { get; set; } = string.Empty;

    [BindProperty]
    [Required(ErrorMessage = "تأیید رمز عبور الزامی است.")]
    [DataType(DataType.Password)]
    [Compare("Password", ErrorMessage = "رمز عبور و تأیید آن مطابقت ندارند.")]
    public string ConfirmPassword { get; set; } = string.Empty;

    [BindProperty]
    public List<string> SelectedRoles { get; set; }

    [BindProperty]
    public List<string> SelectedClaims { get; set; }

    public List<LocalizerModel> AvailableRoles { get; set; }
    public List<LocalizerModel> AvailableClaims { get; set; }

    public IList<string> UserRoles { get; set; }
    public IList<Claim> UserClaims { get; set; }

    public Task OnGetAsync()
    {
        AvailableRoles = _roleManager.Roles
            .Select(role => new LocalizerModel
            {
                Title = _globalLocalizer[role.Name ?? string.Empty],
                Value = role.Name
            })
            .ToList();

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
            // Return the validation errors as a partial view
            return Partial("_ValidationSummary", this);
        }

        var user = new User
        {
            UserName = UserName,
            Email = Email
        };

        var createUserResult = await _userManager.CreateAsync(user, Password);

        if (!createUserResult.Succeeded)
        {
            foreach (var error in createUserResult.Errors)
            {
                ModelState.AddModelError(string.Empty, error.Description);
            }
            return Partial("_ValidationSummary", this);
        }

        if (SelectedRoles.Any())
        {
            var addRolesResult = await _userManager.AddToRolesAsync(user, SelectedRoles);
            if (!addRolesResult.Succeeded)
            {
                foreach (var error in addRolesResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this);
            }
        }

        foreach (var claim in SelectedClaims)
        {
            var addClaimResult = await _userManager.AddClaimAsync(user, new Claim(claim, "true"));
            if (!addClaimResult.Succeeded)
            {
                foreach (var error in addClaimResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this);
            }
        }

        // If successful, return JSON result indicating success
        return new JsonResult(new { success = true });
    }
}
