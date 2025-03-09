<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="login.aspx.cs" Inherits="asp_web_online_judge.login" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="css/login.css" rel="stylesheet" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>登录</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>登录</h2>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label><br />
            <div>用户名: <asp:TextBox CssClass="textbox" ID="txtUsername" runat="server"></asp:TextBox></div>
            <div>密码: <asp:TextBox CssClass="textbox" ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox></div>
            <asp:Button ID="btnLogin" runat="server" Text="登录" OnClick="btnLogin_Click" /><br />
            <asp:HyperLink ID="lnkRegister" runat="server" NavigateUrl="register.aspx">注册新账户</asp:HyperLink>
        </div>
    </form>
</body>
</html>