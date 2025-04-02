using System;
using System.Data;
using System.Configuration;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Web;
using System.Collections.Generic;

namespace YourNamespace
{
    public partial class admin : System.Web.UI.Page
    {
        // 从Web.config中获取名为 DefaultConnection 的连接字符串
        private string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;

        // 每页固定大小(可自行设置)
        private const int PageSize = 10;

        // 这几个字段保存当前正在编辑的ID，供编辑/保存时使用
        private int currentProblemId;
        private int currentUserId;
        private int currentCategoryId;
        private int currentCompetitionId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // 绑定其他数据
                BindUsersGrid();
                BindProblemsGrid();
                BindCategoriesGrid();
                BindCompetitionsGrid();

                string viewParam = Request.QueryString["view"];
                if (!string.IsNullOrEmpty(viewParam))
                {
                    switch (viewParam.ToLower())
                    {
                        case "users":
                            MultiView1.SetActiveView(viewUserOverview);
                            break;
                        case "problems":
                            MultiView1.SetActiveView(viewProblemOverview);
                            break;
                        case "categories":
                            MultiView1.SetActiveView(viewCategoryOverview);
                            break;
                        case "competitions":
                            MultiView1.SetActiveView(viewCompetitionOverview);
                            break;
                        case "testcases":
                            BindTestCasesGrid();
                            MultiView1.SetActiveView(viewTestCaseOverview);
                            break;
                        default:
                            MultiView1.SetActiveView(viewUserOverview);
                            break;
                    }
                }
                else
                {
                    MultiView1.SetActiveView(viewUserOverview);
                }
            }
        }


        #region 用户列表分页与绑定
        private void BindUsersGrid()
        {
            // 获取当前页码
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["userPage"]))
            {
                int.TryParse(Request.QueryString["userPage"], out pageIndex);
                if (pageIndex <= 0) pageIndex = 1;
            }

            // 获取搜索关键字（从文本框）
            string searchTerm = txtUserSearch.Text.Trim();

            // 先查询总记录数
            int totalRecords = 0;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string countSql = "SELECT COUNT(*) FROM User";
                if (!string.IsNullOrEmpty(searchTerm))
                    countSql += " WHERE account LIKE @search";

                MySqlCommand cmdCount = new MySqlCommand(countSql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmdCount.Parameters.AddWithValue("@search", "%" + searchTerm + "%");

                object obj = cmdCount.ExecuteScalar();
                totalRecords = (obj == null) ? 0 : Convert.ToInt32(obj);
                conn.Close();
            }

            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;

            // 计算 OFFSET
            int offset = (pageIndex - 1) * PageSize;

            // 查询本页数据
            DataTable dt = new DataTable();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT id, account, email FROM User";
                if (!string.IsNullOrEmpty(searchTerm))
                    sql += " WHERE account LIKE @search";
                sql += " ORDER BY id LIMIT @offset, @pageSize";

                MySqlCommand cmd = new MySqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@pageSize", PageSize);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();
            }

            // 绑定到 GridView
            gvUsers.DataSource = dt;
            gvUsers.DataBind();

            // 生成分页链接 (带上view=users)
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "admin.aspx?view=users&userPage=" + i;
                ListItem li = new ListItem("第" + i + "页", url);
                if (i == pageIndex) li.Selected = true;
                pages.Add(li);
            }
            // 绑定分页 Repeater
            rptUserPagination.DataSource = pages;
            rptUserPagination.DataBind();
        }
        #endregion

        #region 题目列表分页与绑定
        private void BindProblemsGrid()
        {
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["problemPage"]))
            {
                int.TryParse(Request.QueryString["problemPage"], out pageIndex);
                if (pageIndex <= 0) pageIndex = 1;
            }

            string searchTerm = txtProblemSearch.Text.Trim();

            int totalRecords = 0;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string countSql = "SELECT COUNT(*) FROM problem";
                if (!string.IsNullOrEmpty(searchTerm))
                    countSql += " WHERE title LIKE @search OR description LIKE @search";

                MySqlCommand cmdCount = new MySqlCommand(countSql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmdCount.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                object obj = cmdCount.ExecuteScalar();
                totalRecords = (obj == null) ? 0 : Convert.ToInt32(obj);
                conn.Close();
            }

            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;
            int offset = (pageIndex - 1) * PageSize;

            DataTable dt = new DataTable();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT id, title, difficulty FROM problem";
                if (!string.IsNullOrEmpty(searchTerm))
                    sql += " WHERE title LIKE @search OR description LIKE @search";
                sql += " ORDER BY id LIMIT @offset, @pageSize";

                MySqlCommand cmd = new MySqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@pageSize", PageSize);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();
            }

            gvProblems.DataSource = dt;
            gvProblems.DataBind();

            // 生成分页链接 (带上view=problems)
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "admin.aspx?view=problems&problemPage=" + i;
                ListItem li = new ListItem("第" + i + "页", url);
                if (i == pageIndex) li.Selected = true;
                pages.Add(li);
            }

            rptProblemPagination.DataSource = pages;
            rptProblemPagination.DataBind();
        }
        #endregion

        #region 分类(题单)列表分页与绑定
        private void BindCategoriesGrid()
        {
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["categoryPage"]))
            {
                int.TryParse(Request.QueryString["categoryPage"], out pageIndex);
                if (pageIndex <= 0) pageIndex = 1;
            }

            string searchTerm = txtCategorySearch.Text.Trim();

            int totalRecords = 0;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string countSql = "SELECT COUNT(*) FROM categories";
                if (!string.IsNullOrEmpty(searchTerm))
                    countSql += " WHERE category_name LIKE @search";

                MySqlCommand cmdCount = new MySqlCommand(countSql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmdCount.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                object obj = cmdCount.ExecuteScalar();
                totalRecords = (obj == null) ? 0 : Convert.ToInt32(obj);
                conn.Close();
            }

            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;
            int offset = (pageIndex - 1) * PageSize;

            DataTable dt = new DataTable();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT category_id, category_name, created_at FROM categories";
                if (!string.IsNullOrEmpty(searchTerm))
                    sql += " WHERE category_name LIKE @search";
                sql += " ORDER BY category_id LIMIT @offset, @pageSize";

                MySqlCommand cmd = new MySqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@pageSize", PageSize);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();
            }

            gvCategories.DataSource = dt;
            gvCategories.DataBind();

            // 生成分页链接 (带上view=categories)
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "admin.aspx?view=categories&categoryPage=" + i;
                ListItem li = new ListItem("第" + i + "页", url);
                if (i == pageIndex) li.Selected = true;
                pages.Add(li);
            }

            rptCategoryPagination.DataSource = pages;
            rptCategoryPagination.DataBind();
        }
        #endregion

        #region 比赛列表分页与绑定
        private void BindCompetitionsGrid()
        {
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["competitionPage"]))
            {
                int.TryParse(Request.QueryString["competitionPage"], out pageIndex);
                if (pageIndex <= 0) pageIndex = 1;
            }

            string searchTerm = txtCompetitionSearch.Text.Trim();

            int totalRecords = 0;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string countSql = "SELECT COUNT(*) FROM competitions";
                if (!string.IsNullOrEmpty(searchTerm))
                    countSql += " WHERE competition_name LIKE @search";

                MySqlCommand cmdCount = new MySqlCommand(countSql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmdCount.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                object obj = cmdCount.ExecuteScalar();
                totalRecords = (obj == null) ? 0 : Convert.ToInt32(obj);
                conn.Close();
            }

            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;
            int offset = (pageIndex - 1) * PageSize;

            DataTable dt = new DataTable();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT competition_id, competition_name, start_time, end_time, created_at FROM competitions";
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    sql += " WHERE competition_name LIKE @search";
                }
                sql += " ORDER BY competition_id LIMIT @offset, @pageSize";

                MySqlCommand cmd = new MySqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@pageSize", PageSize);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();
            }

            gvCompetitions.DataSource = dt;
            gvCompetitions.DataBind();

            // 生成分页链接 (带上view=competitions)
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "admin.aspx?view=competitions&competitionPage=" + i;
                ListItem li = new ListItem("第" + i + "页", url);
                if (i == pageIndex) li.Selected = true;
                pages.Add(li);
            }

            rptCompetitionPagination.DataSource = pages;
            rptCompetitionPagination.DataBind();
        }
        #endregion

        #region 点击导航链接
        protected void lnkUsers_Click(object sender, EventArgs e)
        {
            Response.Redirect("admin.aspx?view=users&userPage=1");
        }
        protected void lnkProblems_Click(object sender, EventArgs e)
        {
            Response.Redirect("admin.aspx?view=problems&problemPage=1");
        }

        protected void lnkCategories_Click(object sender, EventArgs e)
        {
            Response.Redirect("admin.aspx?view=categories&categoryPage=1");
        }

        protected void lnkCompetitions_Click(object sender, EventArgs e)
        {
            Response.Redirect("admin.aspx?view=competitions&competitionPage=1");
        }
        #endregion

        #region GridView RowCommand (仅用于 编辑/删除)
        protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridView gv = sender as GridView;
            if (gv == null)
                return;

            // 用户Grid
            if (gv.ID == "gvUsers")
            {
                if (e.CommandName == "EditUser")
                {
                    int userId = Convert.ToInt32(e.CommandArgument);
                    LoadUserDetail(userId);

                    // 存储当前URL，用于取消时返回
                    Session["ReturnUrl"] = Request.RawUrl;

                    MultiView1.SetActiveView(viewUserDetail);
                }
                else if (e.CommandName == "DeleteUser")
                {
                    int userId = Convert.ToInt32(e.CommandArgument);
                    DeleteUser(userId);
                    BindUsersGrid();
                }
            }
            // 题目Grid
            else if (gv.ID == "gvProblems")
            {
                if (e.CommandName == "EditProblem")
                {
                    int problemId = Convert.ToInt32(e.CommandArgument);
                    LoadProblemDetail(problemId);

                    // 存储当前URL，用于取消时返回
                    Session["ReturnUrl"] = Request.RawUrl;

                    MultiView1.SetActiveView(viewProblemDetail);
                }
                else if (e.CommandName == "DeleteProblem")
                {
                    int problemId = Convert.ToInt32(e.CommandArgument);
                    DeleteProblem(problemId);
                    BindProblemsGrid();
                }
            }
            // 分类Grid
            else if (gv.ID == "gvCategories")
            {
                if (e.CommandName == "EditCategory")
                {
                    int categoryId = Convert.ToInt32(e.CommandArgument);
                    LoadCategoryDetail(categoryId);

                    // 存储当前URL，用于取消时返回
                    Session["ReturnUrl"] = Request.RawUrl;

                    MultiView1.SetActiveView(viewCategoryDetail);
                }
                else if (e.CommandName == "DeleteCategory")
                {
                    int categoryId = Convert.ToInt32(e.CommandArgument);
                    DeleteCategory(categoryId);
                    BindCategoriesGrid();
                }
            }
            // 比赛Grid
            else if (gv.ID == "gvCompetitions")
            {
                if (e.CommandName == "EditCompetition")
                {
                    int competitionId = Convert.ToInt32(e.CommandArgument);
                    LoadCompetitionDetail(competitionId);

                    // 存储当前URL，用于取消时返回
                    Session["ReturnUrl"] = Request.RawUrl;

                    MultiView1.SetActiveView(viewCompetitionDetail);
                }
                else if (e.CommandName == "DeleteCompetition")
                {
                    int competitionId = Convert.ToInt32(e.CommandArgument);
                    DeleteCompetition(competitionId);
                    BindCompetitionsGrid();
                }
            }
        }
        #endregion

        #region 加载编辑数据
        private void LoadUserDetail(int userId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT * FROM User WHERE id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    currentUserId = userId;
                    lblUserIdValue.Text = userId.ToString();
                    txtAccount.Text = reader["account"].ToString();
                    txtPassword.Text = reader["password"].ToString();
                    txtEmail.Text = reader["email"].ToString();
                }
                conn.Close();
            }
        }

        private void LoadProblemDetail(int problemId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT * FROM problem WHERE id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", problemId);
                conn.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    currentProblemId = problemId;
                    lblProblemIdValue.Text = problemId.ToString();
                    txtTitle.Text = reader["title"].ToString();
                    txtDescription.Text = reader["description"].ToString();
                    txtDifficulty.Text = reader["difficulty"].ToString();
                    txtTimeMemory.Text = reader["time_memory_limit"].ToString();
                    txtTotalAccepted.Text = reader["total_accepted"].ToString();
                    txtTotalAttempted.Text = reader["total_attempted"].ToString();
                    txtAlgorithmTags.Text = reader["algorithm_tags"].ToString();
                }
                conn.Close();
            }
        }

        private void LoadCategoryDetail(int categoryId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 加载题单基本信息
                string query = "SELECT * FROM categories WHERE category_id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", categoryId);
                conn.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    currentCategoryId = categoryId;
                    lblCategoryIdValue.Text = categoryId.ToString();
                    txtCategoryName.Text = reader["category_name"].ToString();
                }
                reader.Close();

                // 加载该题单关联的题目ID列表
                string query2 = "SELECT GROUP_CONCAT(problem_id) AS problems FROM category_problems WHERE category_id=@id";
                MySqlCommand cmd2 = new MySqlCommand(query2, conn);
                cmd2.Parameters.AddWithValue("@id", categoryId);
                object obj = cmd2.ExecuteScalar();
                conn.Close();
                txtCategoryProblems.Text = (obj != null && obj != DBNull.Value) ? obj.ToString() : "";
            }
        }

        private void LoadCompetitionDetail(int competitionId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 加载比赛基本信息
                string query = "SELECT * FROM competitions WHERE competition_id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", competitionId);
                conn.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    currentCompetitionId = competitionId;
                    lblCompetitionIdValue.Text = competitionId.ToString();
                    txtCompetitionName.Text = reader["competition_name"].ToString();
                    txtStartTime.Text = reader["start_time"].ToString();
                    txtEndTime.Text = reader["end_time"].ToString();
                }
                reader.Close();

                // 加载比赛关联的题目ID列表
                string query2 = "SELECT GROUP_CONCAT(problem_id) AS problems FROM competition_problems WHERE competition_id=@id";
                MySqlCommand cmd2 = new MySqlCommand(query2, conn);
                cmd2.Parameters.AddWithValue("@id", competitionId);
                object obj = cmd2.ExecuteScalar();
                conn.Close();
                txtCompetitionProblems.Text = (obj != null && obj != DBNull.Value) ? obj.ToString() : "";
            }
        }
        #endregion

        #region 保存
        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            int uid = Convert.ToInt32(lblUserIdValue.Text);
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "UPDATE User SET account=@account, password=@password, email=@email WHERE id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@account", txtAccount.Text);
                cmd.Parameters.AddWithValue("@password", txtPassword.Text);
                cmd.Parameters.AddWithValue("@email", txtEmail.Text);
                cmd.Parameters.AddWithValue("@id", uid);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindUsersGrid();
            // 编辑完用户后，切回用户管理视图
            MultiView1.SetActiveView(viewUserOverview);
        }

        protected void btnSaveProblem_Click(object sender, EventArgs e)
        {
            int pid = Convert.ToInt32(lblProblemIdValue.Text);
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = @"UPDATE problem 
                                 SET title=@title, description=@description, difficulty=@difficulty,
                                     time_memory_limit=@timeMemory, total_accepted=@totalAccepted, total_attempted=@totalAttempted,
                                     algorithm_tags=@algorithmTags 
                                 WHERE id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@title", txtTitle.Text);
                cmd.Parameters.AddWithValue("@description", txtDescription.Text);
                cmd.Parameters.AddWithValue("@difficulty", txtDifficulty.Text);
                cmd.Parameters.AddWithValue("@timeMemory", txtTimeMemory.Text);
                cmd.Parameters.AddWithValue("@totalAccepted", Convert.ToInt32(txtTotalAccepted.Text));
                cmd.Parameters.AddWithValue("@totalAttempted", Convert.ToInt32(txtTotalAttempted.Text));
                cmd.Parameters.AddWithValue("@algorithmTags", txtAlgorithmTags.Text);
                cmd.Parameters.AddWithValue("@id", pid);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindProblemsGrid();
            // 编辑完题目后，切回题目管理视图
            MultiView1.SetActiveView(viewProblemOverview);
        }

        protected void btnSaveCategory_Click(object sender, EventArgs e)
        {
            int cid = Convert.ToInt32(lblCategoryIdValue.Text);
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 更新题单基本信息
                string query = "UPDATE categories SET category_name=@name WHERE category_id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", txtCategoryName.Text);
                cmd.Parameters.AddWithValue("@id", cid);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            // 更新关联题目
            UpdateCategoryProblems(cid, txtCategoryProblems.Text.Trim());
            BindCategoriesGrid();
            // 编辑完题单后，切回题单管理视图
            MultiView1.SetActiveView(viewCategoryOverview);
        }

        protected void btnSaveCompetition_Click(object sender, EventArgs e)
        {
            int compId = Convert.ToInt32(lblCompetitionIdValue.Text);
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "UPDATE competitions SET competition_name=@name, start_time=@start, end_time=@end WHERE competition_id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", txtCompetitionName.Text);
                cmd.Parameters.AddWithValue("@start", txtStartTime.Text);
                cmd.Parameters.AddWithValue("@end", txtEndTime.Text);
                cmd.Parameters.AddWithValue("@id", compId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            // 更新比赛关联题目
            UpdateCompetitionProblems(compId, txtCompetitionProblems.Text.Trim());
            BindCompetitionsGrid();
            // 编辑完比赛后，切回比赛管理视图
            MultiView1.SetActiveView(viewCompetitionOverview);
        }
        #endregion

        #region 删除
        private void DeleteUser(int userId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "DELETE FROM User WHERE id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", userId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        private void DeleteProblem(int problemId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "DELETE FROM problem WHERE id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", problemId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        private void DeleteCategory(int categoryId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 删除题单前先删除关联关系
                string queryDel = "DELETE FROM category_problems WHERE category_id=@id";
                MySqlCommand cmdDel = new MySqlCommand(queryDel, conn);
                cmdDel.Parameters.AddWithValue("@id", categoryId);
                conn.Open();
                cmdDel.ExecuteNonQuery();
                conn.Close();

                string query = "DELETE FROM categories WHERE category_id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", categoryId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }

        private void DeleteCompetition(int competitionId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 删除比赛前先删除关联关系
                string queryDel = "DELETE FROM competition_problems WHERE competition_id=@id";
                MySqlCommand cmdDel = new MySqlCommand(queryDel, conn);
                cmdDel.Parameters.AddWithValue("@id", competitionId);
                conn.Open();
                cmdDel.ExecuteNonQuery();
                conn.Close();

                string query = "DELETE FROM competitions WHERE competition_id=@id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", competitionId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
        #endregion

        #region 添加新记录
        protected void btnAddUser_Click(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "INSERT INTO User (account, password, email) VALUES (@account, @password, @email)";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@account", "未编辑");
                cmd.Parameters.AddWithValue("@password", "未编辑");
                cmd.Parameters.AddWithValue("@email", "未编辑");
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindUsersGrid();
        }

        protected void btnAddProblem_Click(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = @"INSERT INTO problem 
                                 (title, description, difficulty, time_memory_limit, total_accepted, total_attempted, algorithm_tags)
                                 VALUES (@title, @description, @difficulty, @timeMemory, 0, 0, @algorithmTags)";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@title", "未编辑");
                cmd.Parameters.AddWithValue("@description", "未编辑");
                cmd.Parameters.AddWithValue("@difficulty", "Easy");
                cmd.Parameters.AddWithValue("@timeMemory", "未编辑");
                cmd.Parameters.AddWithValue("@algorithmTags", "未编辑");
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindProblemsGrid();
        }

        protected void btnAddCategory_Click(object sender, EventArgs e)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "INSERT INTO categories (category_name) VALUES (@name)";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@name", "未编辑");
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindCategoriesGrid();
        }

        // 如果 competition_id 不是自动递增，可以手动获取下一个ID
        private int GetNextCompetitionId()
        {
            int nextId = 1;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT IFNULL(MAX(competition_id), 0) FROM competitions";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                conn.Open();
                object obj = cmd.ExecuteScalar();
                if (obj != null && obj != DBNull.Value)
                    nextId = Convert.ToInt32(obj) + 1;
                conn.Close();
            }
            return nextId;
        }

        protected void btnAddCompetition_Click(object sender, EventArgs e)
        {
            int newId = GetNextCompetitionId();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "INSERT INTO competitions (competition_id, competition_name, start_time, end_time) " +
                               "VALUES (@id, @name, @start, @end)";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", newId);
                cmd.Parameters.AddWithValue("@name", "未编辑");
                cmd.Parameters.AddWithValue("@start", DateTime.Now);
                cmd.Parameters.AddWithValue("@end", DateTime.Now);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            BindCompetitionsGrid();
        }
        #endregion

        #region 取消编辑
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // 如果Session里有“返回URL”，则跳回
            if (Session["ReturnUrl"] != null)
            {
                string returnUrl = Session["ReturnUrl"].ToString();
                // 用完后清掉，避免下次操作误用
                Session.Remove("ReturnUrl");
                Response.Redirect(returnUrl);
            }
            else
            {
                // 若没存URL，则默认回到用户管理视图(或你想要的其他视图)
                MultiView1.SetActiveView(viewUserOverview);
            }
        }
        #endregion

        #region 搜索按钮事件
        protected void btnUserSearch_Click(object sender, EventArgs e)
        {
            BindUsersGrid();
        }
        protected void btnProblemSearch_Click(object sender, EventArgs e)
        {
            BindProblemsGrid();
        }
        protected void btnCategorySearch_Click(object sender, EventArgs e)
        {
            BindCategoriesGrid();
        }
        protected void btnCompetitionSearch_Click(object sender, EventArgs e)
        {
            BindCompetitionsGrid();
        }
        #endregion

        #region 返回首页
        protected void btnHome_Click(object sender, EventArgs e)
        {
            // 如果有登录Cookies之类，退出时可删除
            if (Request.Cookies["UserInfo"] != null)
            {
                HttpCookie cookie = new HttpCookie("UserInfo");
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }
            Response.Redirect("/user/home.aspx");
        }
        #endregion

        #region 更新题单/比赛的关联题目
        private void UpdateCategoryProblems(int categoryId, string problems)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 先删掉旧关联
                string delQuery = "DELETE FROM category_problems WHERE category_id=@cid";
                MySqlCommand delCmd = new MySqlCommand(delQuery, conn);
                delCmd.Parameters.AddWithValue("@cid", categoryId);
                delCmd.ExecuteNonQuery();

                // 插入新关联
                if (!string.IsNullOrEmpty(problems))
                {
                    string[] arr = problems.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string s in arr)
                    {
                        int pid;
                        if (int.TryParse(s.Trim(), out pid))
                        {
                            string insQuery = "INSERT INTO category_problems (category_id, problem_id) VALUES (@cid, @pid)";
                            MySqlCommand insCmd = new MySqlCommand(insQuery, conn);
                            insCmd.Parameters.AddWithValue("@cid", categoryId);
                            insCmd.Parameters.AddWithValue("@pid", pid);
                            insCmd.ExecuteNonQuery();
                        }
                    }
                }
                conn.Close();
            }
        }

        private void UpdateCompetitionProblems(int competitionId, string problems)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 删除旧关联
                string delQuery = "DELETE FROM competition_problems WHERE competition_id=@cid";
                MySqlCommand cmdDel = new MySqlCommand(delQuery, conn);
                cmdDel.Parameters.AddWithValue("@cid", competitionId);
                cmdDel.ExecuteNonQuery();

                // 插入新关联
                if (!string.IsNullOrEmpty(problems))
                {
                    string[] arr = problems.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                    foreach (string s in arr)
                    {
                        int pid;
                        if (int.TryParse(s.Trim(), out pid))
                        {
                            string insQuery = "INSERT INTO competition_problems (competition_id, problem_id) VALUES (@cid, @pid)";
                            MySqlCommand insCmd = new MySqlCommand(insQuery, conn);
                            insCmd.Parameters.AddWithValue("@cid", competitionId);
                            insCmd.Parameters.AddWithValue("@pid", pid);
                            insCmd.ExecuteNonQuery();
                        }
                    }
                }
                conn.Close();
            }
        }
        #endregion

        #region 测试用例列表分页与绑定
        private void BindTestCasesGrid()
        {
            int pageIndex = 1;
            if (!string.IsNullOrEmpty(Request.QueryString["testCasePage"]))
            {
                int.TryParse(Request.QueryString["testCasePage"], out pageIndex);
                if (pageIndex <= 0) pageIndex = 1;
            }

            string searchTerm = txtTestCaseSearch.Text.Trim();

            int totalRecords = 0;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string countSql = "SELECT COUNT(*) FROM test_case";
                if (!string.IsNullOrEmpty(searchTerm))
                    countSql += " WHERE input_data LIKE @search OR output_data LIKE @search";
                MySqlCommand cmdCount = new MySqlCommand(countSql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmdCount.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                object obj = cmdCount.ExecuteScalar();
                totalRecords = (obj == null) ? 0 : Convert.ToInt32(obj);
                conn.Close();
            }

            int totalPages = (int)Math.Ceiling((double)totalRecords / PageSize);
            if (totalPages < 1) totalPages = 1;
            if (pageIndex > totalPages) pageIndex = totalPages;
            int offset = (pageIndex - 1) * PageSize;

            DataTable dt = new DataTable();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string sql = "SELECT test_case_id, problem_id, input_data, output_data FROM test_case";
                if (!string.IsNullOrEmpty(searchTerm))
                    sql += " WHERE input_data LIKE @search OR output_data LIKE @search";
                sql += " ORDER BY test_case_id LIMIT @offset, @pageSize";

                MySqlCommand cmd = new MySqlCommand(sql, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    cmd.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                cmd.Parameters.AddWithValue("@offset", offset);
                cmd.Parameters.AddWithValue("@pageSize", PageSize);

                MySqlDataAdapter da = new MySqlDataAdapter(cmd);
                da.Fill(dt);
                conn.Close();
            }

            gvTestCases.DataSource = dt;
            gvTestCases.DataBind();

            // 生成分页链接（带上 view=testcases 参数）
            List<ListItem> pages = new List<ListItem>();
            for (int i = 1; i <= totalPages; i++)
            {
                string url = "admin.aspx?view=testcases&testCasePage=" + i;
                ListItem li = new ListItem("第" + i + "页", url);
                if (i == pageIndex)
                    li.Selected = true;
                pages.Add(li);
            }
            rptTestCasePagination.DataSource = pages;
            rptTestCasePagination.DataBind();
        }
        #endregion

        #region 点击导航链接
        protected void lnkTestCases_Click(object sender, EventArgs e)
        {
            BindTestCasesGrid(); // 刷新测试用例数据并绑定分页
            MultiView1.SetActiveView(viewTestCaseOverview);
        }
        #endregion


        #region 加载测试用例编辑数据
        private void LoadTestCaseDetail(int testCaseId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT * FROM test_case WHERE test_case_id = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", testCaseId);
                conn.Open();
                MySqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblTestCaseIdValue.Text = testCaseId.ToString();
                    txtTestCaseProblemId.Text = reader["problem_id"].ToString();
                    txtTestCaseInputData.Text = reader["input_data"].ToString();
                    txtTestCaseOutputData.Text = reader["output_data"].ToString();
                }
                conn.Close();
            }
            // 同时加载映射表中的 in_problem_case_id（如果存在）
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string queryMapping = "SELECT in_problem_case_id FROM test_case_mapping WHERE test_case_id = @id";
                MySqlCommand cmdMapping = new MySqlCommand(queryMapping, conn);
                cmdMapping.Parameters.AddWithValue("@id", testCaseId);
                conn.Open();
                object obj = cmdMapping.ExecuteScalar();
                if (obj != null && obj != DBNull.Value)
                    txtInProblemCaseId.Text = obj.ToString();
                else
                    txtInProblemCaseId.Text = "";
                conn.Close();
            }
        }
        #endregion

        #region 保存测试用例
        protected void btnSaveTestCase_Click(object sender, EventArgs e)
        {
            int testCaseId = Convert.ToInt32(lblTestCaseIdValue.Text);
            int problemId = Convert.ToInt32(txtTestCaseProblemId.Text.Trim());
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "UPDATE test_case SET problem_id = @problemId, input_data = @input, output_data = @output WHERE test_case_id = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@problemId", problemId);
                cmd.Parameters.AddWithValue("@input", txtTestCaseInputData.Text);
                cmd.Parameters.AddWithValue("@output", txtTestCaseOutputData.Text);
                cmd.Parameters.AddWithValue("@id", testCaseId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
            // 更新映射表：先删除原有映射，再插入新的 in_problem_case_id（如果填写了）
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                string delQuery = "DELETE FROM test_case_mapping WHERE test_case_id = @id";
                MySqlCommand delCmd = new MySqlCommand(delQuery, conn);
                delCmd.Parameters.AddWithValue("@id", testCaseId);
                delCmd.ExecuteNonQuery();

                if (!string.IsNullOrEmpty(txtInProblemCaseId.Text.Trim()))
                {
                    int inProblemCaseId;
                    if (int.TryParse(txtInProblemCaseId.Text.Trim(), out inProblemCaseId))
                    {
                        string insQuery = "INSERT INTO test_case_mapping (problem_id, in_problem_case_id, test_case_id) VALUES (@problemId, @inProblemCaseId, @id)";
                        MySqlCommand insCmd = new MySqlCommand(insQuery, conn);
                        insCmd.Parameters.AddWithValue("@problemId", problemId);
                        insCmd.Parameters.AddWithValue("@inProblemCaseId", inProblemCaseId);
                        insCmd.Parameters.AddWithValue("@id", testCaseId);
                        insCmd.ExecuteNonQuery();
                    }
                }
                conn.Close();
            }
            BindTestCasesGrid();
            MultiView1.SetActiveView(viewTestCaseOverview);
        }
        #endregion

        #region 添加新测试用例
        protected void btnAddTestCase_Click(object sender, EventArgs e)
        {
            int problemId = Convert.ToInt32(txtTestCaseProblemId.Text.Trim());
            int newTestCaseId = 0;

            // 先插入 test_case 表，利用自增主键获得新记录的 ID
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "INSERT INTO test_case (problem_id, input_data, output_data) VALUES (@problemId, @input, @output)";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@problemId", problemId);
                cmd.Parameters.AddWithValue("@input", txtTestCaseInputData.Text);
                cmd.Parameters.AddWithValue("@output", txtTestCaseOutputData.Text);
                conn.Open();
                cmd.ExecuteNonQuery();
                newTestCaseId = Convert.ToInt32(cmd.LastInsertedId);
                conn.Close();
            }

            // 如果用户填写了题内测试用例编号，则进行映射记录的插入
            if (!string.IsNullOrEmpty(txtInProblemCaseId.Text.Trim()))
            {
                int inProblemCaseId;
                if (int.TryParse(txtInProblemCaseId.Text.Trim(), out inProblemCaseId))
                {
                    // 检查该题目下是否已有相同编号的测试用例映射（避免重复）
                    bool exists = false;
                    using (MySqlConnection conn = new MySqlConnection(connStr))
                    {
                        string checkQuery = "SELECT COUNT(*) FROM test_case_mapping WHERE problem_id = @problemId AND in_problem_case_id = @inProblemCaseId";
                        MySqlCommand cmd = new MySqlCommand(checkQuery, conn);
                        cmd.Parameters.AddWithValue("@problemId", problemId);
                        cmd.Parameters.AddWithValue("@inProblemCaseId", inProblemCaseId);
                        conn.Open();
                        object countObj = cmd.ExecuteScalar();
                        int count = (countObj == null) ? 0 : Convert.ToInt32(countObj);
                        exists = (count > 0);
                        conn.Close();
                    }
                    if (exists)
                    {
                        // 已存在则提示错误
                        Response.Write("<script>alert('该题目已存在编号为 " + inProblemCaseId + " 的测试用例');</script>");
                    }
                    else
                    {
                        // 没有重复则插入映射记录
                        using (MySqlConnection conn = new MySqlConnection(connStr))
                        {
                            conn.Open();
                            string insQuery = "INSERT INTO test_case_mapping (problem_id, in_problem_case_id, test_case_id) VALUES (@problemId, @inProblemCaseId, @testCaseId)";
                            MySqlCommand insCmd = new MySqlCommand(insQuery, conn);
                            insCmd.Parameters.AddWithValue("@problemId", problemId);
                            insCmd.Parameters.AddWithValue("@inProblemCaseId", inProblemCaseId);
                            insCmd.Parameters.AddWithValue("@testCaseId", newTestCaseId);
                            insCmd.ExecuteNonQuery();
                            conn.Close();
                        }
                    }
                }
            }

            BindTestCasesGrid();
            MultiView1.SetActiveView(viewTestCaseOverview);
        }
        #endregion

        #region 删除测试用例
        private void DeleteTestCase(int testCaseId)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 先删除映射关系（如果有）
                string delMapping = "DELETE FROM test_case_mapping WHERE test_case_id = @id";
                MySqlCommand cmdMapping = new MySqlCommand(delMapping, conn);
                cmdMapping.Parameters.AddWithValue("@id", testCaseId);
                conn.Open();
                cmdMapping.ExecuteNonQuery();
                conn.Close();

                // 删除测试用例
                string query = "DELETE FROM test_case WHERE test_case_id = @id";
                MySqlCommand cmd = new MySqlCommand(query, conn);
                cmd.Parameters.AddWithValue("@id", testCaseId);
                conn.Open();
                cmd.ExecuteNonQuery();
                conn.Close();
            }
        }
        #endregion

        #region 测试用例搜索按钮事件
        protected void btnTestCaseSearch_Click(object sender, EventArgs e)
        {
            BindTestCasesGrid();
        }
        #endregion

    }
}
