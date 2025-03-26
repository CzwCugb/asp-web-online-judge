using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using Markdig;

namespace online_judge.BLL {

    public class markdown_to_html
    {
        public static string to_html(string s)
        {
            var pipeline = new MarkdownPipelineBuilder().UseAdvancedExtensions().Build();
            return Markdown.ToHtml(s, pipeline);
        }
    }

}
