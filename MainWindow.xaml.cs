﻿using System;
using System.IO;
using System.Windows;
using SolidWorks.Interop.sldworks;
using SolidWorks.Interop.swconst;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.Windows.Controls;

namespace Configuration_Exporter
{

    /// <summary>
    /// Логика взаимодействия для MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        private SldWorks app = null;
        private ModelDoc2 doc = null;
        private string path = "";

        public MainWindow()
        {
            InitializeComponent();
        }

        private bool connect()
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

            // Get path
            path = System.IO.Path.GetDirectoryName((string)doc.GetPathName());

            return true;
        }

        private void SaveButton_Click(object sender, RoutedEventArgs e)
        {
            if (connect())
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

                // Save all configurations
                foreach (string configurationName in (string[])doc.GetConfigurationNames())
                {
                    // Activate configuration
                    doc.ShowConfiguration2(configurationName);
                    Configuration config = doc.ConfigurationManager.ActiveConfiguration;

                    // Save all display states
                    foreach (string displayStateName in (string[]) config.GetDisplayStates())
                    {
                        // Filename
                        string filename = String.Format(
                            "{0}{1}-{2}{3}",
                            newPath + System.IO.Path.DirectorySeparatorChar,
                            configurationName,
                            displayStateName,
                            extention
                        );

                        // Select display state
                        config.ApplyDisplayState(displayStateName);

                        // Save model
                        doc.SaveAs2(filename, (int)swSaveAsVersion_e.swSaveAsCurrentVersion, true, true);
                    }
                }
            }
        }

        private void BrowseButton_Click(object sender, RoutedEventArgs e)
        {
            var dialog = new CommonOpenFileDialog();
            dialog.IsFolderPicker = true;
            if (connect()) dialog.InitialDirectory = path;
            CommonFileDialogResult result = dialog.ShowDialog();
            if (result is CommonFileDialogResult.Ok) DirectoryTextBox.Text = dialog.FileName;
        }
    }
}
