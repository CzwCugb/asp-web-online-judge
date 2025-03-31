using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using online_judge.DAL;

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
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();

            // 此处建议使用参数化查询防止SQL注入，但这里保留原有逻辑示例
            string sql = $"SELECT * FROM User WHERE account = '{username}' AND password = '{password}'";
            DataTable dt = Dbconnection.ExecuteQuery(sql);

            if (dt.Rows.Count == 1) // 登录成功
            {
                // 保存用户信息到Cookie
                HttpCookie userInfoCookie = new HttpCookie("UserInfo");
                userInfoCookie["Userid"] = dt.Rows[0]["id"].ToString();
                userInfoCookie["Username"] = username;
                userInfoCookie["Password"] = password;
                userInfoCookie.Expires = DateTime.Now.AddDays(1); // 设置Cookie过期时间
                Response.Cookies.Add(userInfoCookie);

                // 如果账号为admin，则跳转到管理员界面，否则跳转到普通用户主页
                if (username.Equals("admin", StringComparison.OrdinalIgnoreCase))
                {
                    Response.Redirect("/admin/admin.aspx");
                }
                else
                {
                    Response.Redirect("/user/home.aspx");
                }
            }
            else
            {
                lblMessage.Text = "用户名或密码错误！";
            }
        }

    }
}