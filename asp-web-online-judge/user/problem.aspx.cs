using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace asp_web_online_judge
{
    public partial class problem : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // 页面加载时的逻辑
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
            string sql = $@"SELECT title,description,difficulty,time_memory_limit,
                    total_accepted,total_attempted,algorithm_tags 
                   FROM problem 
                   WHERE id={id}";
            DataTable dt = Dbconnection.ExecuteQuery(sql);
            var reader = dt.Rows[0];

            //更改标题
            Literal content_title = new Literal();
            title.Controls.Clear();
            content_title.Text = reader["title"].ToString();
            title.Controls.Add(content_title);

            // 动态生成HTML内容
            Literal content = new Literal();
            content.Text = content.Text = $@"
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
                        <span class='difficulty-badge badge 
                            {GetDifficultyClass(reader["difficulty"].ToString())}'>
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
            form1.Controls.AddAt(0,content);
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            string code = CodeBox.Text;
            string language = Request.Form["languageSelector"];

            // 添加代码验证逻辑
            if (string.IsNullOrWhiteSpace(code))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "EmptyCode",
                    "showToast('⚠️ 代码内容不能为空！', 'warning');", true);
                return;
            }
            /*
            try
            {
                // 提交到判题队列
                JudgeService.SubmitCode(code, language);
                ClientScript.RegisterStartupScript(this.GetType(), "SubmitSuccess",
                    "showToast('🚀 代码提交成功！', 'success');", true);
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "SubmitError",
                    $"showToast('❌ 提交失败：{ex.Message}', 'error');", true);
            }
            */
        }
    }
}