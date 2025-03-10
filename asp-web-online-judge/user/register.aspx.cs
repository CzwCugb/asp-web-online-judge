using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class register : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            // 清除之前的错误信息
            lblMessage.Text = "";

            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text;
            string confirmPassword = txtConfirm.Text;

            // 输入验证
            if (string.IsNullOrEmpty(username))
            {
                lblMessage.Text = "用户名不能为空！";
                return;
            }

            if (string.IsNullOrEmpty(password))
            {
                lblMessage.Text = "密码不能为空！";
                return;
            }

            // 确认密码验证
            if (password != confirmPassword)
            {
                lblMessage.Text = "密码和确认密码不一致！";
                return;
            }

            // 这里可以添加其他验证（如密码复杂度、用户名唯一性检查等）

            string sql = $"Select * from User where account = '{username}'";
            DataTable dt = Dbconnection.ExecuteQuery(sql);
            if (dt.Rows.Count != 0)
            {
                lblMessage.Text = "该用户名已被注册";
                return;
            }
            sql = $"Insert into User(account,password) values ('{username}','{password}')";
            Dbconnection.Execute(sql);
            sql = $"Select * from User where account = '{username}'";
            dt = Dbconnection.ExecuteQuery(sql);
            string id = dt.Rows[0]["id"].ToString();

            // 假设注册成功，保存用户信息到Cookie并跳转到登录页面
            try
            {
                HttpCookie userInfoCookie = new HttpCookie("UserInfo");
                userInfoCookie["Userid"] = id;
                userInfoCookie["Username"] = username;
                userInfoCookie["Password"] = password;
                userInfoCookie.Expires = DateTime.Now.AddDays(1);
                Response.Cookies.Add(userInfoCookie);

                // 跳转到登录页面
                Response.Redirect("login.aspx");
            }
            catch (Exception ex)
            {
                lblMessage.Text = "注册时发生错误：" + ex.Message;
            }
        }
    }
}