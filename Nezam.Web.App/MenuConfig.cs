namespace Nezam.System.Web;

public class MenuItem
{
  public string Title { get; set; } = string.Empty;
  public string Page { get; set; }= string.Empty;
  public string Icon { get; set; }= string.Empty;
  public List<MenuItem> Children { get; set; } = new List<MenuItem>();
  public string RequiredClaim { get; set; } = string.Empty; // E.g., "ManageUsers"
  public string ClaimValue { get; set; } = "true";  // Default to true
}

public static class MenuConfig
{
  public static List<MenuItem> GetMenuItems()
  {
    return new List<MenuItem>
    {
      new MenuItem
      {
        Title = "امور مالی و حسابداری",
        RequiredClaim = "DossierAccountingReport",
        Children = new List<MenuItem>
        {
          new MenuItem
          {
            Title = "گزارشات",
            Children = new List<MenuItem>
            {
              new MenuItem
              {
                Title = "گزارش صورتحساب پرونده",
                Page = "/Report/DossierAccountingReport",
                RequiredClaim = "DossierAccountingReport"
              },
              new MenuItem
              {
                Title = "گزارش پرداخت ناظرین",
                Page = "/Report/SupervisionPaymentsReports",
                RequiredClaim = "SupervisionPaymentsReports"
              }
            }
          }
        }
      },
      new MenuItem
      {
        Title = "اعضا",
        RequiredClaim = "SearchInvolvedMembersReport",
        Children = new List<MenuItem>
        {
          new MenuItem
          {
            Title = "لیست اعضا",
            Page = "/Memberships/Index",
            RequiredClaim = "SearchInvolvedMembersReport"
          },
          new MenuItem
          {
            Title = "گزارشات",
            Children = new List<MenuItem>
            {
              new MenuItem
              {
                Title = "گزارش کارکرد",
                Page = "/Report/SearchInvolvedMembersReport",
                
                RequiredClaim = "SearchInvolvedMembersReport",
              }
            }
          }
        }
      },
      new MenuItem
      {
        Title = "نظارت",
        RequiredClaim = "Supervisor",
        Children = new List<MenuItem>
        {
          new MenuItem
          {
            Title = "گزارشات",
            Page = "/Documents/Index",
            RequiredClaim = "SupervisorReports"
          },
        }
      },
      new MenuItem
      {
        Title = "مدیریت",
        RequiredClaim = "AdminAccess",
        Children = new List<MenuItem>
        {
          new MenuItem
          {
            Title = "مدیریت کاربران",
            Page = "/Admin/Users/Index",
            RequiredClaim = "ManageUsers"
          },
          new MenuItem
          {
            Title = "مدیریت نقش‌ها",
            Page = "/Admin/Roles/Index",
            RequiredClaim = "ManageRoles"
          }
        }
      }
    };
  }
}