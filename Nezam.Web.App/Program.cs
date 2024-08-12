using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Velzon.Data;
using Velzon.Data.Models;
using Microsoft.AspNetCore.Authentication.Cookies;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();
// Add Razor Pages support
builder.Services.AddRazorPages();
// Add DbContext with SQLite
builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseSqlite(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add Identity services
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
        options.ExpireTimeSpan = TimeSpan.FromHours(1); // Adjust MaxAge equivalent in ExpireTimeSpan
        options.SlidingExpiration = true;
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.AccessDeniedPath = "/Account/AccessDenied";
    });

// Add FastReport
builder.Services.AddFastReport();

var app = builder.Build();

// Seed the database
using (var scope = app.Services.CreateScope())
{
    var services = scope.ServiceProvider;
    var userManager = services.GetRequiredService<UserManager<User>>();
    var roleManager = services.GetRequiredService<RoleManager<IdentityRole<Guid>>>();
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

public static class SeedData
{
    public static async Task Initialize(UserManager<User> userManager, RoleManager<IdentityRole<Guid>> roleManager)
    {
        // Ensure the "developer" role exists
        if (!await roleManager.RoleExistsAsync("developer"))
        {
            await roleManager.CreateAsync(new IdentityRole<Guid>("developer"));
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
                // Assign the "developer" role
                await userManager.AddToRoleAsync(user, "developer");
            }
            else
            {
                // Handle the case where user creation failed
                throw new Exception("Failed to create seed user.");
            }
        }
    }
}
