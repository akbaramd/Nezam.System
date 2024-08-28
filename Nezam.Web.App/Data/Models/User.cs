using Microsoft.AspNetCore.Identity;

namespace Nezam.System.Web.Data.Models;

public class User : IdentityUser<Guid>
{
  public string FirstName { get; set; } = string.Empty; 
  public string LastName { get; set; } = string.Empty;
}
