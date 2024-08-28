using System.Reflection;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Nezam.System.Web.Extensions
{
    public static class PolicyRegistrationHelper
    {
        public static void RegisterPoliciesFromControllersAndPages(this AuthorizationOptions options)
        {
            var policyNames = new HashSet<string>();

            // Register policies from controllers
            options.RegisterPoliciesFromControllers(policyNames);

            // Register policies from Razor Pages
            options.RegisterPoliciesFromPageModels(policyNames);
        }

        public static void RegisterPoliciesFromControllers(this AuthorizationOptions options, HashSet<string> policyNames)
        {
            var controllers = Assembly.GetExecutingAssembly()
                .GetTypes()
                .Where(type => typeof(Controller).IsAssignableFrom(type));

            foreach (var controller in controllers)
            {
                // Register class-level policies
                options.RegisterPoliciesFromAttributes(controller.GetCustomAttributes<AuthorizeAttribute>(), policyNames);

                // Register method-level policies
                var methodAuthorizeAttributes = controller.GetMethods(BindingFlags.Instance | BindingFlags.Public)
                    .SelectMany(method => method.GetCustomAttributes<AuthorizeAttribute>());
                options.RegisterPoliciesFromAttributes(methodAuthorizeAttributes, policyNames);
            }
        }

        public static void RegisterPoliciesFromPageModels(this AuthorizationOptions options, HashSet<string> policyNames)
        {
            var pageModels = Assembly.GetExecutingAssembly()
                .GetTypes()
                .Where(type => typeof(PageModel).IsAssignableFrom(type));

            foreach (var pageModel in pageModels)
            {
                // Register class-level policies
                options.RegisterPoliciesFromAttributes(pageModel.GetCustomAttributes<AuthorizeAttribute>(), policyNames);

                // Register method-level policies
                var methodAuthorizeAttributes = pageModel.GetMethods(BindingFlags.Instance | BindingFlags.Public)
                    .SelectMany(method => method.GetCustomAttributes<AuthorizeAttribute>());
                options.RegisterPoliciesFromAttributes(methodAuthorizeAttributes, policyNames);
            }
        }

        public static void RegisterPoliciesFromAttributes(this AuthorizationOptions options, IEnumerable<AuthorizeAttribute> authorizeAttributes, HashSet<string> policyNames)
        {
            foreach (var authorizeAttribute in authorizeAttributes)
            {
                if (string.IsNullOrEmpty(authorizeAttribute.Policy) || policyNames.Contains(authorizeAttribute.Policy))
                {
                    continue;
                }

                options.AddPolicy(authorizeAttribute.Policy, policy =>
                {
                    policy.RequireAssertion(context =>
                    {
                        return context.User.HasClaim(c => c.Type == authorizeAttribute.Policy);
                    });
                });
                policyNames.Add(authorizeAttribute.Policy);
            }
        }

        public static HashSet<string> ExtractPoliciesFromControllersAndPages()
        {
            var policyNames = new HashSet<string>();

            // Extract policies from controllers
            policyNames.ExtractPoliciesFromControllers();

            // Extract policies from Razor Pages
            policyNames.ExtractPoliciesFromPageModels();

            return policyNames;
        }

        public static void ExtractPoliciesFromControllers(this HashSet<string> policyNames)
        {
            var controllers = Assembly.GetExecutingAssembly()
                .GetTypes()
                .Where(type => typeof(Controller).IsAssignableFrom(type));

            foreach (var controller in controllers)
            {
                // Extract class-level policies
                policyNames.ExtractPoliciesFromAttributes(controller.GetCustomAttributes<AuthorizeAttribute>());

                // Extract method-level policies
                var methodAuthorizeAttributes = controller.GetMethods(BindingFlags.Instance | BindingFlags.Public)
                    .SelectMany(method => method.GetCustomAttributes<AuthorizeAttribute>());
                policyNames.ExtractPoliciesFromAttributes(methodAuthorizeAttributes);
            }
        }

        public static void ExtractPoliciesFromPageModels(this HashSet<string> policyNames)
        {
            var pageModels = Assembly.GetExecutingAssembly()
                .GetTypes()
                .Where(type => typeof(PageModel).IsAssignableFrom(type));

            foreach (var pageModel in pageModels)
            {
                // Extract class-level policies
                policyNames.ExtractPoliciesFromAttributes(pageModel.GetCustomAttributes<AuthorizeAttribute>());

                // Extract method-level policies
                var methodAuthorizeAttributes = pageModel.GetMethods(BindingFlags.Instance | BindingFlags.Public)
                    .SelectMany(method => method.GetCustomAttributes<AuthorizeAttribute>());
                policyNames.ExtractPoliciesFromAttributes(methodAuthorizeAttributes);
            }
        }

        public static void ExtractPoliciesFromAttributes(this HashSet<string> policyNames, IEnumerable<AuthorizeAttribute> authorizeAttributes)
        {
            foreach (var authorizeAttribute in authorizeAttributes)
            {
                if (!string.IsNullOrEmpty(authorizeAttribute.Policy))
                {
                    policyNames.Add(authorizeAttribute.Policy);
                }
            }
        }
    }
}
