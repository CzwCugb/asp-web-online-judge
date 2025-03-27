using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;
using online_judge.DAL;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class CategoryDetails : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["id"], out int categoryId))
                {
                    Response.Redirect("categories.aspx");
                    return;
                }
                LoadCategoryData(categoryId);
            }
        }

        private void LoadCategoryData(int categoryId)
        {
            // 加载题单信息
            DataTable dtCategory = Dbconnection.ExecuteQuery(
                $"SELECT category_name FROM categories WHERE category_id = {categoryId}");

            if (dtCategory.Rows.Count == 0)
            {
                Response.Redirect("categories.aspx");
                return;
            }
            h1Title.InnerText = dtCategory.Rows[0]["category_name"].ToString();

            // 加载题目列表
            string sql = $@"
                SELECT 
                    p.id,
                    p.title,
                    p.difficulty,
                    p.time_memory_limit,
                    p.total_accepted
                FROM category_problems cp
                JOIN problem p ON cp.problem_id = p.id
                WHERE cp.category_id = {categoryId}";

            DataTable dtProblems = Dbconnection.ExecuteQuery(sql);

            if (dtProblems.Rows.Count > 0)
            {
                GridView1.DataSource = dtProblems;
                GridView1.DataBind();
                pnlNoProblems.Visible = false;
            }
            else
            {
                pnlNoProblems.Visible = true;
                GridView1.Visible = false;
            }
        }

        public string GetDifficultyClass(string difficulty)
        {
            if (string.IsNullOrEmpty(difficulty)) return "secondary";

            var diff = difficulty.ToLower();
            if (diff == "easy") return "bg-success";
            if (diff == "medium") return "bg-warning";
            return "bg-danger";
        }
    }
}