using Microsoft.AspNetCore.Mvc;

namespace Nezam.System.Web.Controllers
{
    public class LandingController : Controller
    {
        public IActionResult Index()
        {
            return View();
        }
        public IActionResult NFTLanding()
        {
            return View();
        }
        public IActionResult Job()
        {
            return View();
        }
    }
}
