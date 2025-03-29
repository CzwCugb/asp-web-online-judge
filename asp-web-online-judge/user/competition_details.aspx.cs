using System;
using System.Data;
using System.Web.UI;
using MySql.Data.MySqlClient;
using online_judge.DAL;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class competition_details : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!int.TryParse(Request.QueryString["id"], out int competitionId))
                {
                    Response.Redirect("competitions.aspx");
                    return;
                }
                LoadCompetitionData(competitionId);
            }
        }

        private void LoadCompetitionData(int competitionId)
        {
            // 加载比赛信息
            DataTable dtCompetition = Dbconnection.ExecuteQuery(
                $"SELECT competition_name, start_time, end_time FROM competitions WHERE competition_id = {competitionId}");

            if (dtCompetition.Rows.Count == 0)
            {
                Response.Redirect("competitions.aspx");
                return;
            }
            string competitionName = dtCompetition.Rows[0]["competition_name"].ToString();
            DateTime startTime = Convert.ToDateTime(dtCompetition.Rows[0]["start_time"]);
            DateTime endTime = Convert.ToDateTime(dtCompetition.Rows[0]["end_time"]);
            h1Title.InnerText = competitionName;

            // 检查比赛是否在有效时间内
            DateTime now = DateTime.Now;
            if (now < startTime || now > endTime)
            {
                pnlNotActive.Visible = true;
                GridView1.Visible = false;
                pnlNoProblems.Visible = false;
                return;
            }

            // 加载比赛题目列表
            string sql = $@"
                SELECT 
                    p.id,
                    p.title,
                    p.difficulty,
                    p.time_memory_limit,
                    p.total_accepted,
                    -- 假设 SubmissionStatus 字段由其他逻辑决定：correct、wrong或空（未做）
                    '' AS SubmissionStatus
                FROM competition_problems cp
                JOIN problem p ON cp.problem_id = p.id
                WHERE cp.competition_id = {competitionId}
                ORDER BY p.id;
            ";

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

        /// <summary>
        /// 根据题目的提交状态返回状态标识
        /// 如果状态为 "correct"，返回绿√；"wrong"返回红×；否则返回空字符串
        /// </summary>
        public string GetSubmissionStatus(object problemId, object statusObj)
        {
            string status = statusObj?.ToString().ToLower();
            if (status == "correct")
            {
                return "<span class='text-success' title='通过'>&#10004;</span>";
            }
            else if (status == "wrong")
            {
                return "<span class='text-danger' title='错误'>&#10008;</span>";
            }
            return "";
        }

        public string GetDifficultyClass(string difficulty)
        {
            if (string.IsNullOrEmpty(difficulty)) return "secondary";

            var diff = difficulty.ToLower();
            if (diff == "easy") return "bg-success";
            if (diff == "medium") return "bg-warning";
            return "bg-danger";
        }

        public string GetCompetitionIdFromUrl()
        {
            return Request.QueryString["id"];
        }
    }
}
