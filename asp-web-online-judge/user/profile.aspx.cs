using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
	public partial class profile : System.Web.UI.Page
	{
		protected void Page_Load(object sender, EventArgs e)
		{
            Session["UserID"] = Request.Cookies["UserInfo"]["Userid"];
            if (Session["UserID"] == null)
            {
                Response.Redirect("login.aspx"); // 未登录则跳转到登录页
                return;
            }

            if (!IsPostBack)
            {
                string UserID = Session["UserID"].ToString();
                LoadUserProfile(UserID); // 加载用户信息
                Check_login();
            }
        }

        private void Check_login()
        {
            Literal content = new Literal();
            if (Request.Cookies["UserInfo"] != null)
            {
                content.Text = $"<a href=\"profile.aspx\">{Request.Cookies["UserInfo"]["Username"]}</a>";
            }
            else
            {
                content.Text = "<a href=\"login.aspx\">登录</a>\r\n                <a href=\"register.aspx\">注册</a>";
            }
            login_register.Controls.Add(content);
        }
        private void LoadUserProfile(string UserID)
        {
            string sql = $"SELECT account, email, registrationdate FROM User WHERE id = {UserID}";
            var reader_row = Dbconnection.ExecuteQuery(sql);
            if(reader_row != null)
            {
                var reader = reader_row.Rows[0];
                lblUsername.Text = reader["account"].ToString();
                if (reader["email"] == null)
                {
                    lblEmail.Text = "尚未填写,请完善";
                }
                else
                {
                    lblEmail.Text = Server.HtmlEncode(reader["email"].ToString());
                }
                lblRegDate.Text = ((DateTime)reader["registrationdate"]).ToString("yyyy-MM-dd");
            }
        }
	}
}