using Microsoft.AspNetCore.Mvc;
using System.Data;
using System.IO;
using FastReport;
using FastReport.Export.PdfSimple;
using Microsoft.AspNetCore.Authorization;

namespace Velzon.Controllers
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