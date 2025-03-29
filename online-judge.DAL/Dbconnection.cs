// App_Code/Database/MySqlConnector.cs
using System;
using System.Data;
using MySql.Data.MySqlClient;

namespace online_judge.DAL
{
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
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return null;
        }

        public static void Execute(string sql)
        {
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

        public static object ExecuteScalar(string sql, MySqlParameter[] parameters = null)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
                {
                    conn.Open();
                    MySqlCommand cmd = new MySqlCommand(sql, conn);
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    return cmd.ExecuteScalar();
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return null;
        }

        public static DataTable ExecuteQuery(string sql, MySqlParameter[] parameters)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
                {
                    MySqlDataAdapter da = new MySqlDataAdapter();
                    da.SelectCommand = new MySqlCommand(sql, conn);
                    if (parameters != null)
                    {
                        da.SelectCommand.Parameters.AddRange(parameters);
                    }
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    return dt;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return null;
        }

        /// <summary>
        /// 执行非查询 SQL 语句（如 INSERT、UPDATE、DELETE），并返回受影响的行数。
        /// </summary>
        /// <param name="sql">SQL 语句</param>
        /// <param name="parameters">参数化查询参数</param>
        /// <returns>受影响的行数，出错时返回 -1</returns>
        public static int ExecuteNonQuery(string sql, MySqlParameter[] parameters)
        {
            try
            {
                using (MySqlConnection conn = new MySqlConnection(Dbconfig.Connection))
                {
                    conn.Open();
                    using (MySqlCommand cmd = new MySqlCommand(sql, conn))
                    {
                        if (parameters != null)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }
                        return cmd.ExecuteNonQuery();
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
                return -1;
            }
        }
    }
}
