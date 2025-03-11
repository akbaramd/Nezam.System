using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Localization;
using Nezam.CES.Data;
using Nezam.CES.Data.Models;
using Nezam.System.Web.Data;
using Nezam.System.Web.Data.Models;
using Nezam.System.Web.Extensions;
using Nezam.System.Web.Models;

namespace Nezam.System.Web.Pages.Admin.Users;

[Authorize(Policy = "ManageUsers")]
public class EditModel : PageModel
{
    private readonly UserManager<User> _userManager;
    private readonly IStringLocalizer<GlobalResource> _globalLocalizer;
    private readonly RoleManager<IdentityRole<Guid>> _roleManager;
    private readonly KolahiDbContext _kolahiDbContext;
    private readonly AppDbContext _appDbContext;

    public EditModel(
        UserManager<User> userManager, 
        RoleManager<IdentityRole<Guid>> roleManager, 
        IStringLocalizer<GlobalResource> globalLocalzier,
        KolahiDbContext kolahiDbContext,
        AppDbContext appDbContext)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _globalLocalizer = globalLocalzier;
        _kolahiDbContext = kolahiDbContext;
        _appDbContext = appDbContext;
    }

    [BindProperty]
    public User UserModel { get; set; } = new();

    [BindProperty]
    public List<string> SelectedRoles { get; set; } = new();

    [BindProperty]
    public List<string> SelectedClaims { get; set; } = new();
    [BindProperty]
    public string SelectedAgencies{ get; set; }  = string.Empty;

 
    public List<int> SelectedAgenciesList  => SelectedAgencies.Split(",").Select(x=>int.Parse(x)).ToList();

    public List<LocalizerModel> AvailableRoles { get; set; } = new();
    public List<LocalizerModel> AvailableClaims { get; set; } = new();
    public List<TblDafaterOstan> AvailableAgencies { get; set; } = new();
    public IList<string> UserRoles { get; set; } = new List<string>();
    public IList<Claim> UserClaims { get; set; } = new List<Claim>();
    public List<UserAgencyViewModel> UserAgencies { get; set; } = new();

    public async Task<IActionResult> OnGetAsync(Guid id)
    {
        UserModel = (await _userManager.FindByIdAsync(id.ToString()))!;

        AvailableRoles = _roleManager.Roles
            .Select(x => new LocalizerModel
            {
                Title = _globalLocalizer[x.Name ?? string.Empty],
                Value = x.Name
            }).ToList();

        AvailableClaims = PolicyRegistrationHelper
            .ExtractPoliciesFromControllersAndPages()
            .Select(x => new LocalizerModel
            {
                Title = _globalLocalizer[x],
                Value = x
            }).ToList();
            
        // Load available agencies from KolahiDbContext
        AvailableAgencies = await _kolahiDbContext.TblDafaterOstans
            .OrderBy(a => a.Title)
            .ToListAsync();
            
        // Load user's agencies
        var userAgencies = await _appDbContext.UserAgencies
            .Where(ua => ua.UserId == id)
            .ToListAsync();
            
        UserAgencies = new List<UserAgencyViewModel>();
        
        foreach (var agency in userAgencies)
        {
            var agencyInfo = await _kolahiDbContext.TblDafaterOstans
                .FirstOrDefaultAsync(a => a.Id == agency.AgencyCode);
                
            if (agencyInfo != null)
            {
                UserAgencies.Add(new UserAgencyViewModel
                {
                    AgencyId = agencyInfo.Id,
                    AgencyTitle = agencyInfo.Title ?? "بدون عنوان"
                });
                
                
            }
        }

        SelectedAgencies = string.Join(',', userAgencies.Select(x => x.AgencyCode));

        UserRoles = await _userManager.GetRolesAsync(UserModel);
        UserClaims = await _userManager.GetClaimsAsync(UserModel);

        SelectedRoles = UserRoles.ToList();
        SelectedClaims = UserClaims.Select(c => c.Type).ToList();

        return Page();
    }

    public async Task<IActionResult> OnPostAsync(Guid id)
    {
       
        

        var userToUpdate = await _userManager.FindByIdAsync(id.ToString());

        if (userToUpdate == null)
        {
            return NotFound();
        }

        userToUpdate.UserName = UserModel.UserName;
        userToUpdate.Email = UserModel.Email;

        var updateResult = await _userManager.UpdateAsync(userToUpdate);

        if (!updateResult.Succeeded)
        {
            foreach (var error in updateResult.Errors)
            {
                ModelState.AddModelError(string.Empty, error.Description);
            }
            return Partial("_ValidationSummary", this);
        }

        var currentRoles = await _userManager.GetRolesAsync(userToUpdate);
        var rolesToAdd = SelectedRoles.Except(currentRoles).ToList();
        var rolesToRemove = currentRoles.Except(SelectedRoles).ToList();

        if (rolesToAdd.Any())
        {
            var addRolesResult = await _userManager.AddToRolesAsync(userToUpdate, rolesToAdd);
            if (!addRolesResult.Succeeded)
            {
                foreach (var error in addRolesResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this);
            }
        }

        if (rolesToRemove.Any())
        {
            var removeRolesResult = await _userManager.RemoveFromRolesAsync(userToUpdate, rolesToRemove);
            if (!removeRolesResult.Succeeded)
            {
                foreach (var error in removeRolesResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this);
            }
        }

        var currentClaims = await _userManager.GetClaimsAsync(userToUpdate);
        var claimsToAdd = SelectedClaims.Except(currentClaims.Select(c => c.Type)).ToList();
        var claimsToRemove = currentClaims.Select(c => c.Type).Except(SelectedClaims).ToList();

        foreach (var claim in claimsToAdd)
        {
            var addClaimResult = await _userManager.AddClaimAsync(userToUpdate, new Claim(claim, "true"));
            if (!addClaimResult.Succeeded)
            {
                foreach (var error in addClaimResult.Errors)
                {
                    ModelState.AddModelError(string.Empty, error.Description);
                }
                return Partial("_ValidationSummary", this);
            }
        }

        foreach (var claim in claimsToRemove)
        {
            var claimToRemove = currentClaims.FirstOrDefault(c => c.Type == claim);
            if (claimToRemove != null)
            {
                var removeClaimResult = await _userManager.RemoveClaimAsync(userToUpdate, claimToRemove);
                if (!removeClaimResult.Succeeded)
                {
                    foreach (var error in removeClaimResult.Errors)
                    {
                        ModelState.AddModelError(string.Empty, error.Description);
                    }
                    return Partial("_ValidationSummary", this);
                }
            }
        }
        
        // Update user agencies
        try
        {
            // Get current user agencies
            var currentAgencies = await _appDbContext.UserAgencies
                .Where(ua => ua.UserId == id)
                .ToListAsync();
                
            // Get agencies to remove
            var currentAgencyCodes = currentAgencies.Select(a => a.AgencyCode).ToList();
            var agenciesToRemove = currentAgencies
                .Where(a => !SelectedAgenciesList.Contains(a.AgencyCode))
                .ToList();
                
            // Get agencies to add
            var agenciesToAdd = SelectedAgenciesList
                .Where(code => !currentAgencyCodes.Contains(code))
                .Select(code => new UserAgency
                {
                    Id = Guid.NewGuid(),
                    UserId = id,
                    AgencyCode = code
                })
                .ToList();
                
            // Remove agencies
            _appDbContext.UserAgencies.RemoveRange(agenciesToRemove);
            
            // Add new agencies
            await _appDbContext.UserAgencies.AddRangeAsync(agenciesToAdd);
            
            // Save changes
            await _appDbContext.SaveChangesAsync();
        }
        catch (Exception ex)
        {
            ModelState.AddModelError(string.Empty, $"خطا در بروزرسانی دفاتر استان: {ex.Message}");
            return Partial("_ValidationSummary", this);
        }

        // If successful, return JSON result indicating success
        return new JsonResult(new { success = true });
    }
    
    public class UserAgencyViewModel
    {
        public int AgencyId { get; set; }
        public string AgencyTitle { get; set; } = string.Empty;
    }
}
