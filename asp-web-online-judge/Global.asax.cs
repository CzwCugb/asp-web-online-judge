using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using System.Web.UI;

namespace asp_web_online_judge
{
	public class Global : System.Web.HttpApplication
	{

		protected void Application_Start(object sender, EventArgs e) 		
		{
            ScriptManager.ScriptResourceMapping.AddDefinition("jquery", new ScriptResourceDefinition
            {
                Path = "~/user/javascript/jquery-3.6.0.min.js", // 根据你实际使用的 jQuery 版本修改路径
                DebugPath = "~/user/javascript/jquery-3.6.0.js", // 调试版本的路径
                CdnPath = "https://code.jquery.com/jquery-3.6.0.min.js", // CDN 路径
                CdnDebugPath = "https://code.jquery.com/jquery-3.6.0.js", // CDN 调试路径
                CdnSupportsSecureConnection = true,
                LoadSuccessExpression = "window.jQuery"
            });

        }
		
		protected void Session_Start(object sender, EventArgs e) 
		{

		}

		protected void Application_BeginRequest(object sender, EventArgs e) 
		{

		}

		protected void Application_AuthenticateRequest(object sender, EventArgs e) 
		{

		}

		protected void Application_Error(object sender, EventArgs e) 
		{

		}

		protected void Session_End(object sender, EventArgs e) 
		{

		}

		protected void Application_End(object sender, EventArgs e) 
		{

		}
	}
}