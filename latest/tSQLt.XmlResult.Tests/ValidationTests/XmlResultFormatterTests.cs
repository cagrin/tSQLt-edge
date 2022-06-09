namespace ValidationTests
{
    using System.Reflection;
    using System.Text;
    using Dapper;
    using DotNet.Testcontainers.Containers;
    using Microsoft.Data.SqlClient;

    [TestClass]
    public partial class XmlResultFormatterTests
    {
        [TestMethod]
        public void ShouldPass()
        {
            using var con = new SqlConnection($"{testcontainer?.ConnectionString}TrustServerCertificate=True;");

            con.Execute(GetSql("tSQLt.sql"));
            con.Execute(GetSql("tSQLt.TestResult.sql"));
            con.Execute(GetSql("tSQLt.Internal_XmlResultFormatter.sql"));
        }

        private static string GetSql(string fileName)
        {
            var sql = new StringBuilder();

            var asm = Assembly.GetExecutingAssembly();
            using var str = asm.GetManifestResourceStream($"tSQLt.XmlResult.Tests.{fileName}");
            if (str != null)
            {
                using var res = new StreamReader(str);
                while (res.Peek() >= 0)
                {
                    var line = res.ReadLine();
                    if (line != "GO")
                    {
                        sql.AppendLine(line);
                    }
                }
            }

            return sql.ToString();
        }
    }
}