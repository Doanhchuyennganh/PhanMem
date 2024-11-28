using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Routing;
using System.Web.Mvc;
namespace DoAnChuyenNganh.Filters
{
    
    public class XacThucFilter : System.Web.Mvc.ActionFilterAttribute
    {
        // Ghi đè phương thức OnActionExecuting
        public override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            // Kiểm tra mã xác thực trong session
            var maXacThucSession = filterContext.HttpContext.Session["MaXacThuc"] as string;
            if (string.IsNullOrEmpty(maXacThucSession))
            {
                // Nếu không có mã xác thực, chuyển hướng đến trang XacThuc
                filterContext.Result = new RedirectToRouteResult(
                    new RouteValueDictionary(new { controller = "User", action = "XacThuc" })
                );
            }

            base.OnActionExecuting(filterContext);
        }
    }

}