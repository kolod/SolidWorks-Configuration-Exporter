using System.Threading;
using System.Windows;

namespace Configuration_Exporter
{
    /// <summary>
    /// Логика взаимодействия для App.xaml
    /// </summary>
    public partial class App : Application
    {
        // Also used by install.nsi to detect a running instance
        private const string MutexName = "SolidWorks-Configuration-Exporter";

        // Held for the lifetime of the process
        private static Mutex mutex;

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            mutex = new Mutex(true, MutexName, out bool createdNew);
            if (!createdNew)
            {
                MessageBox.Show("Configuration Exporter is already running.", "Configuration Exporter", MessageBoxButton.OK, MessageBoxImage.Information);
                Shutdown();
                return;
            }

            new MainWindow().Show();
        }

        protected override void OnExit(ExitEventArgs e)
        {
            mutex?.Dispose();
            base.OnExit(e);
        }
    }
}
