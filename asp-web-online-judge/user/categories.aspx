<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="categories.aspx.cs" 
    Inherits="asp_web_online_judge.categories" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>题单列表</title>
    <!-- 引入 Bootstrap 样式 -->
    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        /* 自定义整体配色 */
        body {
            background-color: #f2f4f8;
            font-family: 'Segoe UI', sans-serif;
        }
        h1, h3 {
            color: #333;
        }

        /* 卡片样式 */
        .category-card {
            transition: transform 0.2s, box-shadow 0.2s;
            margin-bottom: 15px;
            border: none;
            border-radius: 8px;
            background-color: #fff;
        }
        .category-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
        }

        /* 网格布局 */
        .category-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }
        @media (max-width: 768px) {
            .category-grid {
                grid-template-columns: 1fr;
            }
        }

        /* 搜索框 */
        .search-box .form-control {
            border-radius: 30px;
            padding: 10px 20px;
        }
    </style>
</head>
<body>
    <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />

    <form id="form1" runat="server">
        <div class="container py-4">
            <h1 class="h3 mb-4">题单列表</h1>

            <!-- 搜索框 -->
            <div class="row mb-3 search-box">
                <div class="col-md-8">
                    <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control" Placeholder="搜索题单名称"></asp:TextBox>
                </div>
                <div class="col-md-4">
                    <asp:Button ID="btnSearch" runat="server" Text="搜索" CssClass="btn btn-primary" OnClick="btnSearch_Click" />
                </div>
            </div>

            <!-- 题单列表 -->
            <div class="category-grid">
                <asp:Repeater ID="rptCategories" runat="server">
                    <ItemTemplate>
                        <div class="card category-card">
                            <div class="card-body">
                                <h5 class="card-title">
                                    <a href='<%# "CategoryDetails.aspx?id=" + Eval("CategoryId") %>' class="text-decoration-none text-dark">
                                        <%# Eval("CategoryName") %>
                                    </a>
                                </h5>
                                <div class="d-flex justify-content-between">
                                    <span class="text-muted">#<%# Eval("CategoryId") %></span>
                                    <span class="badge bg-primary">题目：<%# Eval("ProblemCount") %></span>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <!-- 无数据提示 -->
            <asp:Panel ID="pnlNoData" runat="server" Visible="false">
                <div class="alert alert-warning mt-4">暂无题单</div>
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
