using System;
using System.Collections.Generic;
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
        }

        protected void SubmitButton_Click(object sender, EventArgs e)
        {
            string userCode = CodeBox.Text;
            // 在这里处理用户提交的代码
            // 例如：编译、运行、判断结果等
            // 这里只是一个简单的示例，实际应用中需要更复杂的处理逻辑
            Response.Write("代码已提交: " + userCode);
        }
    }
}