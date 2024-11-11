using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Mvc.Filters;

namespace DoAnChuyenNganh.Filters
{
    public class AdminAuthorization : FilterAttribute, IAuthorizationFilter
    {
        public void OnAuthorization(AuthorizationContext filterContext)
        {
            if(filterContext.HttpContext.User.IsInRole("admin") == false)
            {
                filterContext.Result = new HttpUnauthorizedResult();
            }    
        }
    }
}