<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="navBar.ascx.cs" Inherits="asp_web_online_judge.NavBar" %>
<div id="navbar" style="width:100%; background:#2a2a2a; padding:10px; overflow:hidden;">
    <!-- 左侧：平台名称，点击返回首页 -->
    <div style="float:left;">
        <a href="home.aspx" style="font-size:18px; font-weight:bold; text-decoration:none; color:#fff;">
            Code Arena Online Judge
        </a>
    </div>
    <!-- 右侧：欢迎信息，文字改为白色 -->
    <div style="float:right; color:#fff;">
        <asp:Literal ID="litUser" runat="server"></asp:Literal>
    </div>
</div>
