using System;
using System.Data;
using System.Web;
using System.Web.UI;
using online_judge.DAL;

namespace asp_web_online_judge
{
    public partial class submissions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 使用 Cookies 检查用户是否登录
            if (Request.Cookies["UserInfo"] == null)
            {
                Response.Redirect("login.aspx");
                return;
            }

            // 从 Cookies 中获取用户 ID
            int userId = GetCurrentUserId();

            // 查询当前用户的提交记录，并按提交时间降序排列，同时关联题目标题
            string sql = $@"
                SELECT s.submission_id, s.problem_id, s.submission_time, s.status_, s.test_cases, s.code_, s.language_,
                       p.title as problemTitle
                FROM submissions s
                INNER JOIN problem p ON s.problem_id = p.id
                WHERE s.user_id = {userId}
                ORDER BY s.submission_time DESC";
            DataTable dt = Dbconnection.ExecuteQuery(sql);

            // 生成表格 HTML 内容
            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            sb.Append("<table class='table table-hover submission-table'>");
            sb.Append("<thead><tr><th>提交时间</th><th>题目</th><th>语言</th><th>状态</th></tr></thead><tbody>");

            foreach (DataRow row in dt.Rows)
            {
                string submissionId = row["submission_id"].ToString();
                string submissionTime = Convert.ToDateTime(row["submission_time"]).ToString("yyyy-MM-dd HH:mm:ss");
                string problemTitle = HttpUtility.HtmlEncode(row["problemTitle"].ToString());
                string language = row["language_"].ToString();
                string status = row["status_"].ToString();

                // 这里 test_cases 字段存储的是 JSON 字符串，假设格式为：[{"case_id": 1, "status": "AC"}, ...]
                string testCases = row["test_cases"].ToString();
                // 代码内容需要经过 JavaScript 字符串编码以避免引号问题
                string code = HttpUtility.JavaScriptStringEncode(row["code_"].ToString());

                // 构造 JSON 数据字符串，用于在模态窗口中显示提交详情
                string jsonData = $"{{\"submissionId\":\"{submissionId}\",\"submissionTime\":\"{submissionTime}\",\"problemTitle\":\"{problemTitle}\",\"language\":\"{language}\",\"status\":\"{status}\",\"testCases\":{testCases},\"code\":\"{code}\"}}";

                // 每一行记录均设置点击事件，传递 submissionId
                sb.Append("<tr style='cursor:pointer;' onclick='showSubmissionDetails(\"" + submissionId + "\")'>");
                sb.Append($"<td>{submissionTime}</td>");
                sb.Append($"<td>{problemTitle}</td>");
                sb.Append($"<td>{language}</td>");
                sb.Append($"<td>{status}</td>");
                sb.Append("</tr>");
                // 隐藏域存放该记录的详细 JSON 数据
                sb.Append($"<input type='hidden' id='data-{submissionId}' value='{HttpUtility.HtmlEncode(jsonData)}' />");
            }
            sb.Append("</tbody></table>");

            SubmissionsLiteral.Text = sb.ToString();
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

        private void ShowAlert(string message)
        {
            // 实现你的警报显示逻辑
            ClientScript.RegisterStartupScript(GetType(), "alert",
                $"alert('{HttpUtility.JavaScriptStringEncode(message)}');", true);
        }
    }
}
