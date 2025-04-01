<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="competitions.aspx.cs" 
    Inherits="asp_web_online_judge.competitions" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>比赛列表</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        .competition-card { transition: transform 0.2s; }
        .competition-card:hover { transform: translateY(-3px); }
    </style>
</head>
<body>
        <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />
    <form id="form1" runat="server">
        <div class="container py-4">
            <h1 class="h3 mb-4">比赛列表</h1>

            <!-- 搜索框 -->
            <div class="row mb-3">
                <div class="col-md-8">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="搜索比赛名称"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                </div>
            </div>

            <!-- 比赛列表 -->
            <asp:Repeater ID="rptCompetitions" runat="server">
                <ItemTemplate>
                    <div class="card mb-3 competition-card">
                        <div class="card-body">
                            <h5 class="card-title">
                                <%-- 如果当前时间不在比赛时间内，则不允许进入比赛详情页，可以通过禁用链接或显示提示 --%>
                                <%# IsCompetitionActive(Eval("StartTime"), Eval("EndTime")) 
                                    ? $"<a href='competition_details.aspx?id={Eval("CompetitionId")}' class='text-decoration-none'>{Eval("CompetitionName")}</a>"
                                    : $"<span class='text-muted'>{Eval("CompetitionName")} (未开始或已结束)</span>" %>
                            </h5>
                            <div class="d-flex justify-content-between">
                                <span class="text-muted">ID：<%# Eval("CompetitionId") %></span>
                                <span>开始：<%# Convert.ToDateTime(Eval("StartTime")).ToString("yyyy-MM-dd HH:mm") %></span>
                                <span>结束：<%# Convert.ToDateTime(Eval("EndTime")).ToString("yyyy-MM-dd HH:mm") %></span>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <!-- 无数据提示 -->
            <asp:Panel ID="pnlNoData" runat="server" Visible="false">
                <div class="alert alert-warning">暂无比赛</div>
            </asp:Panel>

            <!-- 分页控件 -->
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <asp:Repeater ID="rptPagination" runat="server">
                        <ItemTemplate>
                            <li class='page-item <%# ((ListItem)Container.DataItem).Selected ? "active" : "" %>'>
                                <a class="page-link" href='<%# ((ListItem)Container.DataItem).Value %>'>
                                    <%# ((ListItem)Container.DataItem).Text %>
                                </a>
                            </li>
                        </ItemTemplate>
                    </asp:Repeater>
                </ul>
            </nav>
        </div>
    </form>
</body>
</html>
