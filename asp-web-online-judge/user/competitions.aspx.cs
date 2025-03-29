using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using online_judge.DAL;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class competitions : System.Web.UI.Page
    {
        // 每页显示记录数
        private const int PageSize = 10;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
                LoadCompetitions();
        }

        // 搜索按钮事件，将关键字写入查询字符串
        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string searchText = txtSearch.Text.Trim();
            Response.Redirect("competitions.aspx?search=" + Server.UrlEncode(searchText));
        }

        protected void LoadCompetitions()
        {
            // 获取当前页码
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["page"]))
            {
                int.TryParse(Request.QueryString["page"], out pageIndex);
                if (pageIndex <= 0)
                    pageIndex = 1;
            }

            // 获取搜索关键字
            string searchText = Request.QueryString["search"] ?? "";

            // 构造筛选条件
            string whereClause = "";
            if (!string.IsNullOrEmpty(searchText))
            {
                whereClause = " WHERE competition_name LIKE @search ";
            }

            // 查询总记录数
            string countSql = "SELECT COUNT(*) FROM competitions " + whereClause;
            MySqlParameter[] countParams = null;
            if (!string.IsNullOrEmpty(searchText))
            {
                countParams = new MySqlParameter[]
                {
                    new MySqlParameter("@search", "%" + searchText + "%")
                };
            }
            object result = Dbconnection.ExecuteScalar(countSql, countParams);
            int totalRecords = (result != null) ? Convert.ToInt32(result) : 0;
            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);

            // 分页查询数据
            int offset = (pageIndex - 1) * PageSize;
            string sql = @"
                SELECT 
                    competition_id AS CompetitionId,
                    competition_name AS CompetitionName,
                    start_time AS StartTime,
                    end_time AS EndTime
                FROM competitions
                " + whereClause + @"
                ORDER BY start_time DESC
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
            if (dt == null)
                dt = new DataTable();

            // 绑定数据
            rptCompetitions.DataSource = dt;
            rptCompetitions.DataBind();

            pnlNoData.Visible = (dt.Rows.Count == 0);

            // 构造分页链接
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "competitions.aspx?page=" + i;
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

        /// <summary>
        /// 判断当前比赛是否处于比赛时间内
        /// </summary>
        public bool IsCompetitionActive(object startObj, object endObj)
        {
            if (DateTime.TryParse(startObj.ToString(), out DateTime startTime) &&
                DateTime.TryParse(endObj.ToString(), out DateTime endTime))
            {
                DateTime now = DateTime.Now;
                return now >= startTime && now <= endTime;
            }
            return false;
        }
    }
}
