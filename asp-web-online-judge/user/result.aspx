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
      
      .source-code {
            white-space: pre-wrap; /* 保留换行符和空白 */
            font-family: monospace;
       }


      .accepted { background: #d4edda; color: #155724; }
      .wrong-answer { background: #f8d7da; color: #721c24; }
      .runtime-error { background: #fff3cd; color: #856404; }
      .time-limit { background: #cce5ff; color: #004085; }
      
      /* 新增选项卡菜单样式 */
      .tab-menu {
          margin-bottom: 20px;
      }
      .tab-menu a {
          padding: 8px 16px;
          border: 1px solid #ccc;
          cursor: pointer;
          text-decoration: none;
          margin-right: 5px;
          background: #f0f0f0;
      }
      .tab-menu a.active {
          background: #007acc;
          color: #fff;
      }
  </style>
  <script type="text/javascript">
      function showTab(tabId, link) {
          // 隐藏所有面板
          document.getElementById('resultPanel').style.display = 'none';
          document.getElementById('sourceCodePanel').style.display = 'none';
          // 显示选中的面板
          document.getElementById(tabId).style.display = 'block';
          // 移除所有链接的 active 样式
          var tabs = document.getElementsByClassName('tab-link');
          for (var i = 0; i < tabs.length; i++) {
              tabs[i].className = tabs[i].className.replace(' active', '');
          }
          // 设置当前链接为 active
          link.className += ' active';
      }
      window.onload = function () {
          // 默认显示“测评结果”
          document.getElementById('resultTab').click();
      }
  </script>
</head>
<body>
    <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />
    <form id="form1" runat="server">
        <!-- 选项卡菜单 -->
        <div class="tab-menu">
            <a id="resultTab" class="tab-link" onclick="showTab('resultPanel', this)">测评结果</a>
            <a id="sourceTab" class="tab-link" onclick="showTab('sourceCodePanel', this)">源代码</a>
        </div>
        <!-- 测评结果面板 -->
        <div id="resultPanel">
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
        </div>
        <!-- 源代码面板 -->
        <div id="sourceCodePanel" style="display:none;">
            <div class="detail-section">
                <h3>源代码</h3>
                <div class="source-code"><asp:Literal ID="litSourceCode" runat="server"></asp:Literal></div>
            </div>
        </div>
    </form>
</body>
</html>
