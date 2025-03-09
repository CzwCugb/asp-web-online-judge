using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
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
            string connStr = "server=localhost;port=3306;user=root;password=123456;database=onlinejudge;";

            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                MySqlDataAdapter da = new MySqlDataAdapter(
                    "SELECT id, title, difficulty, time_memory_limit, total_accepted FROM problem", conn);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // 数据绑定（需确保GridView控件存在）
                GridView1.DataSource = dt;
                GridView1.DataBind();
            }
        }
    }
}