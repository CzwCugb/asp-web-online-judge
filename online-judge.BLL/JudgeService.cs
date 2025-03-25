using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Web;

namespace asp_web_online_judge.service
{
    public class JudgeService
    {
        public static string Execute(string code, string language)
        {
            var tempFile = Path.GetTempFileName();
            try
            {
                File.WriteAllText(tempFile, code);

                var process = new Process
                {
                    StartInfo = new ProcessStartInfo
                    {
                        FileName = GetExecutor(language),
                        Arguments = BuildArguments(language, tempFile),
                        RedirectStandardOutput = true,
                        UseShellExecute = false
                    }
                };
                process.Start();
                return process.StandardOutput.ReadToEnd();
            }
            finally
            {
                File.Delete(tempFile);
            }
        }

        private static string GetExecutor(string lang)
        {
            if (lang == "c++")
            {
                return "cmd.exe";
            }
            else
            {
                return "python";
            }
        }

        private static string BuildArguments(string lang, string file)
        {
            if (lang == "c++")
            {
                return $"/c g++ {file} -o {file}.exe && {file}.exe";
            }
            else
            {
                return $"-u {file}";
            }
        }
    }
}