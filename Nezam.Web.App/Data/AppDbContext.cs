using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Velzon.Data.Models;

namespace Velzon.Data;

public class AppDbContext : IdentityDbContext<User,IdentityRole<Guid>,Guid>
{
  public AppDbContext(DbContextOptions<AppDbContext> options):base(options)
  {
    
  }
}
