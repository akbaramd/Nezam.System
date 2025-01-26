using System.Globalization;
using System.Security.Claims;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc.Razor;
using Nezam.CES.Data;
using Nezam.System.Web;
using Nezam.System.Web.Data.Models;
using Nezam.System.Web.Data.Cedo;
using Nezam.System.Web.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews()
    .AddViewLocalization(LanguageViewLocationExpanderFormat.Suffix)
    .AddDataAnnotationsLocalization();

// Add Razor Pages support
builder.Services.AddRazorPages();

// Add DbContext with SQLite
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

builder.Services.AddDbContext<CedoContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("CedoConnection")));
builder.Services.AddDbContext<KolahiDbContext>(options =>
  options.UseSqlServer(builder.Configuration.GetConnectionString("KolahiConnection")));

// Add Identity services
builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");

builder.Services.AddIdentity<User, IdentityRole<Guid>>(options =>
{
    options.Password.RequireDigit = true;
    options.Password.RequiredLength = 6;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequireUppercase = false;
    options.Password.RequireLowercase = false;
})
.AddEntityFrameworkStores<AppDbContext>()
.AddDefaultTokenProviders();

// Add cookie authentication
builder.Services.AddAuthentication(CookieAuthenticationDefaults.AuthenticationScheme)
    .AddCookie(options =>
    {
        options.Cookie.HttpOnly = true;
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
        options.Cookie.SameSite = SameSiteMode.Strict;
        options.Cookie.Name = "YourAuthCookie";
        options.ExpireTimeSpan = TimeSpan.FromHours(1);
        options.SlidingExpiration = true;
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.AccessDeniedPath = "/Account/AccessDenied";
    });

// Add FastReport
builder.Services.AddFastReport();
// Register policies from attributes
builder.Services.AddAuthorization(options =>
{
    options.RegisterPoliciesFromControllersAndPages();
});

// Configure the localization options
var supportedCultures = new[] { "fa-IR" };
builder.Services.Configure<RequestLocalizationOptions>(options =>
{
    options.DefaultRequestCulture = new RequestCulture("fa-IR");
    options.SupportedCultures = supportedCultures.Select(c => new CultureInfo(c)).ToList();
    options.SupportedUICultures = supportedCultures.Select(c => new CultureInfo(c)).ToList();
    options.RequestCultureProviders =
    [
      new QueryStringRequestCultureProvider(),
      new CookieRequestCultureProvider(),
      new AcceptLanguageHeaderRequestCultureProvider()
    ];
});

var app = builder.Build();

// Seed the database
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var userManager = services.GetRequiredService<UserManager<User>>();
    RoleManager<IdentityRole<Guid>> roleManager = services.GetRequiredService<RoleManager<IdentityRole<Guid>>>();
    await SeedData.Initialize(userManager, roleManager);
}

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthentication(); // Add authentication middleware
app.UseAuthorization();

// Apply localization
app.UseRequestLocalization();

app.UseFastReport();
app.MapRazorPages();

app.MapControllerRoute(
    name: "areas",
    pattern: "{area:exists}/{controller=Home}/{action=Index}/{id?}"
);

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();


public  class SeedData
{
    public static async Task Initialize(UserManager<User> userManager, RoleManager<IdentityRole<Guid>> roleManager)
    {
        // Ensure the "developer" role exists
        IdentityRole<Guid>? developerRole = null;
        if (!await roleManager.RoleExistsAsync("developer"))
        {
            developerRole = new IdentityRole<Guid>("developer");
            await roleManager.CreateAsync(developerRole);
        }
        else
        {
            developerRole = await roleManager.FindByNameAsync("developer");
        }

        // Extract all policies (permissions)
        var policyNames = PolicyRegistrationHelper.ExtractPoliciesFromControllersAndPages();

        // Add all policies as claims to the developer role
        foreach (var policyName in policyNames)
        {
          if (developerRole != null)
          {
            if (!(await roleManager.GetClaimsAsync(developerRole)).Select(x=>x.Type).Contains(policyName))
            {
                await roleManager.AddClaimAsync(developerRole, new Claim(policyName, "true"));
            }
          }
        }

        // Check if the user already exists
        var user = await userManager.FindByNameAsync("2741153671");
        if (user == null)
        {
            // Create the user
            user = new User
            {
                UserName = "2741153671",
                Email = "example@example.com", // Adjust if needed
                PhoneNumber = "09371770774",
                FirstName = "akbar",
                LastName = "Ahmadi",
            };
            var result = await userManager.CreateAsync(user, "2741153671");

            if (result.Succeeded)
            {
                // Assign the "developer" role to the user
                await userManager.AddToRoleAsync(user, "developer");

                // Add all policies as claims to the user
                foreach (var policyName in policyNames)
                {
                    await userManager.AddClaimAsync(user, new Claim(policyName, "true"));
                }
            }
            else
            {
                // Handle the case where user creation failed
                throw new Exception("Failed to create seed user.");
            }
        }
        else
        {
            // Ensure the user has the developer role
            if (!await userManager.IsInRoleAsync(user, "developer"))
            {
                await userManager.AddToRoleAsync(user, "developer");
            }

            // Ensure the user has all policy claims
            foreach (var policyName in policyNames)
            {
                var hasClaim = (await userManager.GetClaimsAsync(user)).Any(c => c.Type == policyName);
                if (!hasClaim)
                {
                    await userManager.AddClaimAsync(user, new Claim(policyName, "true"));
                }
            }
        }
    }
}
