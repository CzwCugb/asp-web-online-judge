using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace online_judge.BLL
{
    [Serializable]
    public class JudgeResult
    {
        // 新增测试用例ID字段
        public int TestCaseId { get; set; }

        // 判题状态
        public string Status { get; set; }

        // 运行时间（毫秒）
        public int Time { get; set; }

        // 内存消耗（KB）
        public int Memory { get; set; }

        // 错误信息
        public string ErrorMessage { get; set; }

        // 测试用例输入
        public string Input { get; set; }

        // 期望输出
        public string ExpectedOutput { get; set; }

        // 实际输出
        public string ActualOutput { get; set; }

        // 扩展属性：退出代码
        public int ExitCode { get; set; } = -1;

        // 扩展属性：是否超时
        public bool IsTimeout { get; set; }

        // 格式化输出方法
        public string GetFormattedTime() => $"{Time} ms";
        public string GetFormattedMemory() => $"{Memory / 1024.0:N2} MB";
    }
}
