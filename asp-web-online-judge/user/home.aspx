<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="home.aspx.cs" Inherits="asp_web_online_judge.home" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <link href="./css/home.css" rel="stylesheet" type="text/css"/>
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .problem-card { 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        .table-hover tbody tr { transition: all 0.2s ease; }
        .difficulty-badge { padding: 0.25em 0.6em; font-size: 0.85em; }
    </style>
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

            <div class="container py-4">
                <div class="problem-card bg-white p-4 mb-4">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <h2 class="mb-0">题目列表</h2>
                        <span class="text-muted">共<%= GridView1.Rows.Count %>题</span>
                    </div>
                    <asp:GridView ID="GridView1" runat="server"
                        CssClass="table table-hover align-middle mb-0"
                        AutoGenerateColumns="False"
                        GridLines="None">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="#" 
                                HeaderStyle-CssClass="text-secondary" />
                            <asp:TemplateField HeaderText="标题" HeaderStyle-CssClass="ps-3">
                                <ItemTemplate>
                                    <a href='problem.aspx?id=<%# Eval("id") %>' 
                                        class="text-decoration-none text-dark fw-medium">
                                        <%# Eval("title") %>
                                    </a>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="难度">
                                <ItemTemplate>
                                    <span class='difficulty-badge badge 
                                        <%# GetDifficultyClass(Eval("difficulty").ToString()) %>'>
                                        <%# Eval("difficulty") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="time_memory_limit" HeaderText="时空限制" 
                                HeaderStyle-CssClass="text-nowrap" />
                            <asp:BoundField DataField="total_accepted" HeaderText="通过数" 
                                ItemStyle-CssClass="text-success fw-medium" />
                        </Columns>
                        <HeaderStyle CssClass="border-bottom" />
                    </asp:GridView>
                </div>
            </div>

            <div class="footer">
                <p>&copy; 2025 Code Arena. All rights reserved.</p>
            </div>
        </div>
    </form>
</body>
</html>
