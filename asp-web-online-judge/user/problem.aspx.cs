using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using online_judge.BLL;
using online_judge.DAL;
using Newtonsoft.Json;
using MySqlX.XDevAPI.Common;

namespace asp_web_online_judge
{
    public partial class problem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string problemId = Request.QueryString["id"];
                if (!string.IsNullOrEmpty(problemId))
                {
                    GeneratePageContent(problemId);
                }
            }
        }

        public string GetDifficultyClass(string difficulty)
        {
            if (difficulty == "Easy") return "bg-success";
            if (difficulty == "Medium") return "bg-warning";
            if (difficulty == "Hard") return "bg-danger";
            return "bg-secondary";
        }
        private void GeneratePageContent(string id)
        {
            string sql = $@"SELECT title, description, difficulty, time_memory_limit,
                            total_accepted, total_attempted, algorithm_tags 
                            FROM problem 
                            WHERE id = {id}";
            DataTable dt = Dbconnection.ExecuteQuery(sql);
            var reader = dt.Rows[0];

            // 更改页面标题
            Literal content_title = new Literal();
            title.Controls.Clear();
            content_title.Text = reader["title"].ToString();
            title.Controls.Add(content_title);

            // 动态生成 HTML 内容
            Literal content = new Literal();
            content.Text = $@"
<div class='problem-card'>
    <header class='problem-header'>
        <h1>{HttpUtility.HtmlEncode(reader["title"])}</h1>
    </header>
    
    <div class='two-column-layout'>
        <!-- 左侧题面部分 -->
        <section class='description-box markdown-content'>
            {markdown_to_html.to_html(reader["description"].ToString())}
        </section>

        <!-- 右侧信息部分 -->
        <div class='right-sidebar'>
            <div class='meta-info'>
                <asp:TemplateField HeaderText=""难度"">
                    <p><dt>难度</dt></p>
                    <ItemTemplate>
                        <span class='difficulty-badge badge {GetDifficultyClass(reader["difficulty"].ToString())}'>
                           {reader["difficulty"].ToString()}
                        </span>
                    </ItemTemplate>
                </asp:TemplateField>
                <dl class='limit-box'>
                    <dt>限制</dt>
                    <dd>{(reader["time_memory_limit"])}</dd>
                </dl>
            </div>

            <section class='stats-container'>
                <div class='progress-bar'>
                     <p>总通过数：{reader["total_accepted"]}</p>
                     <p>总尝试数：{reader["total_attempted"]}</p>
                </div>
            </section>

            <footer class='tag-container'>
                {(reader["algorithm_tags"])}
            </footer>
        </div>
    </div>
</div>";
            form1.Controls.AddAt(0, content);
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            string code = CodeBox.Text.Trim();
            string language = Request.Form["languageSelector"];

            if (string.IsNullOrWhiteSpace(code))
            {
                ShowAlert("代码不能为空！");
                return;
            }

            try
            {
                int userId = GetCurrentUserId();
                int problemId = int.Parse(Request.QueryString["id"]);
                string submissionId = Guid.NewGuid().ToString();

                // 执行判题
                JudgeResult testResult = JudgeService.Execute(problemId, code, language);
                List<JudgeResult> testResults = JudgeService.Executemulti(problemId, code, language);
                Session["result"] = testResult;
                Session["results"] = testResults;

                // 确定最终状态
                string finalStatus = "AC";
                foreach (var result in testResults)
                {
                    if (result.Status != "Accepted")
                    {
                        finalStatus = ConvertStatusToDatabaseFormat(result.Status);
                        break;
                    }
                }

                // 序列化测试结果
                string testCasesJson = JsonConvert.SerializeObject(
                    testResults.Select(r => new {
                        case_id = r.TestCaseId,
                        status = ConvertStatusToDatabaseFormat(r.Status),
                        time_used = r.Time,
                        memory_used = r.Memory,
                        actual_output = r.ActualOutput,
                        expected_output = r.ExpectedOutput
                    })
                );

                // 插入提交记录
                string sql = @"INSERT INTO submissions 
                            (submission_id, user_id, problem_id, submission_time, 
                             status_, test_cases, code_, language_)
                            VALUES 
                            (@subId, @userId, @probId, NOW(), @status, @cases, @code, @lang)";

                MySqlParameter[] parameters = {
                    new MySqlParameter("@subId", MySqlDbType.VarChar) { Value = submissionId },
                    new MySqlParameter("@userId", MySqlDbType.Int32) { Value = userId },
                    new MySqlParameter("@probId", MySqlDbType.Int32) { Value = problemId },
                    new MySqlParameter("@status", MySqlDbType.Enum) { Value = finalStatus },
                    new MySqlParameter("@cases", MySqlDbType.JSON) { Value = testCasesJson },
                    new MySqlParameter("@code", MySqlDbType.Text) { Value = code },
                    new MySqlParameter("@lang", MySqlDbType.Enum) {
                        Value = language == "c/c++" ? "C++" : "Python"
                    }
                };

                int affectedRows = Dbconnection.ExecuteNonQuery(sql, parameters);

                if (affectedRows > 0)
                {
                    Response.Redirect($"result.aspx?id={problemId}&submission={submissionId}");
                }
            }
            catch (Exception ex)
            {
                ShowAlert($"提交失败：{ex.Message}");
            }
        }

        private int GetCurrentUserId()
        {
            HttpCookie cookie = Request.Cookies["UserInfo"];
            if (cookie == null || string.IsNullOrEmpty(cookie["Userid"]))
            {
                Response.Redirect("login.aspx?returnUrl=" + HttpUtility.UrlEncode(Request.Url?.AbsoluteUri));
                throw new HttpException(401, "Unauthorized");
            }

            if (!int.TryParse(cookie["Userid"], out int userId))
            {
                ShowAlert("无效的用户ID格式");
                throw new FormatException("Invalid user ID format");
            }

            return userId;
        }

        private string ConvertStatusToDatabaseFormat(string judgeStatus)
        {
            switch (judgeStatus)
            {
                case "Accepted": return "AC";
                case "Wrong Answer": return "WA";
                case "Time Limit Exceeded": return "TLE";
                case "Runtime Error": return "RE";
                case "Compile Error": return "CE";
                default: return "IC";
            }
        }

        private void ShowAlert(string message)
        {
            ClientScript.RegisterStartupScript(GetType(), "alert",
                $"alert('{HttpUtility.JavaScriptStringEncode(message)}');", true);
        }
    }
}