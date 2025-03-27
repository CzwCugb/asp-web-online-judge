using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using online_judge.DAL;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class categories : System.Web.UI.Page
    {
        // 每页显示记录数，可根据需要调整
        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadCategories();
        }

        // 搜索按钮点击事件，将搜索关键字放入查询字符串中
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            Response.Redirect("categories.aspx?search=" + Server.UrlEncode(searchText));
        }

        protected void LoadCategories()
        {
            // 获取当前页码，默认第1页
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
            {
                int.TryParse(Request.QueryString["page"], out pageIndex);
                if (pageIndex <= 0)
                    pageIndex = 1;
            }

            // 获取搜索关键字（如果有）
            string searchText = Request.QueryString["search"] ?? "";

            // 构建筛选条件
            string whereClause = "";
            if (!string.IsNullOrEmpty(searchText))
            {
                whereClause = " WHERE c.category_name LIKE @search ";
            }

            // 查询总记录数（分页计算）
            string countSql = "SELECT COUNT(*) FROM categories c " + whereClause;
            MySqlParameter[] countParams = null;
            if (!string.IsNullOrEmpty(searchText))
            {
                countParams = new MySqlParameter[]
                {
                    new MySqlParameter("@search", "%" + searchText + "%")
                };
            }
            int totalRecords = Convert.ToInt32(Dbconnection.ExecuteScalar(countSql, countParams));
            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);

            // 分页查询数据（MySQL使用 LIMIT offset, count）
            int offset = (pageIndex - 1) * PageSize;
            string sql = @"
                SELECT 
                    c.category_id AS CategoryId,
                    c.category_name AS CategoryName,
                    COUNT(cp.problem_id) AS ProblemCount
                FROM categories c
                LEFT JOIN category_problems cp ON c.category_id = cp.category_id
                " + whereClause + @"
                GROUP BY c.category_id
                ORDER BY c.category_name
                LIMIT @offset, @pageSize;
            ";

            List<MySqlParameter> sqlParams = new List<MySqlParameter>();
            if (!string.IsNullOrEmpty(searchText))
            {
                sqlParams.Add(new MySqlParameter("@search", "%" + searchText + "%"));
            }
            sqlParams.Add(new MySqlParameter("@offset", offset));
            sqlParams.Add(new MySqlParameter("@pageSize", PageSize));

            DataTable dt = Dbconnection.ExecuteQuery(sql, sqlParams.ToArray());
            rptCategories.DataSource = dt;
            rptCategories.DataBind();

            pnlNoData.Visible = (dt.Rows.Count == 0);

            // 构造分页链接
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "categories.aspx?page=" + i;
                if (!string.IsNullOrEmpty(searchText))
                {
                    url += "&search=" + Server.UrlEncode(searchText);
                }
                ListItem item = new ListItem(i.ToString(), url);
                if (i == pageIndex)
                    item.Selected = true;
                pages.Add(item);
            }
            rptPagination.DataSource = pages;
            rptPagination.DataBind();
        }
    }
}
