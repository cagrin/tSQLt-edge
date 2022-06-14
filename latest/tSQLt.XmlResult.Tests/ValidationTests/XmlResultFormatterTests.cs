namespace ValidationTests
{
    using System.Reflection;
    using System.Text;
    using System.Xml;
    using System.Xml.Schema;
    using Dapper;
    using DotNet.Testcontainers.Containers;
    using Microsoft.Data.SqlClient;

    [TestClass]
    public partial class XmlResultFormatterTests
    {
        [TestMethod]
        public void ShouldPassSchemaValidation()
        {
            using var con = new SqlConnection($"{testcontainer?.ConnectionString}TrustServerCertificate=True;");

            con.Execute(GetSql("tSQLt.sql"));
            con.Execute(GetSql("tSQLt.TestResult.sql"));
            con.Execute(GetSql("tSQLt.XmlResultFormatter.sql"));
            con.Execute(GetSql("tSQLt.Internal_XmlResultFormatter.sql"));
            con.Execute($"CREATE XML SCHEMA COLLECTION tSQLt.JUnitSchema AS '{GetSchema("JUnit.xsd")}';");

            con.Execute("""
            INSERT INTO tSQLt.TestResult (Class, TestCase, Result, TestStartTime, TestEndTime) VALUES
            ('TestClass', 'TestCase', 'Success', '2022-06-14 23:37:01.1', '2022-06-14 23:37:01.3')
            """);

            var xml = con.Query<string>("EXEC tSQLt.XmlResultFormatter").First();
            var doc = new XmlDocument();
            doc.LoadXml(xml);

            var schema = XmlSchema.Read(new StringReader(GetSchema("JUnit.xsd")), (o, e) => throw new AmbiguousMatchException(e.Message));
            if (schema != null)
            {
                doc.Schemas.Add(schema);
                doc.Validate((o, e) => throw new AmbiguousMatchException(e.Message));
            }
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

        private static string GetSchema(string fileName)
        {
            var sql = new StringBuilder();

            var asm = Assembly.GetExecutingAssembly();
            using var str = asm.GetManifestResourceStream($"tSQLt.XmlResult.Tests.{fileName}");
            if (str != null)
            {
                using var res = new StreamReader(str);
                while (res.Peek() >= 0)
                {
                    var line = res.ReadLine()?
                                  .Replace("'", "''", StringComparison.InvariantCulture)
                                  .Replace("©", "�", StringComparison.InvariantCulture);

                    sql.AppendLine(line);
                }
            }

            return sql.ToString();
        }
    }
}