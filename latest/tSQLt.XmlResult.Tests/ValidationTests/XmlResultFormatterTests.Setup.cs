[assembly: Parallelize(Scope = ExecutionScope.ClassLevel)]

namespace ValidationTests
{
    using Testcontainers.MsSql;

    public partial class XmlResultFormatterTests
    {
        private static MsSqlContainer? testcontainer;

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            _ = context;

            testcontainer = new MsSqlBuilder()
                .WithImage("mcr.microsoft.com/mssql/server")
                .Build();

            testcontainer.StartAsync().Wait();

            Thread.Sleep(5000);
        }

        [ClassCleanup]
        public static void ClassCleanup()
        {
            testcontainer?.DisposeAsync().AsTask().Wait();
        }
    }
}