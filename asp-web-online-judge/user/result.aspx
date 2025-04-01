<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="result.aspx.cs" Inherits="asp_web_online_judge.result" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>评测结果</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            background-color: #f5f5f5;
        }

        .status-box {
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 30px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        .accepted {
            background-color: #dff0d8;
            color: #3c763d;
            border: 1px solid #d6e9c6;
        }

        .wrong-answer {
            background-color: #f2dede;
            color: #a94442;
            border: 1px solid #ebccd1;
        }

        .runtime-error {
            background-color: #fcf8e3;
            color: #8a6d3b;
            border: 1px solid #faebcc;
        }

        .time-limit {
            background-color: #d9edf7;
            color: #31708f;
            border: 1px solid #bce8f1;
        }

        .detail-section {
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }

        .data-table th, 
        .data-table td {
            padding: 12px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            font-family: Consolas, monospace;
            white-space: pre-wrap;
        }

        .data-table th {
            background-color: #f8f9fa;
            width: 120px;
        }

        .test-case {
            margin: 15px 0;
            padding: 15px;
            border: 1px solid #eee;
            border-radius: 4px;
        }

        .diff-output {
            color: #dc3545;
            font-weight: bold;
        }

        .test-case-item {
            border: 1px solid #eee;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
        }

        .io-section pre {
            background: #f6f8fa;
            padding: 10px;
            border-radius: 3px;
        }

        .status-box {
            padding: 2px 8px;
            border-radius: 3px;
            font-weight: bold;
        }

        .accepted { background: #d4edda; color: #155724; }
        .wrong-answer { background: #f8d7da; color: #721c24; }
        .runtime-error { background: #fff3cd; color: #856404; }
        .time-limit { background: #cce5ff; color: #004085; }

    </style>
</head>
<body>
        <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />

    <form id="form1" runat="server">

        <asp:Repeater ID="rptTestCases" runat="server" OnItemDataBound="rptTestCases_ItemDataBound">
            <ItemTemplate>
                <div class="test-case-item">
                    <%-- 单个用例状态 --%>
                    <div class="case-status">
                        <span id="statusCaseBox" runat="server" class="status-box">
                            <asp:Literal ID="litCaseStatus" runat="server" />
                        </span>
                    </div>

                    <%-- 运行时信息 --%>
                    <asp:Panel ID="pnlRuntime" runat="server" CssClass="runtime-info" Visible="false">
                        用时: <asp:Literal ID="litTime" runat="server" /> ms
                        内存: <asp:Literal ID="litMemory" runat="server" /> KB
                    </asp:Panel>

                    <%-- 错误信息 --%>
                    <asp:Panel ID="pnlError" runat="server" CssClass="error-info" Visible="false">
                        <pre><asp:Literal ID="litError" runat="server" /></pre>
                    </asp:Panel>

                    <%-- 测试用例对比 --%>
                    <asp:Panel ID="pnlTestCase" runat="server" CssClass="test-case-info" Visible="false">
                        <div class="io-section">
                            <h5>输入</h5>
                            <pre><asp:Literal ID="litInput" runat="server" /></pre>
                        </div>
                        <div class="io-section">
                            <h5>期望输出</h5>
                            <pre><asp:Literal ID="litExpected" runat="server" /></pre>
                        </div>
                        <div class="io-section">
                            <h5>实际输出</h5>
                            <pre><asp:Literal ID="litActual" runat="server" /></pre>
                        </div>
                    </asp:Panel>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <div class="status-box" id="statusBox" runat="server">
            <asp:Literal ID="litStatus" runat="server"></asp:Literal>
        </div>

        <div class="detail-section" id="runtimeInfo" runat="server" visible="false">
            <h3>运行信息</h3>
            <table class="data-table">
                <tr>
                    <th>时间消耗</th>
                    <td><asp:Literal ID="litTime" runat="server"></asp:Literal> ms</td>
                </tr>
                <tr>
                    <th>内存消耗</th>
                    <td><asp:Literal ID="litMemory" runat="server"></asp:Literal> KB</td>
                </tr>
            </table>
        </div>

        <div class="detail-section" id="errorInfo" runat="server" visible="false">
            <h3>错误信息</h3>
            <pre><asp:Literal ID="litError" runat="server"></asp:Literal></pre>
        </div>

        <div class="detail-section" id="testCaseInfo" runat="server" visible="false">
            <h3>测试用例对比</h3>
            <div class="test-case">
                <h4>输入</h4>
                <pre><asp:Literal ID="litInput" runat="server"></asp:Literal></pre>
            </div>
            
            <div class="test-case">
                <h4>预期输出</h4>
                <pre><asp:Literal ID="litExpected" runat="server"></asp:Literal></pre>
            </div>

            <div class="test-case">
                <h4>实际输出</h4>
                <pre><asp:Literal ID="litActual" runat="server"></asp:Literal></pre>
            </div>

            <div id="diffInfo" runat="server" visible="false" class="diff-output">
                <asp:Literal ID="litDiff" runat="server"></asp:Literal>
            </div>
        </div>
    </form>
</body>
</html>