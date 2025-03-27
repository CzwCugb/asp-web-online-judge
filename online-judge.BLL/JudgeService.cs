using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Data;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;
using online_judge.DAL;

namespace online_judge.BLL
{
    public class JudgeService
    {
        public static JudgeResult Execute(int problemId, string code, string language,int testid = -1)
        {

            var result = new JudgeResult();
            var tempFile = Path.GetTempFileName();
            if (language == "c/c++"){
                tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".cpp");
            }
            else
            {
                tempFile = Path.ChangeExtension(Path.GetTempFileName(), ".py");
            }
            const int timeoutMilliseconds = 2000;
            var stopwatch = new Stopwatch();

            try
            {
                DataTable testCase;
                // 数据库查询逻辑 
                if (testid == -1)
                {
                    testCase = Dbconnection.ExecuteQuery(
                        $"SELECT input_data, output_data FROM test_case WHERE problem_id = {problemId} LIMIT 1");
                }
                else
                {
                    testCase = Dbconnection.ExecuteQuery(
                        $"SELECT input_data, output_data FROM test_case WHERE test_case_id = {testid} LIMIT 1");
                }

                if (testCase.Rows.Count == 0)
                {
                    result.Status = "Test Case Not Found";
                    return result;
                }

                string input = testCase.Rows[0]["input_data"].ToString().Trim();
                string expectedOutput = testCase.Rows[0]["output_data"].ToString().Trim();

                // 代码写入临时文件 
                File.WriteAllText(tempFile, code);

                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = GetExecutor(language),
                        Arguments = BuildArguments(language, tempFile),
                        RedirectStandardInput = true,
                        RedirectStandardOutput = true,
                        RedirectStandardError = true,
                        UseShellExecute = false,
                        CreateNoWindow = true
                    }
                };

                result.Input = input;
                result.ExpectedOutput = expectedOutput;

                stopwatch.Start();
                process.Start();

                // 流式输入处理 
                using (StreamWriter sw = process.StandardInput)
                {
                    sw.Write(input);
                    sw.Flush();
                }

                if (!process.WaitForExit(timeoutMilliseconds))
                {
                    process.Kill();
                    result.Status = "Time Limit Exceeded";
                    result.Time = timeoutMilliseconds;
                    result.ErrorMessage = "您的代码执行超时，时间为:" + result.Time  + "ms";
                }
                else
                {
                    stopwatch.Stop();
                    result.Time = (int)stopwatch.ElapsedMilliseconds;
                    result.ActualOutput = process.StandardOutput.ReadToEnd().Trim();
                    var error = process.StandardError.ReadToEnd();

                    if (!string.IsNullOrEmpty(error))
                    {
                        result.Status = "Runtime Error";
                        result.ErrorMessage = error;
                    }
                    else if (NormalizeOutput(result.ActualOutput) == NormalizeOutput(result.ExpectedOutput))
                    {
                        result.Status = "Accepted";
                    }
                    else
                    {
                        result.Status = "Wrong Answer";
                    }
                }

            }
            catch (Exception ex)
            {
                result.Status = "Judge Error";
                result.ErrorMessage = ex.Message;
            }
            finally
            {
                // 清理资源
                if (File.Exists(tempFile)) File.Delete(tempFile);
            }

            return result;
        }

        private static string NormalizeOutput(string output)
        {
            return output.Replace("\r\n", "\n").Trim();
        }

        private static string GetExecutor(string lang)
        {
            if (lang == "c/c++")
            {
                return "cmd.exe"; // 使用 Windows 的 cmd 执行编译命令
            }
            else
            {
                return "python";
            }
        }

        private static string BuildArguments(string lang, string file)
        {
            if (lang == "c/c++")
            {
                string outputExe = Path.Combine(Path.GetTempPath(), "temp.exe");
                // 编译命令：g++ source.cpp -o output.exe
                // 执行命令：output.exe
                return $"/c g++ \"{file}\" -o \"{outputExe}\" && \"{outputExe}\"";
            }
            else
            {
                return $"-u \"{file}\"";
            }
        }

        public static List<JudgeResult> Executemulti(int problemId, string code, string language)
        {
            DataTable testCase = Dbconnection.ExecuteQuery(
                    $"SELECT in_problem_case_id,test_case_id FROM test_case_mapping WHERE problem_id = {problemId}");
            List<JudgeResult> result = new List<JudgeResult>();
            int len = testCase.Rows.Count;
            for ( int i = 0; i < len; i++ )
            {
                for ( int j = 0; j < len; j++ ) { 
                    if((i + 1).ToString() == (testCase.Rows[j]["in_problem_case_id"].ToString())) {
                        result.Add(Execute(problemId,code,language, (int)testCase.Rows[j]["test_case_id"]));
                    }
                }
            }
            return result;
        }

    }
}