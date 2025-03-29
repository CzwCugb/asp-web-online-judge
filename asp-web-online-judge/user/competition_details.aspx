<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="competition_details.aspx.cs" 
    Inherits="asp_web_online_judge.competition_details" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>比赛详情</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        .difficulty-badge {
            font-size: 0.85em;
            min-width: 70px;
            display: inline-block;
            text-align: center;
        }
        .grid-header {
            background-color: #f8f9fa;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3" runat="server" id="h1Title"></h1>
                <a href="competitions.aspx" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> 返回比赛列表
                </a>
            </div>

            <!-- 当比赛不在有效时间内时显示提示 -->
            <asp:Panel ID="pnlNotActive" runat="server" Visible="false">
                <div class="alert alert-warning">当前比赛未开始或已结束，无法进入比赛！</div>
            </asp:Panel>

            <!-- 比赛题目列表 -->
            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="table table-hover"
                GridLines="None" HeaderStyle-CssClass="grid-header">
                <Columns>
                    <asp:TemplateField HeaderText="状态">
                        <ItemTemplate>
                            <%# GetSubmissionStatus(Eval("id"), Eval("SubmissionStatus")) %>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="id" HeaderText="#" 
                        HeaderStyle-CssClass="text-secondary" ItemStyle-Width="80"/>
                    <asp:TemplateField HeaderText="标题" HeaderStyle-CssClass="ps-3">
                        <ItemTemplate>
                            <a href='<%# "problem.aspx?id=" + Eval("id") + "&isCompetition=true" %>' 
                                class="text-decoration-none text-dark fw-medium">
                                <%# Eval("title") %>
                            </a>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="难度">
                        <ItemTemplate>
                            <span class='difficulty-badge badge <%# GetDifficultyClass(Eval("difficulty").ToString()) %>'>
                                <%# Eval("difficulty") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="time_memory_limit" HeaderText="时空限制" 
                        HeaderStyle-CssClass="text-nowrap" />
                    <asp:BoundField DataField="total_accepted" HeaderText="通过数" 
                        ItemStyle-CssClass="text-success fw-medium" />
                </Columns>
            </asp:GridView>

            <asp:Panel ID="pnlNoProblems" runat="server" Visible="false">
                <div class="alert alert-warning mt-4">此比赛暂无题目</div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>
