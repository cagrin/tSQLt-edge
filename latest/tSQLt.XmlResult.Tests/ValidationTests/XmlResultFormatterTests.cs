namespace ValidationTests
{
    using System.Reflection;
    using System.Text;
    using System.Xml;
    using System.Xml.Schema;
    using Dapper;
    using Microsoft.Data.SqlClient;

    [TestClass]
    public partial class XmlResultFormatterTests
    {
        [TestMethod]
        public void ShouldPassSchemaValidation()
        {
            using var con = new SqlConnection(testcontainer?.GetConnectionString());

            _ = con.Execute(GetSql("tSQLt.sql"));
            _ = con.Execute(GetSql("tSQLt.TestResult.sql"));
            _ = con.Execute(GetSql("tSQLt.XmlResultFormatter.sql"));
            _ = con.Execute(GetSql("tSQLt.Internal_XmlResultFormatter.sql"));
            _ = con.Execute($"CREATE XML SCHEMA COLLECTION tSQLt.JUnitSchema AS '{GetSchema("JUnit.xsd")}';");

            _ = con.Execute("""
            INSERT INTO tSQLt.TestResult (Class, TestCase, Result, TestStartTime, TestEndTime) VALUES
            ('TestClass', 'TestCase', 'Success', '2022-06-14 23:37:01.1', '2022-06-14 23:37:01.3')
            """);

            var xml = con.Query<string>("EXEC tSQLt.XmlResultFormatter").First();
            var doc = new XmlDocument();
            doc.LoadXml(xml);

            var schema = XmlSchema.Read(new StringReader(GetSchema("JUnit.xsd")), (o, e) => throw new XmlException(e.Message));
            if (schema != null)
            {
                _ = doc.Schemas.Add(schema);
                doc.Validate((o, e) => throw new XmlSchemaValidationException(e.Message));
            }

            Assert.IsNotNull(schema);
            Assert.That.IsLike(xml, "<testsuites%testsuite%properties%testcase%system-out%system-err%testsuite%testsuites>");
        }

        private static string GetResource(string fileName, Func<string?, string?> lineAction)
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
                    line = lineAction(line);
                    if (line != null)
                    {
                        _ = sql.AppendLine(line);
                    }
                }
            }

            return sql.ToString();
        }

        private static string GetSql(string fileName)
        {
            return GetResource(fileName, (line) => line != "GO" ? line : null);
        }

        private static string GetSchema(string fileName)
        {
            return GetResource(fileName, (line) => line?.Replace("'", "''", StringComparison.InvariantCulture).Replace("©", "�", StringComparison.InvariantCulture));
        }
    }
}