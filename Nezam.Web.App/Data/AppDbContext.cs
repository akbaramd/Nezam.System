using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Nezam.System.Web.Data.Models;

namespace Nezam.System.Web.Data;

public class AppDbContext : IdentityDbContext<User,IdentityRole<Guid>,Guid>
{
  public AppDbContext(DbContextOptions<AppDbContext> options):base(options)
  {
    
  }

  public DbSet<UserAgency> UserAgencies { get; set; }
}
