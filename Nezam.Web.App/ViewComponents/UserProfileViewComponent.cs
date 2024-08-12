using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Threading.Tasks;
using Velzon.Data.Models;

namespace Velzon.ViewComponents
{
  public class UserProfile : ViewComponent
  {
    private readonly UserManager<User> _userManager;

    public UserProfile(UserManager<User> userManager)
    {
      _userManager = userManager;
    }

    public async Task<IViewComponentResult> InvokeAsync()
    {
      var user = await _userManager.GetUserAsync(HttpContext.User);
      return View(user);
    }
  }
}
