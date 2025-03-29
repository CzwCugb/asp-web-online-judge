using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;
using online_judge.DAL;

namespace asp_web_online_judge
{
    public partial class leaderboard : Page
    {
        // 请确保在设计器文件中已正确声明以下控件：
        // protected global::System.Web.UI.HtmlControls.HtmlGenericControl h1Title;
        // protected global::System.Web.UI.WebControls.GridView GridViewLeaderboard;
        // protected global::System.Web.UI.WebControls.Label lblNoData;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["id"], out int competitionId))
                {
                    Response.Redirect("competitions.aspx");
                    return;
                }
                LoadLeaderboardData(competitionId);
            }
        }

        private void LoadLeaderboardData(int competitionId)
        {
            // 获取比赛名称
            DataTable dtCompetition = Dbconnection.ExecuteQuery(
                $"SELECT competition_name FROM competitions WHERE competition_id = {competitionId}");

            if (dtCompetition == null || dtCompetition.Rows.Count == 0)
            {
                Response.Redirect("competitions.aspx");
                return;
            }
            string competitionName = dtCompetition.Rows[0]["competition_name"].ToString();
            h1Title.InnerText = competitionName;

            // 查询排行榜数据
            string sql = $@"
                SELECT 
                    u.account,
                    COUNT(DISTINCT s.problem_id) AS total_problems_solved
                FROM submissions s
                JOIN user u ON s.user_id = u.id
                WHERE s.comp_id = {competitionId}
                  AND s.status_ = 'AC'
                GROUP BY u.id
                ORDER BY total_problems_solved DESC;
            ";

            DataTable dtLeaderboard = Dbconnection.ExecuteQuery(sql);

            if (dtLeaderboard != null && dtLeaderboard.Rows.Count > 0)
            {
                GridViewLeaderboard.DataSource = dtLeaderboard;
                GridViewLeaderboard.DataBind();
                GridViewLeaderboard.Visible = true;
                lblNoData.Visible = false;
            }
            else
            {
                // 没有数据时，隐藏 GridView 并显示提示信息
                GridViewLeaderboard.Visible = false;
                lblNoData.Visible = true;
            }
        }
    }
}
