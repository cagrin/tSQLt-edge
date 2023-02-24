namespace ValidationTests
{
    using DotNet.Testcontainers.Builders;
    using DotNet.Testcontainers.Configurations;
    using DotNet.Testcontainers.Containers;

    public partial class XmlResultFormatterTests
    {
        private static MsSqlTestcontainer? testcontainer;

        [ClassInitialize]
        public static void ClassInitialize(TestContext context)
        {
            _ = context;

            using var config = new MsSqlTestcontainerConfiguration("mcr.microsoft.com/mssql/server")
            {
                Password = "A.794613",
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