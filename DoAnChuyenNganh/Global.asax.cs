using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace DoAnChuyenNganh
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            RouteConfig.RegisterRoutes(RouteTable.Routes);
        }
        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {
            HttpCookie authCookie = Request.Cookies["auth"];
            HttpCookie roleCookie = Request.Cookies["role"];

            if (authCookie != null && roleCookie != null)
            {
                string username = authCookie.Value;
                string role = roleCookie.Value;

                var identity = new GenericIdentity(username);
                var principal = new GenericPrincipal(identity, new[] { role });

                HttpContext.Current.User = principal;
            }
        }

    }
}
