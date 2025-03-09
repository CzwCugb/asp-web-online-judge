<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="register.aspx.cs" Inherits="asp_web_online_judge.register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <link href="css/register.css" rel="stylesheet" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>注册</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>注册</h2>
            <asp:Label ID="lblMessage" runat="server" ForeColor="Red"></asp:Label><br />
            <div>
                用户名: 
                <asp:TextBox CssClass="textbox" ID="txtUsername" runat="server"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvUsername" runat="server" 
                    ControlToValidate="txtUsername"
                    ErrorMessage="必填" 
                    ForeColor="Red"
                    Display="Dynamic">
                </asp:RequiredFieldValidator>
            </div>
            <div>
                密码: 
                <asp:TextBox CssClass="textbox" ID="txtPassword" runat="server" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvPassword" runat="server" 
                    ControlToValidate="txtPassword"
                    ErrorMessage="必填" 
                    ForeColor="Red"
                    Display="Dynamic">
                </asp:RequiredFieldValidator>
            </div>
            <div>
                确认密码: 
                <asp:TextBox CssClass="textbox" ID="txtConfirm" runat="server" TextMode="Password"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvConfirm" runat="server" 
                    ControlToValidate="txtConfirm"
                    ErrorMessage="必填" 
                    ForeColor="Red"
                    Display="Dynamic">
                </asp:RequiredFieldValidator>
                <asp:CompareValidator ID="cvPassword" runat="server" 
                    ControlToValidate="txtConfirm"
                    ControlToCompare="txtPassword"
                    ErrorMessage="密码不一致" 
                    ForeColor="Red"
                    Display="Dynamic">
                </asp:CompareValidator>
            </div>
            <asp:Button ID="btnRegister" runat="server" Text="注册" OnClick="btnRegister_Click" /><br />
            <asp:HyperLink ID="lnkLogin" runat="server" NavigateUrl="login.aspx">已有账户？登录</asp:HyperLink>
        </div>
    </form>
</body>
</html>