using System;
using System.IO;
using System.Windows;
using SolidWorks.Interop.sldworks;
using SolidWorks.Interop.swconst;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.Windows.Controls;
using System.Diagnostics;
using System.Windows.Navigation;

namespace Configuration_Exporter
{

    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private SldWorks app = null;
        private ModelDoc2 doc = null;
        private ModelDocExtension extension = null;
        private string path = "";
        private string filename = "";

        public MainWindow()
        {
            InitializeComponent();
        }

        private bool Connect()
        {
            // Get SolidWorks object
            if (app is null)
            {
                app = (SldWorks) Activator.CreateInstance(Type.GetTypeFromProgID("SldWorks.Application"));
                if (app is null)
                {
                    MessageBox.Show("Error: Can't connect to the SolidWorks application!");
                    return false;
                }
            }

            // Get SolidWorks document
            if (doc is null)
            {
                doc = (ModelDoc2)app.ActiveDoc;
                if (doc is null)
                {
                    MessageBox.Show("Error: Can't get the SolidWorks document!");
                    return false;
                }
            }

            // Get SolidWorks document extension
            if (extension is null)
            {
                extension = doc.Extension;
                if (extension is null)
                {
                    MessageBox.Show("Error: Can't get the SolidWorks document extension!");
                    return false;
                }
            }

            // Get path
            string docunentPath = doc.GetPathName();
            path = Path.GetDirectoryName(docunentPath);
            filename = Path.GetFileNameWithoutExtension(docunentPath);

            return true;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (Connect())
            {
                // Set step v214 as default
                app.SetUserPreferenceIntegerValue((int)swUserPreferenceIntegerValue_e.swStepAP, 214);

                // Get extention
                ComboBoxItem selectedItem = (ComboBoxItem) FormatCombo.SelectedItem;
                string extention = selectedItem.Content.ToString();

                // Get path
                string newPath = DirectoryTextBox.Text;
                if (newPath is "") newPath = path;

                // Check newPath
                if (!Directory.Exists(newPath))
                {
                    MessageBox.Show("Error: Invalid output directory!");
                    return;
                }

                // Initialize error and warning counters
                int errors = 0;
                int warnings = 0;

                // Configure advanced save options
                IAdvancedSaveAsOptions advOptions = extension.GetAdvancedSaveAsOptions((int)swSaveWithReferencesOptions_e.swSaveWithReferencesOptions_None);

                // Save all configurations
                foreach (string configurationName in (string[])doc.GetConfigurationNames())
                {
                    // Activate configuration
                    doc.ShowConfiguration2(configurationName);
                    Configuration config = doc.ConfigurationManager.ActiveConfiguration;

                    // Get display states
                    string[] displayStates = (string[]) config.GetDisplayStates();

                    if (displayStates is null) return;
                    if (displayStates.Length == 0) return;

                    if (displayStates.Length == 1)
                    {
                        // Filename
                        string outputPath = String.Format(
                            "{0}{1}-{2}{3}",
                            newPath + System.IO.Path.DirectorySeparatorChar,
                            this.filename,
                            configurationName,
                            extention
                        );

                        // Save model
                        bool success = extension.SaveAs3(
                            outputPath,
                            (int)swSaveAsVersion_e.swSaveAsCurrentVersion,
                            (int)swSaveAsOptions_e.swSaveAsOptions_Silent,
                            null,
                            advOptions,
                            ref errors,
                            ref warnings
                        );

                        continue;
                    }

                    // Save all display states
                    foreach (string displayStateName in displayStates)
                    {
                        // Filename
                        string outputPath = String.Format(
                            "{0}{1}-{2}{3}",
                            newPath + Path.DirectorySeparatorChar,
                            configurationName,
                            displayStateName,
                            extention
                        );

                        // Select display state
                        config.ApplyDisplayState(displayStateName);

                        // Save model
                        // Save model
                        bool success = extension.SaveAs3(
                            outputPath,
                            (int)swSaveAsVersion_e.swSaveAsCurrentVersion,
                            (int)swSaveAsOptions_e.swSaveAsOptions_Silent,
                            null,
                            advOptions,
                            ref errors,
                            ref warnings
                        );
                    }
                }
            }
        }

        private void BrowseButton_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new CommonOpenFileDialog{IsFolderPicker = true};
            if (Connect()) dialog.InitialDirectory = path;
            CommonFileDialogResult result = dialog.ShowDialog();
            if (result is CommonFileDialogResult.Ok) DirectoryTextBox.Text = dialog.FileName;
        }

        private void Hyperlink_RequestNavigate(object sender, RequestNavigateEventArgs e)
        {
            // for .NET Core you need to add UseShellExecute = true
            // see https://docs.microsoft.com/dotnet/api/system.diagnostics.processstartinfo.useshellexecute#property-value
            Process.Start(new ProcessStartInfo(e.Uri.AbsoluteUri));
            e.Handled = true;
        }

        private void Window_Loaded(object sender, RoutedEventArgs e)
        {
            // We know longer need to size to the contents.
            ClearValue(SizeToContentProperty);

            // Don't want our window to be able to get any smaller than this.
            SetValue(MinWidthProperty, this.Width);
            SetValue(MinHeightProperty, this.Height);
        }
    }
}
