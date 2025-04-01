using System;
using System.Configuration;
using System.Data;
using System.Web.UI.WebControls;
using MySql.Data.MySqlClient;
using online_judge.DAL;

namespace asp_web_online_judge
{
    public partial class home : System.Web.UI.Page
    {
        // 每页显示记录数，可根据需要调整
        private const int PageSize = 10;

        private string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        // 后台代码需添加该方法，用于显示难度背景
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
                // 绑定题目数据
                BindTopicData();
                // 检查登录状态
                Check_login();
            }
        }

        private void Check_login()
        {
            Literal content = new Literal();
            if (Request.Cookies["UserInfo"] != null)
            {
                content.Text = $"<a href=\"profile.aspx\">{Request.Cookies["UserInfo"]["Username"]}</a>";
                content.Text += "<a href=\"logout.aspx\" style='margin-left:10px;'>退出</a>";
            }
            else
            {
                content.Text = "<a href=\"login.aspx\">登录</a>\r\n                <a href=\"register.aspx\">注册</a>";
            }
            login_register.Controls.Add(content);
        }

        private void BindTopicData()
        {
            // 第一步：获取当前页码
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
            {
                int.TryParse(Request.QueryString["page"], out pageIndex);
                if (pageIndex <= 0) pageIndex = 1;
            }

            // 第二步：查询总记录数 (COUNT(*))
            int totalRecords = 0;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 此处仅示例，可根据实际需要加 WHERE
                string countSql = "SELECT COUNT(*) FROM problem";
                MySqlCommand cmdCount = new MySqlCommand(countSql, conn);
                object obj = cmdCount.ExecuteScalar();
                totalRecords = (obj == null) ? 0 : Convert.ToInt32(obj);
                conn.Close();
            }
            // 计算总页数
            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;

            // 第三步：根据 pageIndex 计算 offset
            int offset = (pageIndex - 1) * PageSize;

            // 第四步：查询本页数据 (LIMIT offset, pagesize)
            DataTable dt = new DataTable();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 这里不加搜索条件，如需搜索可自己扩展
                string sql = "SELECT id, title, difficulty, time_memory_limit, total_accepted " +
                             "FROM problem " +
                             "ORDER BY id " +
                             "LIMIT @offset, @size;";
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@size", PageSize);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();
            }

            // 第五步：绑定数据到 GridView
            GridView1.DataSource = dt;
            GridView1.DataBind();

            // 第六步：生成分页链接并呈现
            // 若在 home.aspx 中放了 <asp:PlaceHolder ID="phPager" runat="server"></asp:PlaceHolder>
            // 则这里就可以往 phPager.Controls.Add(...) 里放分页按钮/链接
            // 下面是演示用的HTML拼接，也可改用 Repeater
            phPager.Controls.Clear(); // 先清空
            if (totalPages > 1)
            {
                // 简单做法：拼出 1..N 页的链接
                for (int i = 1; i <= totalPages; i++)
                {
                    // 构造链接
                    string url = "home.aspx?page=" + i;
                    // 如果你还有搜索或其他query参数，也要拼上
                    // 例如: url += "&search=" + Server.UrlEncode(searchTerm);

                    // 当前页加粗或其他样式
                    if (i == pageIndex)
                    {
                        phPager.Controls.Add(
                            new Literal
                            {
                                Text = $"<span style='padding:6px 12px; margin:3px; background:#007acc; color:#fff;'>{i}</span>"
                            }
                        );
                    }
                    else
                    {
                        phPager.Controls.Add(
                            new Literal
                            {
                                Text = $"<a href='{url}' style='padding:6px 12px; margin:3px; background:#ccc; color:#000; text-decoration:none;'>{i}</a>"
                            }
                        );
                    }
                }
            }
        }
    }
}
