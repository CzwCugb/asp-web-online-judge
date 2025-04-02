<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="submissions.aspx.cs" Inherits="asp_web_online_judge.submissions" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>我的提交记录</title>
    <!-- 引入 Bootstrap 样式 -->
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
    <!-- 引入 CodeMirror 样式（仅用于代码展示） -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/monokai.min.css"/>
    <style>
        body {
            background-color: #f2f4f8;
        }
        /* 主内容容器：白色背景、圆角和阴影 */
        .main-container {
            margin-top: 100px; /* 根据需要调整上边距 */
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        .submission-table {
            margin-top: 30px;
        }
        .modal-body {
            max-height: 70vh;
            overflow-y: auto;
        }
        .code-view {
            border: 1px solid #ddd;
            padding: 10px;
            border-radius: 5px;
            background: #2d2d2d;
            color: #ccc;
            font-family: 'Fira Code', monospace;
        }
    </style>
</head>
<body>
    <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />
    <form id="form1" runat="server">
        <div class="container main-container">
            <h1 class="mt-3 mb-4">我的提交记录</h1>
            <!-- 提交记录列表由后端生成 -->
            <asp:Literal ID="SubmissionsLiteral" runat="server"></asp:Literal>
        </div>

        <!-- 模态窗口：用于显示提交详情 -->
        <div class="modal fade" id="submissionModal" tabindex="-1" aria-labelledby="submissionModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-lg modal-dialog-scrollable">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="submissionModalLabel">提交详情</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="关闭"></button>
              </div>
              <div class="modal-body">
                <div id="submissionDetails">
                    <p><strong>题目：</strong><span id="modalProblemTitle"></span></p>
                    <p><strong>提交时间：</strong><span id="modalSubmissionTime"></span></p>
                    <p><strong>语言：</strong><span id="modalLanguage"></span></p>
                    <p><strong>整体状态：</strong><span id="modalStatus"></span></p>
                    <hr />
                    <h5>测试点详情</h5>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>用例编号</th>
                                <th>状态</th>
                            </tr>
                        </thead>
                        <tbody id="modalTestCases">
                        </tbody>
                    </table>
                    <hr />
                    <h5>提交代码</h5>
                    <pre id="modalCode" class="code-view"></pre>
                </div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">关闭</button>
              </div>
            </div>
          </div>
        </div>
    </form>
    <!-- 引入 Bootstrap JS -->
    <script src="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        // 点击表格行时调用此函数，根据隐藏域中的 JSON 数据填充模态窗口
        function showSubmissionDetails(submissionId) {
            var submissionData = JSON.parse(document.getElementById("data-" + submissionId).value);

            document.getElementById("modalProblemTitle").innerText = submissionData.problemTitle;
            document.getElementById("modalSubmissionTime").innerText = submissionData.submissionTime;
            document.getElementById("modalLanguage").innerText = submissionData.language;
            document.getElementById("modalStatus").innerText = submissionData.status;

            // 构建测试点详情表格
            var testCasesHtml = "";
            for (var i = 0; i < submissionData.testCases.length; i++) {
                var tc = submissionData.testCases[i];
                testCasesHtml += "<tr><td>" + tc.case_id + "</td><td>" + tc.status + "</td></tr>";
            }
            document.getElementById("modalTestCases").innerHTML = testCasesHtml;

            // 显示代码
            document.getElementById("modalCode").innerText = submissionData.code;

            // 弹出模态窗口
            var modal = new bootstrap.Modal(document.getElementById('submissionModal'));
            modal.show();
        }
    </script>
</body>
</html>
