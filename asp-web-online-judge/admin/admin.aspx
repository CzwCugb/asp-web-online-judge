<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="YourNamespace.admin" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>管理员后台</title>
    <!-- 引用css/admin.css -->
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
    <meta http-equiv="Content-Type" content="text/html;charset=utf-8"/>
</head>
<body>
    <form id="form1" runat="server">

    <!-- 主容器 -->
    <div class="container">
        <!-- 页头 -->
        <div class="header">
            <h1>管理员后台</h1>
            <div class="header-right">
                <asp:Button ID="btnHome" runat="server" Text="返回首页" OnClick="btnHome_Click" CssClass="btn" />
            </div>
        </div>

        <!-- 导航栏按钮区 -->
        <div class="nav-buttons">
            <asp:LinkButton ID="lnkUsers" runat="server" OnClick="lnkUsers_Click" CssClass="nav-link">用户管理</asp:LinkButton>
            <asp:LinkButton ID="lnkProblems" runat="server" OnClick="lnkProblems_Click" CssClass="nav-link">题目管理</asp:LinkButton>
            <asp:LinkButton ID="lnkCategories" runat="server" OnClick="lnkCategories_Click" CssClass="nav-link">题单管理</asp:LinkButton>
            <asp:LinkButton ID="lnkCompetitions" runat="server" OnClick="lnkCompetitions_Click" CssClass="nav-link">比赛管理</asp:LinkButton>
        </div>

        <!-- 主内容区 -->
        <div class="main-content">
            <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">

                <!-- 用户总览视图 -->
                <asp:View ID="viewUserOverview" runat="server">
                    <h2>用户管理</h2>
                    
                    <div class="search-panel">
                        <asp:TextBox ID="txtUserSearch" runat="server" CssClass="search-box"></asp:TextBox>
                        <asp:Button ID="btnUserSearch" runat="server" Text="搜索" OnClick="btnUserSearch_Click" CssClass="btn" />
                        <asp:Button ID="btnAddUser" runat="server" Text="添加新用户" OnClick="btnAddUser_Click" CssClass="btn" />
                    </div>

                    <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" OnRowCommand="gv_RowCommand"
                                  CssClass="gridview">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="ID" />
                            <asp:BoundField DataField="account" HeaderText="账户" />
                            <asp:BoundField DataField="email" HeaderText="邮箱" />
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditUser" runat="server"
                                        CommandName="EditUser"
                                        CommandArgument='<%# Eval("id") %>'>编辑</asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton ID="lnkDeleteUser" runat="server"
                                        CommandName="DeleteUser"
                                        CommandArgument='<%# Eval("id") %>'
                                        OnClientClick="return confirm('确定删除该用户吗？');">删除</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <!-- 手动分页链接 (用户) -->
                    <div class="GridViewPager">
                        <asp:Repeater ID="rptUserPagination" runat="server">
                            <ItemTemplate>
                                <!-- 这里使用 ListItem.Value 作为 href -->
                                <a href='<%# Eval("Value") %>' 
                                   style='<%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Selected ? "font-weight:bold;" : "" %>'>
                                    <%# Eval("Text") %>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:View>

                <!-- 用户编辑视图 -->
                <asp:View ID="viewUserDetail" runat="server">
                    <h2>编辑用户</h2>
                    <p>
                        <label>用户ID:</label>
                        <asp:Label ID="lblUserIdValue" runat="server" Text="0"></asp:Label>
                    </p>
                    <p>
                        <label>账号:</label>
                        <asp:TextBox ID="txtAccount" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>密码:</label>
                        <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>邮箱:</label>
                        <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                    </p>
                    <asp:Button ID="btnSaveUser" runat="server" Text="保存" OnClick="btnSaveUser_Click" CssClass="btn" />
                    <asp:Button ID="btnCancelUser" runat="server" Text="取消" OnClick="btnCancel_Click" CssClass="btn" />
                </asp:View>

                <!-- 题目总览视图 -->
                <asp:View ID="viewProblemOverview" runat="server">
                    <h2>题目管理</h2>

                    <div class="search-panel">
                        <asp:TextBox ID="txtProblemSearch" runat="server" CssClass="search-box"></asp:TextBox>
                        <asp:Button ID="btnProblemSearch" runat="server" Text="搜索" OnClick="btnProblemSearch_Click" CssClass="btn" />
                        <asp:Button ID="btnAddProblem" runat="server" Text="添加新题目" OnClick="btnAddProblem_Click" CssClass="btn" />
                    </div>

                    <asp:GridView ID="gvProblems" runat="server" AutoGenerateColumns="False" OnRowCommand="gv_RowCommand"
                                  CssClass="gridview">
                        <Columns>
                            <asp:BoundField DataField="id" HeaderText="ID" />
                            <asp:BoundField DataField="title" HeaderText="标题" />
                            <asp:BoundField DataField="difficulty" HeaderText="难度" />
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditProblem" runat="server"
                                        CommandName="EditProblem"
                                        CommandArgument='<%# Eval("id") %>'>编辑</asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton ID="lnkDeleteProblem" runat="server"
                                        CommandName="DeleteProblem"
                                        CommandArgument='<%# Eval("id") %>'
                                        OnClientClick="return confirm('确定删除该题目吗？');">删除</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="GridViewPager">
                        <asp:Repeater ID="rptProblemPagination" runat="server">
                            <ItemTemplate>
                                <a href='<%# Eval("Value") %>' 
                                   style='<%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Selected ? "font-weight:bold;" : "" %>'>
                                    <%# Eval("Text") %>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:View>

                <!-- 题目编辑视图 -->
                <asp:View ID="viewProblemDetail" runat="server">
                    <h2>编辑题目</h2>
                    <p>
                        <label>题目ID:</label>
                        <asp:Label ID="lblProblemIdValue" runat="server" Text="0"></asp:Label>
                    </p>
                    <p>
                        <label>标题:</label>
                        <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>描述:</label>
                        <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="4"></asp:TextBox>
                    </p>
                    <p>
                        <label>难度:</label>
                        <asp:TextBox ID="txtDifficulty" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>时空限制:</label>
                        <asp:TextBox ID="txtTimeMemory" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>通过次数:</label>
                        <asp:TextBox ID="txtTotalAccepted" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>提交次数:</label>
                        <asp:TextBox ID="txtTotalAttempted" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>标签:</label>
                        <asp:TextBox ID="txtAlgorithmTags" runat="server"></asp:TextBox>
                    </p>
                    <asp:Button ID="btnSaveProblem" runat="server" Text="保存" OnClick="btnSaveProblem_Click" CssClass="btn" />
                    <asp:Button ID="btnCancelProblem" runat="server" Text="取消" OnClick="btnCancel_Click" CssClass="btn" />
                </asp:View>

                <!-- 题单(分类)总览视图 -->
                <asp:View ID="viewCategoryOverview" runat="server">
                    <h2>题单管理</h2>

                    <div class="search-panel">
                        <asp:TextBox ID="txtCategorySearch" runat="server" CssClass="search-box"></asp:TextBox>
                        <asp:Button ID="btnCategorySearch" runat="server" Text="搜索" OnClick="btnCategorySearch_Click" CssClass="btn" />
                        <asp:Button ID="btnAddCategory" runat="server" Text="添加新题单" OnClick="btnAddCategory_Click" CssClass="btn" />
                    </div>

                    <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" OnRowCommand="gv_RowCommand"
                                  CssClass="gridview">
                        <Columns>
                            <asp:BoundField DataField="category_id" HeaderText="ID" />
                            <asp:BoundField DataField="category_name" HeaderText="题单名称" />
                            <asp:BoundField DataField="created_at" HeaderText="创建时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditCategory" runat="server"
                                        CommandName="EditCategory"
                                        CommandArgument='<%# Eval("category_id") %>'>编辑</asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton ID="lnkDeleteCategory" runat="server"
                                        CommandName="DeleteCategory"
                                        CommandArgument='<%# Eval("category_id") %>'
                                        OnClientClick="return confirm('确定删除该题单吗？');">删除</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="GridViewPager">
                        <asp:Repeater ID="rptCategoryPagination" runat="server">
                            <ItemTemplate>
                                <a href='<%# Eval("Value") %>' 
                                   style='<%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Selected ? "font-weight:bold;" : "" %>'>
                                    <%# Eval("Text") %>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:View>

                <!-- 题单(分类)编辑视图 -->
                <asp:View ID="viewCategoryDetail" runat="server">
                    <h2>编辑题单</h2>
                    <p>
                        <label>题单ID:</label>
                        <asp:Label ID="lblCategoryIdValue" runat="server" Text="0"></asp:Label>
                    </p>
                    <p>
                        <label>题单名称:</label>
                        <asp:TextBox ID="txtCategoryName" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>关联题目ID(逗号分隔):</label>
                        <asp:TextBox ID="txtCategoryProblems" runat="server"></asp:TextBox>
                    </p>
                    <asp:Button ID="btnSaveCategory" runat="server" Text="保存" OnClick="btnSaveCategory_Click" CssClass="btn" />
                    <asp:Button ID="btnCancelCategory" runat="server" Text="取消" OnClick="btnCancel_Click" CssClass="btn" />
                </asp:View>

                <!-- 比赛总览视图 -->
                <asp:View ID="viewCompetitionOverview" runat="server">
                    <h2>比赛管理</h2>

                    <div class="search-panel">
                        <asp:TextBox ID="txtCompetitionSearch" runat="server" CssClass="search-box"></asp:TextBox>
                        <asp:Button ID="btnCompetitionSearch" runat="server" Text="搜索" OnClick="btnCompetitionSearch_Click" CssClass="btn" />
                        <asp:Button ID="btnAddCompetition" runat="server" Text="添加新比赛" OnClick="btnAddCompetition_Click" CssClass="btn" />
                    </div>

                    <asp:GridView ID="gvCompetitions" runat="server" AutoGenerateColumns="False" OnRowCommand="gv_RowCommand"
                                  CssClass="gridview">
                        <Columns>
                            <asp:BoundField DataField="competition_id" HeaderText="ID" />
                            <asp:BoundField DataField="competition_name" HeaderText="比赛名称" />
                            <asp:BoundField DataField="start_time" HeaderText="开始时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            <asp:BoundField DataField="end_time" HeaderText="结束时间" DataFormatString="{0:yyyy-MM-dd HH:mm}" />
                            <asp:TemplateField HeaderText="操作">
                                <ItemTemplate>
                                    <asp:LinkButton ID="lnkEditCompetition" runat="server"
                                        CommandName="EditCompetition"
                                        CommandArgument='<%# Eval("competition_id") %>'>编辑</asp:LinkButton>
                                    &nbsp;
                                    <asp:LinkButton ID="lnkDeleteCompetition" runat="server"
                                        CommandName="DeleteCompetition"
                                        CommandArgument='<%# Eval("competition_id") %>'
                                        OnClientClick="return confirm('确定删除该比赛吗？');">删除</asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>

                    <div class="GridViewPager">
                        <asp:Repeater ID="rptCompetitionPagination" runat="server">
                            <ItemTemplate>
                                <a href='<%# Eval("Value") %>' 
                                   style='<%# ((System.Web.UI.WebControls.ListItem)Container.DataItem).Selected ? "font-weight:bold;" : "" %>'>
                                    <%# Eval("Text") %>
                                </a>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </asp:View>

                <!-- 比赛编辑视图 -->
                <asp:View ID="viewCompetitionDetail" runat="server">
                    <h2>编辑比赛</h2>
                    <p>
                        <label>比赛ID:</label>
                        <asp:Label ID="lblCompetitionIdValue" runat="server" Text="0"></asp:Label>
                    </p>
                    <p>
                        <label>比赛名称:</label>
                        <asp:TextBox ID="txtCompetitionName" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>开始时间:</label>
                        <asp:TextBox ID="txtStartTime" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>结束时间:</label>
                        <asp:TextBox ID="txtEndTime" runat="server"></asp:TextBox>
                    </p>
                    <p>
                        <label>关联题目ID(逗号分隔):</label>
                        <asp:TextBox ID="txtCompetitionProblems" runat="server"></asp:TextBox>
                    </p>
                    <asp:Button ID="btnSaveCompetition" runat="server" Text="保存" OnClick="btnSaveCompetition_Click" CssClass="btn" />
                    <asp:Button ID="btnCancelCompetition" runat="server" Text="取消" OnClick="btnCancel_Click" CssClass="btn" />
                </asp:View>

            </asp:MultiView>
        </div><!-- main-content -->

    </div><!-- container -->

    </form>
</body>
</html>
