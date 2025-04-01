using System;
using System.Web.UI;

namespace asp_web_online_judge
{
    public partial class NavBar : UserControl
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.Cookies["UserInfo"] != null)
                {
                    // 显示欢迎信息，cookie中保存了用户名
                    litUser.Text = $"欢迎，{Request.Cookies["UserInfo"]["Username"]}！";
                }
                else
                {
                    // 如果未登录，可显示登录链接
                    litUser.Text = "<a href='login.aspx'>登录</a>";
                }
            }
        }
    }
}
