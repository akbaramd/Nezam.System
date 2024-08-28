namespace Nezam.System.Web.Attributes;

[AttributeUsage(AttributeTargets.Class | AttributeTargets.Method, AllowMultiple = true)]
public class ClaimRequirementAttribute : Attribute
{
  public string ClaimType { get; }
  public string Title { get; }

  public ClaimRequirementAttribute(string claimType, string title)
  {
    ClaimType = claimType;
    Title = title;
  }
}
