// App_Code/Database/MySqlConnector.cs
using System;
using System.Data;
using MySql.Data.MySqlClient;

public class Dbconnection
{
    public static DataTable ExecuteQuery(string sql)
    {
        using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
        {
            MySqlDataAdapter da = new MySqlDataAdapter(sql, conn);
            DataTable dt = new DataTable();
            da.Fill(dt);
            return dt;
        }
    }
    public static void Execute(string sql) {
        using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
        {
            conn.Open();
            MySqlCommand cmd = new MySqlCommand(sql, conn);
            cmd.ExecuteNonQuery();
        }
    }
}