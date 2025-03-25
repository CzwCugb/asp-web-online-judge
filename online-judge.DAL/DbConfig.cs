using System;
using System.Web;
using System.Configuration;


//调用Web.config中的数据库字符串
public class Dbconfig { 
    public static string Connection =>
        ConfigurationManager.ConnectionStrings["DefaultConnection"].ConnectionString;
}
