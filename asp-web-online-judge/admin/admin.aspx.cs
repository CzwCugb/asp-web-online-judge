using System;
using System.Data;
using System.Configuration;
using MySql.Data.MySqlClient;
using System.Web.UI.WebControls;
using System.Web;

namespace YourNamespace
{
    public partial class admin : System.Web.UI.Page
    {
        // 从Web.config中获取名为 DefaultConnection 的连接字符串
        private string connStr = ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
        private int currentProblemId;
        private int currentUserId;
        private int currentCategoryId;
        private int currentCompetitionId;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindUsersGrid();
                BindProblemsGrid();
                BindCategoriesGrid();
                BindCompetitionsGrid();
                MultiView1.SetActiveView(viewUserOverview);
            }
        }

        // 辅助方法：截断超过指定长度的文本
        protected string Truncate(string input, int maxLength)
        {
            if (string.IsNullOrEmpty(input))
                return input;
            return input.Length > maxLength ? input.Substring(0, maxLength) + "..." : input;
        }

        #region 数据绑定（用户、题目）
        private void BindUsersGrid()
        {
            string searchTerm = txtUserSearch.Text.Trim();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT id, account, email FROM User";
                if (!string.IsNullOrEmpty(searchTerm))
                    query += " WHERE account LIKE @search";
                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    da.SelectCommand.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
        }

        private void BindProblemsGrid()
        {
            string searchTerm = txtProblemSearch.Text.Trim();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT id, title, description, difficulty FROM problem";
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    int idValue;
                    if (int.TryParse(searchTerm, out idValue))
                        query += " WHERE id=@id OR title LIKE @search OR description LIKE @search";
                    else
                        query += " WHERE title LIKE @search OR description LIKE @search";
                }
                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                {
                    da.SelectCommand.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                    int idValue;
                    if (int.TryParse(searchTerm, out idValue))
                        da.SelectCommand.Parameters.AddWithValue("@id", idValue);
                }
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvProblems.DataSource = dt;
                gvProblems.DataBind();
            }
        }
        #endregion

        #region 绑定题单和比赛GridView
        // 绑定题单（分类）数据
        private void BindCategoriesGrid()
        {
            string searchTerm = txtCategorySearch.Text.Trim();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT category_id, category_name, created_at FROM categories";
                if (!string.IsNullOrEmpty(searchTerm))
                    query += " WHERE category_name LIKE @search";
                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    da.SelectCommand.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCategories.DataSource = dt;
                gvCategories.DataBind();
            }
        }

        // 绑定比赛数据
        private void BindCompetitionsGrid()
        {
            string searchTerm = txtCompetitionSearch.Text.Trim();
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                string query = "SELECT competition_id, competition_name, start_time, end_time, created_at FROM competitions";
                if (!string.IsNullOrEmpty(searchTerm))
                    query += " WHERE competition_name LIKE @search";
                MySqlDataAdapter da = new MySqlDataAdapter(query, conn);
                if (!string.IsNullOrEmpty(searchTerm))
                    da.SelectCommand.Parameters.AddWithValue("@search", "%" + searchTerm + "%");
                DataTable dt = new DataTable();
                da.Fill(dt);
                gvCompetitions.DataSource = dt;
                gvCompetitions.DataBind();
            }
        }
        #endregion

        #region 导航栏点击
        protected void lnkUsers_Click(object sender, EventArgs e)
        {
            MultiView1.SetActiveView(viewUserOverview);
        }
        protected void lnkProblems_Click(object sender, EventArgs e)
        {
            MultiView1.SetActiveView(viewProblemOverview);
        }
        protected void lnkCategories_Click(object sender, EventArgs e)
        {
            MultiView1.SetActiveView(viewCategoryOverview);
        }
        protected void lnkCompetitions_Click(object sender, EventArgs e)
        {
            MultiView1.SetActiveView(viewCompetitionOverview);
        }
        #endregion

        #region 分页处理——统一在 RowCommand 中
        protected void gv_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            GridView gv = sender as GridView;
            if (gv == null)
                return;
            if (e.CommandName == "Page")
            {
                int newIndex;
                if (int.TryParse(e.CommandArgument.ToString(), out newIndex))
                {
                    if (newIndex < 0)
                        newIndex = 0;
                    if (gv.ID == "gvUsers")
                    {
                        if (newIndex >= gvUsers.PageCount)
                            newIndex = gvUsers.PageCount - 1;
                        gvUsers.PageIndex = newIndex;
                        BindUsersGrid();
                    }
                    else if (gv.ID == "gvProblems")
                    {
                        if (newIndex >= gvProblems.PageCount)
                            newIndex = gvProblems.PageCount - 1;
                        gvProblems.PageIndex = newIndex;
                        BindProblemsGrid();
                    }
                    else if (gv.ID == "gvCategories")
                    {
                        if (newIndex >= gvCategories.PageCount)
                            newIndex = gvCategories.PageCount - 1;
                        gvCategories.PageIndex = newIndex;
                        BindCategoriesGrid();
                    }
                    else if (gv.ID == "gvCompetitions")
                    {
                        if (newIndex >= gvCompetitions.PageCount)
                            newIndex = gvCompetitions.PageCount - 1;
                        gvCompetitions.PageIndex = newIndex;
                        BindCompetitionsGrid();
                    }
                }
            }
            else
            {
                // 根据GridView的ID处理编辑和删除命令
                if (gv.ID == "gvUsers")
                {
                    if (e.CommandName == "EditUser")
                    {
                        int userId = Convert.ToInt32(e.CommandArgument);
                        LoadUserDetail(userId);
                        MultiView1.SetActiveView(viewUserDetail);
                    }
                    else if (e.CommandName == "DeleteUser")
                    {
                        int userId = Convert.ToInt32(e.CommandArgument);
                        DeleteUser(userId);
                        BindUsersGrid();
                    }
                }
                else if (gv.ID == "gvProblems")
                {
                    if (e.CommandName == "EditProblem")
                    {
                        int problemId = Convert.ToInt32(e.CommandArgument);
                        LoadProblemDetail(problemId);
                        MultiView1.SetActiveView(viewProblemDetail);
                    }
                    else if (e.CommandName == "DeleteProblem")
                    {
                        int problemId = Convert.ToInt32(e.CommandArgument);
                        DeleteProblem(problemId);
                        BindProblemsGrid();
                    }
                }
                else if (gv.ID == "gvCategories")
                {
                    if (e.CommandName == "EditCategory")
                    {
                        int categoryId = Convert.ToInt32(e.CommandArgument);
                        LoadCategoryDetail(categoryId);
                        MultiView1.SetActiveView(viewCategoryDetail);
                    }
                    else if (e.CommandName == "DeleteCategory")
                    {
                        int categoryId = Convert.ToInt32(e.CommandArgument);
                        DeleteCategory(categoryId);
                        BindCategoriesGrid();
                    }
                }
                else if (gv.ID == "gvCompetitions")
                {
                    if (e.CommandName == "EditCompetition")
                    {
                        int competitionId = Convert.ToInt32(e.CommandArgument);
                        LoadCompetitionDetail(competitionId);
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
        }
        #endregion

        #region 自定义分页按钮生成（RowCreated事件）
        protected void gvUsers_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Pager)
            {
                GridView gv = (GridView)sender;
                // 上一页按钮
                LinkButton lnkPrev = (LinkButton)e.Row.FindControl("lnkPrev");
                if (lnkPrev != null)
                {
                    int prevIndex = gv.PageIndex - 1;
                    if (prevIndex < 0)
                        lnkPrev.Visible = false;
                    else
                    {
                        lnkPrev.Visible = true;
                        lnkPrev.CommandArgument = prevIndex.ToString();
                    }
                }
                // 下一页按钮
                LinkButton lnkNext = (LinkButton)e.Row.FindControl("lnkNext");
                if (lnkNext != null)
                {
                    int nextIndex = gv.PageIndex + 1;
                    if (nextIndex >= gv.PageCount)
                        lnkNext.Visible = false;
                    else
                    {
                        lnkNext.Visible = true;
                        lnkNext.CommandArgument = nextIndex.ToString();
                    }
                }
                // 生成中间数字按钮
                PlaceHolder ph = (PlaceHolder)e.Row.FindControl("phNumeric");
                if (ph != null)
                {
                    ph.Controls.Clear();
                    int pageCount = gv.PageCount;
                    if (pageCount <= 1)
                        return;
                    for (int i = 0; i < pageCount; i++)
                    {
                        LinkButton lb = new LinkButton();
                        lb.Text = (i + 1).ToString(); // 显示页码从1开始
                        lb.CommandName = "Page";
                        lb.CommandArgument = i.ToString(); // 页码索引（0表示第一页）
                        lb.CssClass = "pager-btn";
                        if (i == gv.PageIndex)
                        {
                            lb.Enabled = false;
                            lb.CssClass += " current-page";
                        }
                        ph.Controls.Add(lb);
                    }
                }
            }
        }

        protected void gvProblems_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Pager)
            {
                GridView gv = (GridView)sender;
                LinkButton lnkPrev = (LinkButton)e.Row.FindControl("lnkPrev");
                if (lnkPrev != null)
                {
                    int prevIndex = gv.PageIndex - 1;
                    if (prevIndex < 0)
                        lnkPrev.Visible = false;
                    else
                    {
                        lnkPrev.Visible = true;
                        lnkPrev.CommandArgument = prevIndex.ToString();
                    }
                }
                LinkButton lnkNext = (LinkButton)e.Row.FindControl("lnkNext");
                if (lnkNext != null)
                {
                    int nextIndex = gv.PageIndex + 1;
                    if (nextIndex >= gv.PageCount)
                        lnkNext.Visible = false;
                    else
                    {
                        lnkNext.Visible = true;
                        lnkNext.CommandArgument = nextIndex.ToString();
                    }
                }
                PlaceHolder ph = (PlaceHolder)e.Row.FindControl("phNumeric");
                if (ph != null)
                {
                    ph.Controls.Clear();
                    int pageCount = gv.PageCount;
                    if (pageCount <= 1)
                        return;
                    for (int i = 0; i < pageCount; i++)
                    {
                        LinkButton lb = new LinkButton();
                        lb.Text = (i + 1).ToString();
                        lb.CommandName = "Page";
                        lb.CommandArgument = i.ToString();
                        lb.CssClass = "pager-btn";
                        if (i == gv.PageIndex)
                        {
                            lb.Enabled = false;
                            lb.CssClass += " current-page";
                        }
                        ph.Controls.Add(lb);
                    }
                }
            }
        }

        protected void gvCategories_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Pager)
            {
                GridView gv = (GridView)sender;
                LinkButton lnkPrev = (LinkButton)e.Row.FindControl("lnkPrev");
                if (lnkPrev != null)
                {
                    int prevIndex = gv.PageIndex - 1;
                    if (prevIndex < 0)
                        lnkPrev.Visible = false;
                    else
                    {
                        lnkPrev.Visible = true;
                        lnkPrev.CommandArgument = prevIndex.ToString();
                    }
                }
                LinkButton lnkNext = (LinkButton)e.Row.FindControl("lnkNext");
                if (lnkNext != null)
                {
                    int nextIndex = gv.PageIndex + 1;
                    if (nextIndex >= gv.PageCount)
                        lnkNext.Visible = false;
                    else
                    {
                        lnkNext.Visible = true;
                        lnkNext.CommandArgument = nextIndex.ToString();
                    }
                }
                PlaceHolder ph = (PlaceHolder)e.Row.FindControl("phNumeric");
                if (ph != null)
                {
                    ph.Controls.Clear();
                    int pageCount = gv.PageCount;
                    if (pageCount <= 1)
                        return;
                    for (int i = 0; i < pageCount; i++)
                    {
                        LinkButton lb = new LinkButton();
                        lb.Text = (i + 1).ToString();
                        lb.CommandName = "Page";
                        lb.CommandArgument = i.ToString();
                        lb.CssClass = "pager-btn";
                        if (i == gv.PageIndex)
                        {
                            lb.Enabled = false;
                            lb.CssClass += " current-page";
                        }
                        ph.Controls.Add(lb);
                    }
                }
            }
        }

        protected void gvCompetitions_RowCreated(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Pager)
            {
                GridView gv = (GridView)sender;
                LinkButton lnkPrev = (LinkButton)e.Row.FindControl("lnkPrev");
                if (lnkPrev != null)
                {
                    int prevIndex = gv.PageIndex - 1;
                    if (prevIndex < 0)
                        lnkPrev.Visible = false;
                    else
                    {
                        lnkPrev.Visible = true;
                        lnkPrev.CommandArgument = prevIndex.ToString();
                    }
                }
                LinkButton lnkNext = (LinkButton)e.Row.FindControl("lnkNext");
                if (lnkNext != null)
                {
                    int nextIndex = gv.PageIndex + 1;
                    if (nextIndex >= gv.PageCount)
                        lnkNext.Visible = false;
                    else
                    {
                        lnkNext.Visible = true;
                        lnkNext.CommandArgument = nextIndex.ToString();
                    }
                }
                PlaceHolder ph = (PlaceHolder)e.Row.FindControl("phNumeric");
                if (ph != null)
                {
                    ph.Controls.Clear();
                    int pageCount = gv.PageCount;
                    if (pageCount <= 1)
                        return;
                    for (int i = 0; i < pageCount; i++)
                    {
                        LinkButton lb = new LinkButton();
                        lb.Text = (i + 1).ToString();
                        lb.CommandName = "Page";
                        lb.CommandArgument = i.ToString();
                        lb.CssClass = "pager-btn";
                        if (i == gv.PageIndex)
                        {
                            lb.Enabled = false;
                            lb.CssClass += " current-page";
                        }
                        ph.Controls.Add(lb);
                    }
                }
            }
        }
        #endregion

        #region 详细编辑数据加载
        // 加载指定用户详细信息
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

        // 加载指定题目详细信息
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

        // 加载指定题单（分类）的详细信息，包括关联题目（逗号分隔的题目ID列表）
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
                conn.Close();
                // 加载该题单关联的题目ID列表
                string query2 = "SELECT GROUP_CONCAT(problem_id) AS problems FROM category_problems WHERE category_id=@id";
                MySqlCommand cmd2 = new MySqlCommand(query2, conn);
                cmd2.Parameters.AddWithValue("@id", categoryId);
                conn.Open();
                object obj = cmd2.ExecuteScalar();
                conn.Close();
                txtCategoryProblems.Text = (obj != null && obj != DBNull.Value) ? obj.ToString() : "";
            }
        }

        // 加载指定比赛的详细信息，包括关联题目（逗号分隔的题目ID列表）
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
                conn.Close();
                // 加载比赛关联的题目ID列表
                string query2 = "SELECT GROUP_CONCAT(problem_id) AS problems FROM competition_problems WHERE competition_id=@id";
                MySqlCommand cmd2 = new MySqlCommand(query2, conn);
                cmd2.Parameters.AddWithValue("@id", competitionId);
                conn.Open();
                object obj = cmd2.ExecuteScalar();
                conn.Close();
                txtCompetitionProblems.Text = (obj != null && obj != DBNull.Value) ? obj.ToString() : "";
            }
        }
        #endregion

        #region 保存操作
        // 保存用户编辑数据
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
            MultiView1.SetActiveView(viewUserOverview);
        }

        // 保存题目编辑数据
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
            MultiView1.SetActiveView(viewProblemOverview);
        }

        // 保存题单编辑数据，包括更新关联题目（category_problems 表）
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
            MultiView1.SetActiveView(viewCategoryOverview);
        }

        // 保存比赛编辑数据，包括更新关联题目（competition_problems 表）
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
            MultiView1.SetActiveView(viewCompetitionOverview);
        }
        #endregion

        #region 删除操作
        // 删除指定用户
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

        // 删除指定题目
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

        // 删除指定题单
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

        // 删除指定比赛
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
        // 添加新用户记录，默认“未编辑”
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

        // 添加新题目记录，默认 difficulty 为 "Easy"
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

        // 添加新题单记录，新题单初始时无关联题目
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
        // 获取下一个比赛ID（假设 competition_id 为整数）
        private int GetNextCompetitionId()
        {
            int nextId = 1;
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 查询当前最大的比赛ID，若为空则返回0
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
        // 修改后的添加新比赛记录方法
        protected void btnAddCompetition_Click(object sender, EventArgs e)
        {
            int newId = GetNextCompetitionId(); // 获取下一个有效的比赛ID
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                // 注意此处将 competition_id 显式插入
                string query = "INSERT INTO competitions (competition_id, competition_name, start_time, end_time) VALUES (@id, @name, @start, @end)";
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

        #region 统一取消编辑返回概览
        protected void btnCancel_Click(object sender, EventArgs e)
        {
            // 根据当前活动视图返回对应概览
            if (MultiView1.ActiveViewIndex == 4)
                MultiView1.SetActiveView(viewUserOverview);
            else if (MultiView1.ActiveViewIndex == 5)
                MultiView1.SetActiveView(viewProblemOverview);
            else if (MultiView1.ActiveViewIndex == 6)
                MultiView1.SetActiveView(viewCategoryOverview);
            else if (MultiView1.ActiveViewIndex == 7)
                MultiView1.SetActiveView(viewCompetitionOverview);
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

        #region 返回首页（退出登录）
        protected void btnHome_Click(object sender, EventArgs e)
        {
            if (Request.Cookies["UserInfo"] != null)
            {
                HttpCookie cookie = new HttpCookie("UserInfo");
                cookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(cookie);
            }
            Response.Redirect("/user/home.aspx");
        }
        #endregion

        #region 辅助方法：更新题单和比赛的关联题目
        // 根据传入的 categoryId 和逗号分隔的 problemId 字符串，更新 category_problems 表
        private void UpdateCategoryProblems(int categoryId, string problems)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 先删除该题单的所有关联关系
                string delQuery = "DELETE FROM category_problems WHERE category_id=@cid";
                MySqlCommand delCmd = new MySqlCommand(delQuery, conn);
                delCmd.Parameters.AddWithValue("@cid", categoryId);
                delCmd.ExecuteNonQuery();

                // 如果问题字符串非空，则插入新的关联关系
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

        // 根据传入的 competitionId 和逗号分隔的 problemId 字符串，更新 competition_problems 表
        private void UpdateCompetitionProblems(int competitionId, string problems)
        {
            using (MySqlConnection conn = new MySqlConnection(connStr))
            {
                conn.Open();
                // 删除该比赛的所有关联关系
                string delQuery = "DELETE FROM competition_problems WHERE competition_id=@cid";
                MySqlCommand delCmd = new MySqlCommand(delQuery, conn);
                delCmd.Parameters.AddWithValue("@cid", competitionId);
                delCmd.ExecuteNonQuery();

                // 插入新的关联关系（如果有输入）
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
    }
}
