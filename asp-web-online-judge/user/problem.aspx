<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="problem.aspx.cs" Inherits="asp_web_online_judge.problem" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>算法竞赛题目</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .code-box {
            width: 100%;
            height: 200px;
            font-family: Consolas, monospace;
            font-size: 14px;
        }
        .submit-button {
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h1>题目名称: 两数之和</h1>
            <h2>题目描述</h2>
            <p>
                给定一个整数数组 `nums` 和一个目标值 `target`，请你在该数组中找出和为目标值的那两个整数，并返回它们的数组下标。
            </p>
            <p>
                你可以假设每种输入只会对应一个答案。但是，数组中同一个元素不能使用两遍。
            </p>

            <h2>样例</h2>
            <p><strong>输入:</strong> nums = [2, 7, 11, 15], target = 9</p>
            <p><strong>输出:</strong> [0, 1]</p>
            <p><strong>解释:</strong> 因为 nums[0] + nums[1] = 2 + 7 = 9，所以返回 [0, 1]。</p>

            <h2>代码框</h2>
            <asp:TextBox ID="CodeBox" runat="server" TextMode="MultiLine" CssClass="code-box"></asp:TextBox>

            <h2>提交</h2>
            <asp:Button ID="SubmitButton" runat="server" Text="提交代码" CssClass="submit-button" OnClick="SubmitButton_Click" />
        </div>
    </form>
</body>
</html>