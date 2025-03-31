<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="admin.aspx.cs" Inherits="YourNamespace.admin" %>
<!DOCTYPE html>
<html>
<head runat="server">
    <meta charset="utf-8" />
    <title>管理员界面</title>
    <link rel="stylesheet" type="text/css" href="css/admin.css" />
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <!-- 页头 -->
            <header class="header">
                <h2>管理员界面</h2>
                <div class="header-right">
                    <asp:Button ID="btnHome" runat="server" Text="返回首页" CssClass="btn" OnClick="btnHome_Click" />
                </div>
            </header>
            <!-- 顶部导航栏 -->
            <nav class="nav-buttons">
                <asp:LinkButton ID="lnkUsers" runat="server" CssClass="nav-link" OnClick="lnkUsers_Click">用户</asp:LinkButton>
                <asp:LinkButton ID="lnkProblems" runat="server" CssClass="nav-link" OnClick="lnkProblems_Click">题目</asp:LinkButton>
                <asp:LinkButton ID="lnkCategories" runat="server" CssClass="nav-link" OnClick="lnkCategories_Click">题单</asp:LinkButton>
                <asp:LinkButton ID="lnkCompetitions" runat="server" CssClass="nav-link" OnClick="lnkCompetitions_Click">比赛</asp:LinkButton>
            </nav>
            <!-- 主内容区 -->
            <div class="main-content">
                <asp:MultiView ID="MultiView1" runat="server" ActiveViewIndex="0">
                    <!-- View 0：用户概览 -->
                    <asp:View ID="viewUserOverview" runat="server">
                        <h3 class="text-center">用户库概览</h3>
                        <div class="search-panel">
                            <asp:TextBox ID="txtUserSearch" runat="server" CssClass="search-box" placeholder="请输入账号搜索"></asp:TextBox>
                            <asp:Button ID="btnUserSearch" runat="server" Text="搜索" CssClass="btn" OnClick="btnUserSearch_Click" />
                        </div>
                        <asp:GridView ID="gvUsers" runat="server" AutoGenerateColumns="False" DataKeyNames="id"
                            AllowPaging="true" PageSize="10" OnRowCommand="gv_RowCommand" OnRowCreated="gvUsers_RowCreated" CssClass="gridview">
                            <PagerTemplate>
                                <div class="GridViewPager">
                                    <asp:LinkButton ID="lnkPrev" runat="server" CommandName="Page" CssClass="pager-btn">上一页</asp:LinkButton>
                                    <asp:PlaceHolder ID="phNumeric" runat="server"></asp:PlaceHolder>
                                    <asp:LinkButton ID="lnkNext" runat="server" CommandName="Page" CssClass="pager-btn">下一页</asp:LinkButton>
                                </div>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="id" HeaderText="用户ID" ReadOnly="true" />
                                <asp:BoundField DataField="account" HeaderText="账号" />
                                <asp:BoundField DataField="email" HeaderText="电子邮件" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEditUser" runat="server" Text="编辑" 
                                            CommandName="EditUser" CommandArgument='<%# Eval("id") %>' CssClass="btn" />
                                        <asp:Button ID="btnDeleteUser" runat="server" Text="删除" 
                                            CommandName="DeleteUser" CommandArgument='<%# Eval("id") %>' CssClass="btn"
                                            OnClientClick="return confirm('确认删除?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Button ID="btnAddUser" runat="server" Text="添加用户" CssClass="btn" OnClick="btnAddUser_Click" />
                    </asp:View>

                    <!-- View 1：题目概览 -->
                    <asp:View ID="viewProblemOverview" runat="server">
                        <h3 class="text-center">题目概览</h3>
                        <div class="search-panel">
                            <asp:TextBox ID="txtProblemSearch" runat="server" CssClass="search-box" placeholder="请输入题目ID、标题或描述搜索"></asp:TextBox>
                            <asp:Button ID="btnProblemSearch" runat="server" Text="搜索" CssClass="btn" OnClick="btnProblemSearch_Click" />
                        </div>
                        <asp:GridView ID="gvProblems" runat="server" AutoGenerateColumns="False" DataKeyNames="id"
                            AllowPaging="true" PageSize="10" OnRowCommand="gv_RowCommand" OnRowCreated="gvProblems_RowCreated" CssClass="gridview">
                            <PagerTemplate>
                                <div class="GridViewPager">
                                    <asp:LinkButton ID="lnkPrev" runat="server" CommandName="Page" CssClass="pager-btn">上一页</asp:LinkButton>
                                    <asp:PlaceHolder ID="phNumeric" runat="server"></asp:PlaceHolder>
                                    <asp:LinkButton ID="lnkNext" runat="server" CommandName="Page" CssClass="pager-btn">下一页</asp:LinkButton>
                                </div>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="id" HeaderText="题目ID" ReadOnly="true" />
                                <asp:BoundField DataField="title" HeaderText="标题" />
                                <asp:TemplateField HeaderText="描述">
                                    <ItemTemplate>
                                        <%# Truncate(Eval("description").ToString(), 50) %>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="difficulty" HeaderText="难度" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEditProblem" runat="server" Text="编辑" 
                                            CommandName="EditProblem" CommandArgument='<%# Eval("id") %>' CssClass="btn" />
                                        <asp:Button ID="btnDeleteProblem" runat="server" Text="删除" 
                                            CommandName="DeleteProblem" CommandArgument='<%# Eval("id") %>' CssClass="btn"
                                            OnClientClick="return confirm('确认删除?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Button ID="btnAddProblem" runat="server" Text="添加题目" CssClass="btn" OnClick="btnAddProblem_Click" />
                    </asp:View>

                    <!-- View 2：题单（分类）概览 -->
                    <asp:View ID="viewCategoryOverview" runat="server">
                        <h3 class="text-center">题单概览</h3>
                        <div class="search-panel">
                            <asp:TextBox ID="txtCategorySearch" runat="server" CssClass="search-box" placeholder="请输入题单名称搜索"></asp:TextBox>
                            <asp:Button ID="btnCategorySearch" runat="server" Text="搜索" CssClass="btn" OnClick="btnCategorySearch_Click" />
                        </div>
                        <asp:GridView ID="gvCategories" runat="server" AutoGenerateColumns="False" DataKeyNames="category_id"
                            AllowPaging="true" PageSize="10" OnRowCommand="gv_RowCommand" OnRowCreated="gvCategories_RowCreated" CssClass="gridview">
                            <PagerTemplate>
                                <div class="GridViewPager">
                                    <asp:LinkButton ID="lnkPrev" runat="server" CommandName="Page" CssClass="pager-btn">上一页</asp:LinkButton>
                                    <asp:PlaceHolder ID="phNumeric" runat="server"></asp:PlaceHolder>
                                    <asp:LinkButton ID="lnkNext" runat="server" CommandName="Page" CssClass="pager-btn">下一页</asp:LinkButton>
                                </div>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="category_id" HeaderText="题单ID" ReadOnly="true" />
                                <asp:BoundField DataField="category_name" HeaderText="题单名称" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEditCategory" runat="server" Text="编辑" 
                                            CommandName="EditCategory" CommandArgument='<%# Eval("category_id") %>' CssClass="btn" />
                                        <asp:Button ID="btnDeleteCategory" runat="server" Text="删除" 
                                            CommandName="DeleteCategory" CommandArgument='<%# Eval("category_id") %>' CssClass="btn"
                                            OnClientClick="return confirm('确认删除?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Button ID="btnAddCategory" runat="server" Text="添加题单" CssClass="btn" OnClick="btnAddCategory_Click" />
                    </asp:View>

                    <!-- View 3：比赛概览 -->
                    <asp:View ID="viewCompetitionOverview" runat="server">
                        <h3 class="text-center">比赛概览</h3>
                        <div class="search-panel">
                            <asp:TextBox ID="txtCompetitionSearch" runat="server" CssClass="search-box" placeholder="请输入比赛名称搜索"></asp:TextBox>
                            <asp:Button ID="btnCompetitionSearch" runat="server" Text="搜索" CssClass="btn" OnClick="btnCompetitionSearch_Click" />
                        </div>
                        <asp:GridView ID="gvCompetitions" runat="server" AutoGenerateColumns="False" DataKeyNames="competition_id"
                            AllowPaging="true" PageSize="10" OnRowCommand="gv_RowCommand" OnRowCreated="gvCompetitions_RowCreated" CssClass="gridview">
                            <PagerTemplate>
                                <div class="GridViewPager">
                                    <asp:LinkButton ID="lnkPrev" runat="server" CommandName="Page" CssClass="pager-btn">上一页</asp:LinkButton>
                                    <asp:PlaceHolder ID="phNumeric" runat="server"></asp:PlaceHolder>
                                    <asp:LinkButton ID="lnkNext" runat="server" CommandName="Page" CssClass="pager-btn">下一页</asp:LinkButton>
                                </div>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="competition_id" HeaderText="比赛ID" ReadOnly="true" />
                                <asp:BoundField DataField="competition_name" HeaderText="比赛名称" />
                                <asp:BoundField DataField="start_time" HeaderText="开始时间" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                                <asp:BoundField DataField="end_time" HeaderText="结束时间" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEditCompetition" runat="server" Text="编辑" 
                                            CommandName="EditCompetition" CommandArgument='<%# Eval("competition_id") %>' CssClass="btn" />
                                        <asp:Button ID="btnDeleteCompetition" runat="server" Text="删除" 
                                            CommandName="DeleteCompetition" CommandArgument='<%# Eval("competition_id") %>' CssClass="btn"
                                            OnClientClick="return confirm('确认删除?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Button ID="btnAddCompetition" runat="server" Text="添加比赛" CssClass="btn" OnClick="btnAddCompetition_Click" />
                    </asp:View>

                    <!-- View 4：用户详细编辑 -->
                    <asp:View ID="viewUserDetail" runat="server">
                        <h3 class="text-center">编辑用户</h3>
                        <asp:Panel ID="pnlUserDetail" runat="server">
                            <p>
                                <asp:Label ID="lblUserId" runat="server" Text="用户ID: " Font-Bold="true"></asp:Label>
                                <asp:Label ID="lblUserIdValue" runat="server" Text=""></asp:Label>
                            </p>
                            <p>
                                <asp:Label ID="lblAccount" runat="server" Text="账号: "></asp:Label>
                                <asp:TextBox ID="txtAccount" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblPassword" runat="server" Text="密码: "></asp:Label>
                                <asp:TextBox ID="txtPassword" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblEmail" runat="server" Text="电子邮件: "></asp:Label>
                                <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Button ID="btnSaveUser" runat="server" Text="保存" CssClass="btn" OnClick="btnSaveUser_Click" />
                                <asp:Button ID="btnCancelUser" runat="server" Text="返回概览" CssClass="btn" OnClick="btnCancel_Click" />
                            </p>
                        </asp:Panel>
                    </asp:View>

                    <!-- View 5：题目详细编辑 -->
                    <asp:View ID="viewProblemDetail" runat="server">
                        <h3 class="text-center">编辑题目</h3>
                        <asp:Panel ID="pnlProblemDetail" runat="server">
                            <p>
                                <asp:Label ID="lblProblemId" runat="server" Text="题目ID: " Font-Bold="true"></asp:Label>
                                <asp:Label ID="lblProblemIdValue" runat="server" Text=""></asp:Label>
                            </p>
                            <p>
                                <asp:Label ID="lblTitle" runat="server" Text="标题: "></asp:Label>
                                <asp:TextBox ID="txtTitle" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblDescription" runat="server" Text="描述: "></asp:Label>
                                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="5" Columns="50"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblDifficulty" runat="server" Text="难度: "></asp:Label>
                                <asp:TextBox ID="txtDifficulty" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblTimeMemory" runat="server" Text="时/内存限制: "></asp:Label>
                                <asp:TextBox ID="txtTimeMemory" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblTotalAccepted" runat="server" Text="总通过数: "></asp:Label>
                                <asp:TextBox ID="txtTotalAccepted" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblTotalAttempted" runat="server" Text="总尝试数: "></asp:Label>
                                <asp:TextBox ID="txtTotalAttempted" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblAlgorithmTags" runat="server" Text="算法标签: "></asp:Label>
                                <asp:TextBox ID="txtAlgorithmTags" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Button ID="btnSaveProblem" runat="server" Text="保存" CssClass="btn" OnClick="btnSaveProblem_Click" />
                                <asp:Button ID="btnCancelProblem" runat="server" Text="返回概览" CssClass="btn" OnClick="btnCancel_Click" />
                            </p>
                        </asp:Panel>
                    </asp:View>

                    <!-- View 6：题单详细编辑 -->
                    <asp:View ID="viewCategoryDetail" runat="server">
                        <h3 class="text-center">编辑题单</h3>
                        <asp:Panel ID="pnlCategoryDetail" runat="server">
                            <p>
                                <asp:Label ID="lblCategoryId" runat="server" Text="题单ID: " Font-Bold="true"></asp:Label>
                                <asp:Label ID="lblCategoryIdValue" runat="server" Text=""></asp:Label>
                            </p>
                            <p>
                                <asp:Label ID="lblCategoryName" runat="server" Text="题单名称: "></asp:Label>
                                <asp:TextBox ID="txtCategoryName" runat="server"></asp:TextBox>
                            </p>
                            <!-- 新增关联题目的输入控件 -->
                            <p>
                                <asp:Label ID="lblCategoryProblems" runat="server" Text="关联题目 (逗号分隔题目ID): "></asp:Label>
                                <asp:TextBox ID="txtCategoryProblems" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Button ID="btnSaveCategory" runat="server" Text="保存" CssClass="btn" OnClick="btnSaveCategory_Click" />
                                <asp:Button ID="btnCancelCategory" runat="server" Text="返回概览" CssClass="btn" OnClick="btnCancel_Click" />
                            </p>
                        </asp:Panel>
                    </asp:View>

                    <!-- View 7：比赛详细编辑 -->
                    <asp:View ID="viewCompetitionDetail" runat="server">
                        <h3 class="text-center">编辑比赛</h3>
                        <asp:Panel ID="pnlCompetitionDetail" runat="server">
                            <p>
                                <asp:Label ID="lblCompetitionId" runat="server" Text="比赛ID: " Font-Bold="true"></asp:Label>
                                <asp:Label ID="lblCompetitionIdValue" runat="server" Text=""></asp:Label>
                            </p>
                            <p>
                                <asp:Label ID="lblCompetitionName" runat="server" Text="比赛名称: "></asp:Label>
                                <asp:TextBox ID="txtCompetitionName" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblStartTime" runat="server" Text="开始时间: "></asp:Label>
                                <asp:TextBox ID="txtStartTime" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Label ID="lblEndTime" runat="server" Text="结束时间: "></asp:Label>
                                <asp:TextBox ID="txtEndTime" runat="server"></asp:TextBox>
                            </p>
                            <!-- 新增关联题目的输入控件 -->
                            <p>
                                <asp:Label ID="lblCompetitionProblems" runat="server" Text="关联题目 (逗号分隔题目ID): "></asp:Label>
                                <asp:TextBox ID="txtCompetitionProblems" runat="server"></asp:TextBox>
                            </p>
                            <p>
                                <asp:Button ID="btnSaveCompetition" runat="server" Text="保存" CssClass="btn" OnClick="btnSaveCompetition_Click" />
                                <asp:Button ID="btnCancelCompetition" runat="server" Text="返回概览" CssClass="btn" OnClick="btnCancel_Click" />
                            </p>
                        </asp:Panel>
                    </asp:View>

                    <!-- View 8：题单概览编辑 -->
                    <asp:View ID="view1" runat="server">
                        <h3 class="text-center">题单概览</h3>
                        <div class="search-panel">
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="search-box" placeholder="请输入题单名称搜索"></asp:TextBox>
                            <asp:Button ID="Button1" runat="server" Text="搜索" CssClass="btn" OnClick="btnCategorySearch_Click" />
                        </div>
                        <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataKeyNames="category_id"
                            AllowPaging="true" PageSize="10" OnRowCommand="gv_RowCommand" OnRowCreated="gvCategories_RowCreated" CssClass="gridview">
                            <PagerTemplate>
                                <div class="GridViewPager">
                                    <asp:LinkButton ID="lnkPrev" runat="server" CommandName="Page" CssClass="pager-btn">上一页</asp:LinkButton>
                                    <asp:PlaceHolder ID="phNumeric" runat="server"></asp:PlaceHolder>
                                    <asp:LinkButton ID="lnkNext" runat="server" CommandName="Page" CssClass="pager-btn">下一页</asp:LinkButton>
                                </div>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="category_id" HeaderText="题单ID" ReadOnly="true" />
                                <asp:BoundField DataField="category_name" HeaderText="题单名称" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEditCategory" runat="server" Text="编辑" 
                                            CommandName="EditCategory" CommandArgument='<%# Eval("category_id") %>' CssClass="btn" />
                                        <asp:Button ID="btnDeleteCategory" runat="server" Text="删除" 
                                            CommandName="DeleteCategory" CommandArgument='<%# Eval("category_id") %>' CssClass="btn"
                                            OnClientClick="return confirm('确认删除?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Button ID="Button2" runat="server" Text="添加题单" CssClass="btn" OnClick="btnAddCategory_Click" />
                    </asp:View>

                    <!-- View 9：比赛概览 -->
                    <asp:View ID="view2" runat="server">
                        <h3 class="text-center">比赛概览</h3>
                        <div class="search-panel">
                            <asp:TextBox ID="TextBox2" runat="server" CssClass="search-box" placeholder="请输入比赛名称搜索"></asp:TextBox>
                            <asp:Button ID="Button3" runat="server" Text="搜索" CssClass="btn" OnClick="btnCompetitionSearch_Click" />
                        </div>
                        <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" DataKeyNames="competition_id"
                            AllowPaging="true" PageSize="10" OnRowCommand="gv_RowCommand" OnRowCreated="gvCompetitions_RowCreated" CssClass="gridview">
                            <PagerTemplate>
                                <div class="GridViewPager">
                                    <asp:LinkButton ID="lnkPrev" runat="server" CommandName="Page" CssClass="pager-btn">上一页</asp:LinkButton>
                                    <asp:PlaceHolder ID="phNumeric" runat="server"></asp:PlaceHolder>
                                    <asp:LinkButton ID="lnkNext" runat="server" CommandName="Page" CssClass="pager-btn">下一页</asp:LinkButton>
                                </div>
                            </PagerTemplate>
                            <Columns>
                                <asp:BoundField DataField="competition_id" HeaderText="比赛ID" ReadOnly="true" />
                                <asp:BoundField DataField="competition_name" HeaderText="比赛名称" />
                                <asp:BoundField DataField="start_time" HeaderText="开始时间" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                                <asp:BoundField DataField="end_time" HeaderText="结束时间" DataFormatString="{0:yyyy-MM-dd HH:mm:ss}" />
                                <asp:TemplateField HeaderText="操作">
                                    <ItemTemplate>
                                        <asp:Button ID="btnEditCompetition" runat="server" Text="编辑" 
                                            CommandName="EditCompetition" CommandArgument='<%# Eval("competition_id") %>' CssClass="btn" />
                                        <asp:Button ID="btnDeleteCompetition" runat="server" Text="删除" 
                                            CommandName="DeleteCompetition" CommandArgument='<%# Eval("competition_id") %>' CssClass="btn"
                                            OnClientClick="return confirm('确认删除?');" />
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <asp:Button ID="Button4" runat="server" Text="添加比赛" CssClass="btn" OnClick="btnAddCompetition_Click" />
                    </asp:View>
                </asp:MultiView>
            </div>
        </div>
    </form>
</body>
</html>
