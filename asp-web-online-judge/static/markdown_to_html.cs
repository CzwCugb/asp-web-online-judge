using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Markdig;


public class markdown_to_html
{
    public static string to_html(string s)
    {
        return Markdown.ToHtml(s);
    }
}
