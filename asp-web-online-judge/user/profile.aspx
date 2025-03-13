<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="profile.aspx.cs" Inherits="asp_web_online_judge.profile" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <link href="./css/navbar-fixed-top.css" rel="stylesheet" type="text/css"/>
    <link href="./css/profile.css" rel="stylesheet" type="text/css"/>
</head>
<body>
    <form id="form1" runat="server">

        <nav class = "navbar-fixed-top container-center nav" style = "z-index : 10;">
            <div class="header child-center text-center title-head">
                <h1>Welcome to Code Arena Online Judge！</h1>
            </div>
            <div class="nav child-center text-center son-a-center head-list">
                <div id = "login_register" runat="server"> </div>
                <a href="categories.aspx">题单</a>
                <a href="rankings.aspx">排行榜</a>
            </div>
        </nav>

        <div class = "main-page">
            <h2>👤 个人信息</h2>
            <p>
                <strong>用户名：</strong>
                <asp:Label ID="lblUsername" runat="server" CssClass="info-value" />
            </p>
            <p>
                <strong>邮箱：</strong>
                <asp:Label ID="lblEmail" runat="server" CssClass="info-value" />
            </p>
            <p>
                <strong>注册日期：</strong>
                <asp:Label ID="lblRegDate" runat="server" CssClass="info-value" />
            </p>
        </div>
    </form>
</body>
</html>
