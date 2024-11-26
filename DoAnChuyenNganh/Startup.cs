using System;
using Microsoft.AspNet.Identity;
using Microsoft.Owin;
using Microsoft.Owin.Security.Cookies;
using Microsoft.Owin.Security.Google;
using Owin;

namespace DoAnChuyenNganh
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            // Thêm middleware cookie authentication trước
            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
                LoginPath = new PathString("/User/Login")
            });

            app.UseCookieAuthentication(new CookieAuthenticationOptions
            {
                AuthenticationType = DefaultAuthenticationTypes.ApplicationCookie,
                CookieSecure = CookieSecureOption.SameAsRequest,
            });

            app.UseExternalSignInCookie(DefaultAuthenticationTypes.ExternalCookie);

            app.UseGoogleAuthentication(new GoogleOAuth2AuthenticationOptions()
            {
                ClientId = "22684499974-5r1unjs1qkv613la4k42e9jpqfsfv0ih.apps.googleusercontent.com",
                ClientSecret = "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",
                CallbackPath = new PathString("/User/LoginCallback"), // Đảm bảo đúng với callback URI đã đăng ký
                Scope = { "email", "profile" }
            });
        }
    }
}
