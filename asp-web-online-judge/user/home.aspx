<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="asp_web_online_judge.home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="./css/home.css" rel="stylesheet" type="text/css"/>
    <title>Code Arena</title>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>Welcome to Code Arena Online Judge！</h1>
            </div>
            <div class="nav">
                <a href="login.aspx">登录</a>
                <a href="register.aspx">注册</a>
                <a href="categories.aspx">题单</a>
                <a href="rankings.aspx">排行榜</a>
            </div>
            <div class="content">
                <h2>热门题目</h2>
                <ul>
                    <li><a href="problem.aspx">LEVEL-1: 两数之和</a></li>
                    <li><a href="problem.aspx">LEVEL-2: 反转链表</a></li>
                    <li><a href="problem.aspx">LEVEL-3: 最长公共子序列</a></li>
                </ul>
            </div>
            <div class="footer">
                <p>&copy; 2025 Code Arena. All rights reserved.</p>
            </div>
        </div>
    </form>
</body>
</html>
