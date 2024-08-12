using Microsoft.AspNetCore.Identity;

namespace Velzon.Data.Models;

public class User : IdentityUser<Guid>
{
  public string FirstName { get; set; } = string.Empty; 
  public string LastName { get; set; } = string.Empty;
}
