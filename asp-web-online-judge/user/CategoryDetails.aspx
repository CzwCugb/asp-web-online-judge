<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="CategoryDetails.aspx.cs" 
    Inherits="asp_web_online_judge.CategoryDetails" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>


<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>题单详情</title>
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
        <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />

    <form id="form1" runat="server">
        <div class="container py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h1 class="h3" runat="server" id="h1Title"></h1>
                <a href="categories.aspx" class="btn btn-outline-secondary">
                    <i class="bi bi-arrow-left"></i> 返回题单列表
                </a>
            </div>

            <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="false" CssClass="table table-hover"
                GridLines="None" HeaderStyle-CssClass="grid-header">
                <Columns>
                    <asp:BoundField DataField="id" HeaderText="#" 
                        HeaderStyle-CssClass="text-secondary" ItemStyle-Width="80"/>
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
            </asp:GridView>

            <asp:Panel ID="pnlNoProblems" runat="server" Visible="false">
                <div class="alert alert-warning mt-4">此题库暂无题目</div>
            </asp:Panel>
        </div>
    </form>
</body>
</html>