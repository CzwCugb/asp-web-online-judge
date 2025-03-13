// App_Code/Database/MySqlConnector.cs
using System;
using System.Data;
using MySql.Data.MySqlClient;

public class Dbconnection
{
    public static DataTable ExecuteQuery(string sql)
    {
        try
        {
            using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
            {
                MySqlDataAdapter da = new MySqlDataAdapter(sql, conn);
                DataTable dt = new DataTable();
                da.Fill(dt);
                return dt;
            }
        }catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
        return null;
    }

    public static void Execute(string sql) {
        try
        {
            using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
            {
                conn.Open();
                MySqlCommand cmd = new MySqlCommand(sql, conn);
                cmd.ExecuteNonQuery();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine(ex.Message);
        }
    }
}