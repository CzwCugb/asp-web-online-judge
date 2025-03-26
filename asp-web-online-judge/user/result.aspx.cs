using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using online_judge.BLL;


namespace asp_web_online_judge
{
	public partial class result : System.Web.UI.Page
	{
        protected void Page_Load(object sender, EventArgs e)
        {
            var result = Session["result"] as JudgeResult; // 假设有存储判题结果的Session

            litStatus.Text = result.Status;
            statusBox.Attributes["class"] = GetStatusCssClass(result.Status);

            // 设置运行信息
            if (result.Status == "Accepted")
            {
                runtimeInfo.Visible = true;
                litTime.Text = result.Time.ToString();
                litMemory.Text = result.Memory.ToString();
            }

            // 设置错误信息
            if (result.Status.Contains("Error") || result.Status == "Time Limit Exceeded")
            {
                errorInfo.Visible = true;
                litError.Text = result.ErrorMessage;
            }

            // 设置测试用例对比
            if (result.Status == "Wrong Answer")
            {
                testCaseInfo.Visible = true;
                litInput.Text = HttpUtility.HtmlEncode(result.Input);
                litExpected.Text = HttpUtility.HtmlEncode(result.ExpectedOutput);
                litActual.Text = HttpUtility.HtmlEncode(result.ActualOutput);
            }
        }

        private string GetStatusCssClass(string status)
        {
            if (status == "Accepted") return "status-box accepted";
            else if (status == "Wrong Answer") return "status-box wrong-answer";
            else if (status == "Runtime Error") return "status-box runtime-error";
            else if (status == "Time Limit Exceeded") return "status-box time-limit";
            else return "status-box";
        }
    }
}