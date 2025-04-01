<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="leaderboard.aspx.cs" Inherits="asp_web_online_judge.leaderboard" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <title>排行榜</title>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet" />
</head>
<body>
        <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />

    <form id="form1" runat="server">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3" runat="server" id="h1Title"></h1>
                <!-- 修改为  表达式 -->
                <a href='<%= "competitions.aspx?id=" + Request.QueryString["id"] %>' class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> 返回比赛列表
                </a>
            </div>

            <!-- 排行榜 -->
            <asp:GridView ID="GridViewLeaderboard" runat="server" AutoGenerateColumns="false" CssClass="table table-hover" GridLines="None">
                <Columns>
                    <asp:BoundField DataField="account" HeaderText="用户名" />
                    <asp:BoundField DataField="total_problems_solved" HeaderText="通过题目数" />
                </Columns>
            </asp:GridView>
            <!-- 当没有数据时显示提示 -->
            <asp:Label ID="lblNoData" runat="server" Text="暂无数据" CssClass="text-muted" Visible="false"></asp:Label>
        </div>
    </form>
</body>
</html>

