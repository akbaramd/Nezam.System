using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Nezam.System.Web.Pages.Admin;

[Authorize(Policy = "AdminAccess")]
public class IndexModel : PageModel
{
  public void OnGet()
  {
  }
}