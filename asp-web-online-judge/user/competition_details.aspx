<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="competition_details.aspx.cs" Inherits="asp_web_online_judge.competition_details" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>比赛详情</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
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
<body class="bg-light">
        <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />

    <form id="form1" runat="server">
        <div class="container py-4">
            <div class="row g-4">
                <!-- 左侧侧边栏 -->
                <div class="col-lg-3">
                    <div class="sidebar bg-white shadow-sm rounded-lg p-3">
                        <a href="javascript:void(0);" class="sidebar-btn active" onclick="showTab('problems')">
                            <i class="bi bi-list-task"></i>
                            题目列表
                        </a>
                        <!-- 修改这里的href属性和移除onclick事件 -->
                        <a href="leaderboard.aspx?id=<%= GetCompetitionIdFromUrl() %>" class="sidebar-btn text-dark text-decoration-none">
                            <i class="bi bi-trophy"></i>
                            排行榜
                        </a>
                    </div>
                </div>

                <!-- 右侧内容 -->
                <div class="col-lg-9">
                    <div class="d-flex flex-column flex-md-row justify-content-between align-items-start gap-3 mb-4">
                        <h1 class="h2 mb-0 fw-bold text-dark" runat="server" id="h1Title"></h1>
                        <a href="competitions.aspx" class="btn btn-outline-primary btn-sm">
                            <i class="bi bi-arrow-left me-2"></i>返回比赛列表
                        </a>
                    </div>

                    <!-- 比赛状态提示 -->
                    <asp:Panel ID="pnlNotActive" runat="server" Visible="false">
                        <div class="alert alert-warning d-flex align-items-center mb-4">
                            <i class="bi bi-exclamation-circle-fill me-2 fs-5"></i>
                            <div>当前比赛未开始或已结束，无法进行作答</div>
                        </div>
                    </asp:Panel>

                    <!-- 题目列表 -->
                    <div id="tabProblems" class="tab-content">
                        <div class="card shadow-sm border-0">
                            <div class="table-responsive">
                                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" 
                                    CssClass="table table-hover mb-0"
                                    GridLines="None">
                                    <Columns>
                                        <asp:TemplateField HeaderText="状态">
                                            <ItemTemplate>
                                                <%# GetSubmissionStatus(Eval("id"), Eval("SubmissionStatus")) %>
                                            </ItemTemplate>
                                            <ItemStyle Width="60px" />
                                        </asp:TemplateField>
                                        
                                        <asp:BoundField DataField="id" HeaderText="#"
                                            ItemStyle-CssClass="text-secondary" />
                                        
                                        <asp:TemplateField HeaderText="标题">
                                            <ItemTemplate>
                                                <!-- 还原标题链接样式 -->
                                                <a href='<%# "problem.aspx?id=" + Eval("id") + "&isCompetition="+ GetCompetitionIdFromUrl() %>'
                                                    class="problem-link fw-medium">
                                                    <%# Eval("title") %>
                                                </a>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:TemplateField HeaderText="难度">
                                            <ItemTemplate>
                                                <!-- 还原难度徽章样式 -->
                                                <span class='difficulty-badge <%# GetDifficultyClass(Eval("difficulty").ToString()) %>'>
                                                    <%# Eval("difficulty") %>
                                                </span>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        
                                        <asp:BoundField DataField="time_memory_limit" HeaderText="时空限制"
                                            ItemStyle-CssClass="text-muted" />
                                        
                                        <asp:BoundField DataField="total_accepted" HeaderText="通过数"
                                            ItemStyle-CssClass="text-success fw-medium" />
                                    </Columns>
                                </asp:GridView>
                            </div>

                            <asp:Panel ID="pnlNoProblems" runat="server" Visible="false">
                                <div class="text-center py-5 bg-light">
                                    <i class="bi bi-folder-x fs-1 text-muted"></i>
                                    <p class="text-muted mt-3 mb-0">此比赛暂无题目</p>
                                </div>
                            </asp:Panel>
                        </div>
                    </div>

                    
                </div>
            </div>
        </div>

        <script>
            function showTab(tabName) {
                const tabs = {
                    problems: document.getElementById('tabProblems'),
                    leaderboard: document.getElementById('tabLeaderboard')
                };

                Object.values(tabs).forEach(tab => tab.style.display = 'none');
                tabs[tabName].style.display = 'block';

                document.querySelectorAll('.sidebar-btn').forEach(btn => {
                    btn.classList.remove('active');
                    if (btn.querySelector('i').classList.contains(tabName === 'problems' ? 'bi-list-task' : 'bi-trophy')) {
                        btn.classList.add('active');
                    }
                });
            }
        </script>
    </form>
</body>
</html>