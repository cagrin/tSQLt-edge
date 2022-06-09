namespace ValidationTests
{
    using DotNet.Testcontainers.Builders;
    using DotNet.Testcontainers.Configurations;
    using DotNet.Testcontainers.Containers;

    public partial class XmlResultFormatterTests
    {
        private const string Image =
#if DEBUG
        "cagrin/azure-sql-edge-arm64";
#else
        "mcr.microsoft.com/mssql/server:2019-latest";
#endif

        private const string Password = "A.794613";

        private static MsSqlTestcontainer? testcontainer;

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            _ = context;

            using var config = new MsSqlTestcontainerConfiguration(Image)
            {
                Password = Password,
            };

            testcontainer = new TestcontainersBuilder<MsSqlTestcontainer>()
                .WithDatabase(config)
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