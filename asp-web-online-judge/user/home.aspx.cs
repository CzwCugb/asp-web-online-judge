using System;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;

namespace asp_web_online_judge
{

    public partial class home : System.Web.UI.Page
    {
        // 后台代码需添加该方法
        public string GetDifficultyClass(string difficulty)
        {
            if (difficulty == "Easy") return "bg-success";
            if (difficulty == "Medium") return "bg-warning";
            if (difficulty == "Hard") return "bg-danger";
            return "bg-secondary";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTopicData();
                Check_login();
            }
        }

        private void Check_login() {
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

        private void BindTopicData()
        {
            string sql = "SELECT id, title, difficulty, time_memory_limit, total_accepted FROM problem";
            DataTable dt = Dbconnection.ExecuteQuery(sql);
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }
    }
}