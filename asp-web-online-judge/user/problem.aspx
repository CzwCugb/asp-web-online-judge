﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="problem.aspx.cs" Inherits="asp_web_online_judge.problem" ValidateRequest="false" %>
<%@ Register Src="~/user/NavBar.ascx" TagPrefix="uc" TagName="NavBar" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title id="title" runat="server">算法竞赛题目</title>
    <link href="./css/problem.css" rel="stylesheet" type="text/css"/>
    
    <!-- 字体库 -->
    <link href="https://fonts.googleapis.com/css2?family=Fira+Code:wght@400;500&family=Inter:wght@400;500;600&display=swap" rel="stylesheet">

    <!-- MathJax 数学公式支持 -->
    <script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
    <script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>

    <!-- CodeMirror 资源 -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/theme/monokai.min.css"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/codemirror.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/clike/clike.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/codemirror/5.65.2/mode/python/python.min.js"></script>

    <link href="https://cdn.bootcdn.net/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <!-- 导航栏控件 -->
    <uc:NavBar ID="navBar" runat="server" />
    <div style="height: 30px;"></div>
    <form id="form1" runat="server">
        <div class="code-section">
            <h3>代码提交</h3>
            
            <!-- 语言选择器 -->
            <select id="languageSelector" class="language-selector" runat="server">
                <option value="c/c++">C/C++</option>
                <option value="python">Python</option>
            </select>

            <!-- 隐藏的原始文本框 -->
            <asp:TextBox 
                ID="CodeBox" 
                runat="server" 
                TextMode="MultiLine" 
                style="display: none;"
                ></asp:TextBox>
            
            <!-- 代码编辑器容器 -->
            <div id="codeEditorWrapper">
                <div id="codeEditor"></div>
            </div>

            <!-- 提交按钮 -->
            <asp:Button 
                ID="SubmitButton" 
                runat="server" 
                Text="提交代码" 
                CssClass="submit-button" 
                OnClick="SubmitButton_Click"
                OnClientClick="syncCode()" />
        </div>
        <div>
            <asp:Label id="debug_label" runat="server" />
        </div>
    </form>
    <script>
        // 初始化代码编辑器
        var editor = CodeMirror(document.getElementById('codeEditor'), {
            lineNumbers: true,
            theme: 'monokai',
            mode: 'text/x-csrc',
            indentUnit: 4,
            smartIndent: true,
            matchBrackets: true,
            autoCloseBrackets: true,
            lineWrapping: true,
            gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],
            foldGutter: true,
            extraKeys: {
                "Ctrl-Space": "autocomplete",
                "Ctrl-S": function (cm) {
                    syncCode();
                    document.getElementById('<%= SubmitButton.ClientID %>').click();
        },
        "F11": function (cm) {
            cm.setOption("fullScreen", !cm.getOption("fullScreen"));
        },
        "Esc": function (cm) {
            if (cm.getOption("fullScreen")) cm.setOption("fullScreen", false);
        }
    }
});

// 语言切换功能
document.getElementById('languageSelector').addEventListener('change', function () {
    editor.setOption('mode', this.value);
    editor.focus();
});

// 同步编辑器内容到隐藏的TextBox
function syncCode() {
    document.getElementById('<%= CodeBox.ClientID %>').value = editor.getValue();
        }

        // 初始化编辑器内容
        window.addEventListener('DOMContentLoaded', function () {
            var initialCode = document.getElementById('<%= CodeBox.ClientID %>').value;
    editor.setValue(initialCode || '// 在这里输入你的代码...');
    editor.refresh();

    // 添加编辑器加载动画
    setTimeout(() => {
        editor.getWrapperElement().style.opacity = '1';
        editor.getWrapperElement().style.transform = 'translateY(0)';
    }, 100);
});

        // 窗口大小变化时刷新编辑器
        let resizeTimer;
        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(() => {
                editor.refresh();
            }, 200);
        });

    </script>
</body>
</html>