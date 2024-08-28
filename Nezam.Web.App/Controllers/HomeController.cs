using Microsoft.AspNetCore.Mvc;
using System.Data;
using Microsoft.AspNetCore.Authorization;

namespace Nezam.System.Web.Controllers
{
  [Authorize]
  public class HomeController : Controller
  {
    public IActionResult Index()
    {
      var user = User;
      return View();
    }

  }
}