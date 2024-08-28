using System.Security.Claims;
using Nezam.System.Web.Data.Models;

namespace Nezam.System.Web;

public class MenuService
{
  private readonly ClaimsPrincipal _user;

  public MenuService(ClaimsPrincipal user)
  {
    _user = user;
  }
  public List<MenuItem> GetMenu()
  {
    var menuItems = MenuConfig.GetMenuItems();

    return FilterMenuItems(menuItems, _user);
  }

  private List<MenuItem> FilterMenuItems(List<MenuItem> menuItems, ClaimsPrincipal? user)
  {
    return menuItems
      .Where(item => user != null && (string.IsNullOrEmpty(item.RequiredClaim) ||
                                      user.HasClaim(item.RequiredClaim, item.ClaimValue)))
      .Select(item =>
      {
        var filteredChildren = FilterMenuItems(item.Children, user);
        return new MenuItem
        {
          Title = item.Title,
          Page = item.Page,
          Icon = item.Icon,
          Children = filteredChildren,
          RequiredClaim = item.RequiredClaim,
          ClaimValue = item.ClaimValue
        };
      })
      .Where(item => item.Children.Any() || !string.IsNullOrEmpty(item.Page))
      .ToList();
  }
}
