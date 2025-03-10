using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class login : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 检查Cookie中是否有用户信息
                if (Request.Cookies["UserInfo"] != null)
                {
                    string username = Request.Cookies["UserInfo"]["Username"];
                    string password = Request.Cookies["UserInfo"]["Password"];
                    txtUsername.Text = username;
                    txtPassword.Text = password;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text;
            string password = txtPassword.Text;

            string sql = $"Select * from User where account = '{username}' and password = '{password}'";

            DataTable dt = Dbconnection.ExecuteQuery(sql) ;
            // 这里可以添加验证逻辑，比如检查用户名和密码是否匹配
            if (dt.Rows.Count == 1) // 示例验证
            {
                // 登录成功，保存用户信息到Cookie
                HttpCookie userInfoCookie = new HttpCookie("UserInfo");
                userInfoCookie["Userid"] = dt.Rows[0]["id"].ToString();
                userInfoCookie["Username"] = username;
                userInfoCookie["Password"] = password;
                userInfoCookie.Expires = DateTime.Now.AddDays(1); // 设置Cookie过期时间
                Response.Cookies.Add(userInfoCookie);

                // 跳转到主页
                Response.Redirect("/user/home.aspx");
            }
            else
            {
                lblMessage.Text = "用户名或密码错误！";
            }
        }
    }
}