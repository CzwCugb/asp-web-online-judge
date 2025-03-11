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


        private void GeneratePageContent(string id)
        {
            string sql = $@"SELECT title,description,difficulty,time_memory_limit,
                    total_accepted,total_attempted,algorithm_tags 
                   FROM problem 
                   WHERE id={id}";
            DataTable dt = Dbconnection.ExecuteQuery(sql);
            var reader = dt.Rows[0];
            // 动态生成HTML内容
            Literal content = new Literal();
            content.Text = content.Text = $@"
<article class='problem-card'>
    <header class='problem-header'>
        <h1>{HttpUtility.HtmlEncode(reader["title"])}</h1>
        <div class='meta-info'>
            <span class='difficulty-badge' data-diff='{reader["difficulty"]}'>
                {reader["difficulty"]}
            </span>
            <dl class='limit-box'>
                <dt>限制</dt>
                <dd>{(reader["time_memory_limit"])}</dd>
            </dl>
        </div>
    </header>
    
    <section class='stats-container'>
        <div class='progress-bar' 
             data-accepted='{reader["total_accepted"]}'
             data-attempted='{reader["total_attempted"]}'>
        </div>
    </section>

    <section class='description-box markdown-content'>
        {markdown_to_html.to_html(reader["description"].ToString())}
    </section>

    <footer class='tag-container'>
        {(reader["algorithm_tags"])}
    </footer>
</article>";


            form1.Controls.Add(content);
        }
    }
}