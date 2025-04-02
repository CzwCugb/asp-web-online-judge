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
          background-color: #f2f4f8;
          margin: 0;
          padding: 0;
      }
      /* 主内容容器：白色背景、圆角和均匀阴影 */
      .main-container {
          background: #fff;
          border-radius: 8px;
          box-shadow: 0 0 10px rgba(0,0,0,0.15);
          padding: 20px;
          margin: 20px auto;
          max-width: 1200px;
      }
      /* 状态框样式 */
      .status-box {
          padding: 20px;
          border-radius: 5px;
          margin-bottom: 30px;
          text-align: center;
          font-size: 24px;
          font-weight: bold;
      }
      /* 每个用例整体横向布局容器 */
        .case-status-wrapper {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            flex-wrap: wrap; /* 适应小屏时自动换行 */
        }

        /* 左侧的状态标签样式：保留原始的 .status-box 样式 */
        .status-box {
            min-width: 140px;
            text-align: center;
        }

        /* 运行时信息右侧显示，保持字体 */
        .runtime-info {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            font-size: 18px; /* 更大字体 */
            color: #333;
            gap: 20px;
            margin-left: 10px; /* 向左贴一点 */
            flex-grow: 1; /* 占满剩余空间 */
        }


      .accepted { background: #d4edda; color: #155724; }
      .wrong-answer { background: #f8d7da; color: #721c24; }
      .runtime-error { background: #fff3cd; color: #856404; }
      .time-limit { background: #cce5ff; color: #004085; }
      
      /* 详情部分 */
      .detail-section {
          background: #fff;
          padding: 20px;
          border-radius: 5px;
          box-shadow: 0 0 10px rgba(0,0,0,0.15);
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
          background-color: #f8fafc;
          width: 120px;
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
      .source-code {
          white-space: pre-wrap;
          font-family: monospace;
      }
      /* 选项卡菜单样式 */
      .tab-menu {
          margin-bottom: 20px;
          display: flex;
          gap: 10px;
      }
      .tab-menu a {
          flex: none;
          padding: 10px 20px;
          border: 1px solid #ccc;
          text-decoration: none;
          border-radius: 5px;
          background-color: #f0f0f0;
          color: #333;
          transition: background-color 0.2s, color 0.2s;
      }
      .tab-menu a.active {
          background-color: var(--primary-color, #4361ee);
          color: #fff;
          border-color: var(--primary-color, #4361ee);
      }
      /* 运行时信息样式 */
      .runtime-info {
          margin-top: 10px;
          font-size: 16px;
          color: #555;
      }
      .runtime-info span {
          display: inline-block;
          margin-right: 20px;
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
              tabs[i].classList.remove('active');
          }
          // 设置当前链接为 active
          link.classList.add('active');
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
        <div class="main-container">
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
                            <!-- 状态与运行时信息横向排列 -->
                            <div class="case-status-wrapper">
                                <!-- 状态标签 -->
                                <span id="statusCaseBox" runat="server" class="status-box">
                                    <asp:Literal ID="litCaseStatus" runat="server" />
                                </span>
                                <!-- 运行时信息 -->
                                <asp:Panel ID="pnlRuntime" runat="server" CssClass="runtime-info" Visible="false">
                                    <span class="runtime-time">用时: <asp:Literal ID="litTime" runat="server" /> ms</span>
                                    <span class="runtime-memory">内存: <asp:Literal ID="litMemory" runat="server" /> KB</span>
                                </asp:Panel>
                            </div>

                            <!-- 错误信息 -->
                            <asp:Panel ID="pnlError" runat="server" CssClass="error-info" Visible="false">
                                <pre><asp:Literal ID="litError" runat="server" /></pre>
                            </asp:Panel>
                            <!-- 测试用例对比 -->
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
        </div>
    </form>
</body>
</html>
