using System;
using System.Data;
using MySql.Data.MySqlClient;

namespace asp_web_online_judge
{

    public partial class home : System.Web.UI.Page
    {
        // 后台代码需添加该方法
        public string GetDifficultyClass(string difficulty)
        {
            if (difficulty == "Easy") return "bg-success";
            if (difficulty == "Easy") return "bg-warning";
            if (difficulty == "Easy") return "bg-danger";
            return "bg-secondary";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindTopicData();
            }
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