<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="leaderboard.aspx.cs" Inherits="asp_web_online_judge.leaderboard" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>排行榜</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        :root {
            --primary-color: #4361ee;
            --warning-color: #f59e0b;
        }
        body {
            background-color: #f2f4f8;
        }
        /* 题目链接样式 */
        .problem-link {
            color: #1a1a1a;
            text-decoration: none;
            transition: color 0.2s;
        }
        .problem-link:hover {
            color: var(--primary-color);
            text-decoration: underline;
        }
        /* 难度徽章样式 */
        .difficulty-badge {
            font-size: 0.85em;
            min-width: 70px;
            display: inline-block;
            text-align: center;
            padding: 3px 10px;
            border-radius: 4px;
            color: white !important;
        }
        /* 其他小样式 */
        .problem-status {
            width: 24px;
            height: 24px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 4px;
        }
        .problem-status.solved {
            background: #22c55e;
            color: white;
        }
        .problem-status.attempted {
            background: var(--warning-color);
            color: white;
        }
        /* 左侧菜单按钮 */
        .sidebar-btn {
            padding: 12px 20px;
            border-radius: 8px;
            margin: 8px 0;
            transition: all 0.2s ease;
            border: 1px solid transparent;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .sidebar-btn:hover {
            background-color: #eef2ff;
            border-color: var(--primary-color);
        }
        .sidebar-btn.active {
            background-color: var(--primary-color);
            color: white !important;
            box-shadow: 0 2px 6px rgba(67,97,238,0.2);
        }
        /* 表格样式 */
        .table thead th {
            font-weight: 600;
            color: #64748b;
            background-color: #f8fafc;
            border-bottom: 2px solid #e2e8f0;
        }
        .table td {
            padding: 14px 16px;
            vertical-align: middle;
        }
        @media (max-width: 768px) {
            .sidebar {
                margin-bottom: 24px;
            }
            .table-responsive {
                border-radius: 8px;
                border: 1px solid #e2e8f0;
            }
        }
    </style>
</head>
<body>
    <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />
    <form id="form1" runat="server">
        <div class="container py-4">
            <div class="row g-4">
                <!-- 左侧侧边栏（统一菜单） -->
                <div class="col-lg-3">
                    <div class="sidebar bg-white shadow-sm rounded-lg p-3">
                        <a href="competition_details.aspx?id=<%= Request.QueryString["id"] %>" class="sidebar-btn text-dark text-decoration-none" onclick="showTab('problems')">
                            <i class="bi bi-list-task"></i>
                            题目列表
                        </a>
                        <a href="leaderboard.aspx?id=<%= Request.QueryString["id"] %>" class="sidebar-btn active text-dark text-decoration-none">
                            <i class="bi bi-trophy"></i>
                            排行榜
                        </a>
                    </div>
                </div>
                <!-- 右侧主要内容 -->
                <div class="col-lg-9">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h1 class="h3" runat="server" id="h1Title"></h1>
                        <a href="competitions.aspx" class="btn btn-outline-secondary">
                            <i class="bi bi-arrow-left"></i> 返回比赛列表
                        </a>
                    </div>
                    <!-- 排行榜 GridView -->
                    <asp:GridView ID="GridViewLeaderboard" runat="server" AutoGenerateColumns="false" CssClass="table table-hover" GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="account" HeaderText="用户名" />
                            <asp:BoundField DataField="total_problems_solved" HeaderText="通过题目数" />
                        </Columns>
                    </asp:GridView>
                    <!-- 无数据时显示提示 -->
                    <asp:Label ID="lblNoData" runat="server" Text="暂无数据" CssClass="text-muted" Visible="false"></asp:Label>
                </div>
            </div>
        </div>
        <script>
            function showTab(tabName) {
                const tabs = {
                    problems: document.getElementById('tabProblems'),
                    leaderboard: document.getElementById('tabLeaderboard')
                };
                // 隐藏所有 tab（如果有相应内容区域的话）
                Object.values(tabs).forEach(tab => {
                    if (tab) tab.style.display = 'none';
                });
                if (tabs[tabName]) {
                    tabs[tabName].style.display = 'block';
                }
                document.querySelectorAll('.sidebar-btn').forEach(btn => {
                    btn.classList.remove('active');
                    // 根据图标判断当前按钮
                    if (btn.querySelector('i').classList.contains(tabName === 'problems' ? 'bi-list-task' : 'bi-trophy')) {
                        btn.classList.add('active');
                    }
                });
            }
        </script>
    </form>
</body>
</html>
