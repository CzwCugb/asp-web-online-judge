<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="problem.aspx.cs" Inherits="asp_web_online_judge.problem" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title id="title" runat="server">算法竞赛题目</title>
    <link href="./css/problem2.css" rel="stylesheet" type="text/css"/>
    
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

    <style>
        :root {
            --primary-color: #2c3e50;
            --accent-color: #3498db;
            --success-color: #27ae60;
            --background-color: #f8f9fa;
            --text-color: #2c3e50;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            margin: 0;
            padding: 20px;
        }

        .code-section {
            max-width: 1000px;
            margin: 2rem auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.12);
            padding: 2rem;
            transition: transform 0.2s ease;
        }

        .code-section:hover {
            transform: translateY(-2px);
        }

        h3 {
            color: var(--primary-color);
            font-size: 1.8rem;
            margin: 0 0 1.5rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #eee;
            font-weight: 600;
        }

        .language-selector {
            padding: 0.8rem 1.2rem;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            font-family: 'Fira Code', monospace;
            font-size: 1rem;
            background: white;
            width: 200px;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20width%3D%2212%22%20height%3D%228%22%20viewBox%3D%220%200%2012%208%22%20fill%3D%22none%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Cpath%20d%3D%22M1%201L6%206L11%201%22%20stroke%3D%22%232c3e50%22%20stroke-width%3D%222%22%20stroke-linecap%3D%22round%22%2F%3E%3C%2Fsvg%3E");
            background-repeat: no-repeat;
            background-position: right 1rem center;
            transition: all 0.2s ease;
        }

        .language-selector:hover {
            border-color: var(--accent-color);
            box-shadow: 0 2px 8px rgba(52, 152, 219, 0.2);
        }

        .language-selector:focus {
            outline: none;
            border-color: var(--accent-color);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.2);
        }

        #codeEditorWrapper {
            margin: 1.5rem 0;
            border-radius: 8px;
            overflow: hidden;
            border: 2px solid #e0e0e0;
            transition: border-color 0.2s ease;
        }

        #codeEditorWrapper:hover {
            border-color: var(--accent-color);
        }

        .CodeMirror {
            font-family: 'Fira Code', monospace;
            font-size: 15px;
            line-height: 1.5;
            min-height: 400px;
            padding: 1rem;
        }

        .CodeMirror-gutters {
            /*background-color: #f8f9fa !important;*/
            border-right: 1px solid #eee !important;
        }

        .submit-button {
            display: inline-flex;
            align-items: center;
            gap: 0.8rem;
            padding: 1rem 2rem;
            background: linear-gradient(135deg, var(--accent-color), #2980b9);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .submit-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0,0,0,0.15);
            background: linear-gradient(135deg, #2980b9, var(--accent-color));
        }

        .submit-button:active {
            transform: translateY(0);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        @media (max-width: 768px) {
            .code-section {
                width: 95%;
                padding: 1.5rem;
            }
            
            .CodeMirror {
                min-height: 300px;
                font-size: 14px;
            }
        }
        .problem-card { 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            border-radius: 8px;
            overflow: hidden;
        }
        .table-hover tbody tr { transition: all 0.2s ease; }
        .difficulty-badge { padding: 0.25em 0.6em; font-size: 0.85em; }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="code-section">
            <h3>✍️ 代码提交</h3>
            
            <!-- 语言选择器 -->
            <select id="languageSelector" class="language-selector">
                <option value="text/x-csrc">C/C++</option>
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
                Text="🚀 提交代码" 
                CssClass="submit-button" 
                OnClick="SubmitButton_Click"
                OnClientClick="syncCode()" />
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
        window.addEventListener('DOMContentLoaded', function() {
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