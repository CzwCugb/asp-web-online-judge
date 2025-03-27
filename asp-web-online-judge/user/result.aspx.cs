using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using online_judge.BLL;


namespace asp_web_online_judge
{
	public partial class result : System.Web.UI.Page
	{
        protected void Page_Load(object sender, EventArgs e)
        {
            var results = Session["results"] as List<JudgeResult>;

            // 设置整体状态（假设result是综合状态）
            var finalResult = Session["result"] as JudgeResult;
            litStatus.Text = finalResult.Status;
            statusBox.Attributes["class"] = GetStatusCssClass(finalResult.Status);

            // 绑定测试用例结果列表
            rptTestCases.DataSource = results;
            rptTestCases.DataBind();

        }


        protected void rptTestCases_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var result = e.Item.DataItem as JudgeResult;

                // 获取控件
                var pnlRuntime = e.Item.FindControl("pnlRuntime") as Panel;
                var litTime = e.Item.FindControl("litTime") as Literal;
                var litMemory = e.Item.FindControl("litMemory") as Literal;
                var pnlError = e.Item.FindControl("pnlError") as Panel;
                var litError = e.Item.FindControl("litError") as Literal;
                var pnlTestCase = e.Item.FindControl("pnlTestCase") as Panel;
                var litInput = e.Item.FindControl("litInput") as Literal;
                var litExpected = e.Item.FindControl("litExpected") as Literal;
                var litActual = e.Item.FindControl("litActual") as Literal;
                var litCaseStatus = e.Item.FindControl("litCaseStatus") as Literal;
                var statusCaseBox = e.Item.FindControl("statusCaseBox") as HtmlGenericControl;

                // 设置状态
                litCaseStatus.Text = result.Status;
                if (statusCaseBox != null)
                {
                    statusCaseBox.Attributes["class"] = GetStatusCssClass(result.Status);
                }


                // 运行信息
                pnlRuntime.Visible = result.Status == "Accepted";
                litTime.Text = result.Time.ToString();
                litMemory.Text = result.Memory.ToString();

                // 错误信息
                pnlError.Visible = result.Status.Contains("Error") || result.Status == "Time Limit Exceeded";
                litError.Text = result.ErrorMessage;

                // 测试用例对比
                pnlTestCase.Visible = result.Status == "Wrong Answer";
                litInput.Text = HttpUtility.HtmlEncode(result.Input);
                litExpected.Text = HttpUtility.HtmlEncode(result.ExpectedOutput);
                litActual.Text = HttpUtility.HtmlEncode(result.ActualOutput);
            }
        }



        public string GetStatusCssClass(string status)
        {
            if (status == "Accepted") return "status-box accepted";
            else if (status == "Wrong Answer") return "status-box wrong-answer";
            else if (status == "Runtime Error") return "status-box runtime-error";
            else if (status == "Time Limit Exceeded") return "status-box time-limit";
            else return "status-box";
        }
    }
}