import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'main.dart'; // Import ThemeProvider here

class SettingsPage extends StatefulWidget {
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = false;
  bool _textToSpeechEnabled = false;
  bool _speechToTextEnabled = false;

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Theme Settings
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text('Change Theme'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to a theme change screen or show a theme selector dialog
              _showThemeSelector(context, themeProvider);
            },
          ),
          Divider(),

          // Notifications Settings
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('Notification Settings'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to a notification change screen
              _showNotificationSettings(context);
            },
          ),
          Divider(),

          // Text-to-Speech Enabler
          SwitchListTile(
            value: _textToSpeechEnabled, // Replace with actual value from state management
            title: Text('Enable Text-to-Speech'),
            secondary: Icon(Icons.hearing),
            onChanged: (value) {
              setState(() {
                _textToSpeechEnabled = value; // Update the state
              });
              _handleTextToSpeech(context); // Handle Text-to-speech toggle
            },
          ),
          Divider(),

          // Speech-to-Text Enabler
          SwitchListTile(
            value: _speechToTextEnabled, // Replace with actual value from state management
            title: Text('Enable Speech-to-Text'),
            secondary: Icon(Icons.mic_outlined),
            onChanged: (value) {
              setState(() {
                _speechToTextEnabled = value; // Update the state
              });
              _handleSpeechToText(context);// Handle Speech-to-Text toggle
            },
          ),
          Divider(),

          // Tags Settings
          ListTile(
            leading: Icon(Icons.label),
            title: Text('New Tags'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              _showTagSettings(context); // Navigate to Tags settings
            },
          ),
          Divider(),

          // Custom Repeating Period Settings
          ListTile(
            leading: Icon(Icons.calendar_month),
            title: Text('Custom repeating period'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              _showPeriodSettings(context); // Navigate to Period settings
            },
          ),
          Divider(),

          // About App
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About App'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Show an About Dialog
              _showAboutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  // Theme Selector Dialog
  void _showThemeSelector(BuildContext context, ThemeProvider themeProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                value: themeProvider.themeMode == ThemeMode.dark,
                title: Text('Enable Dark Theme'),
                secondary: Icon(Icons.dark_mode),
                onChanged: (isDarkMode) {
                  themeProvider.toggleTheme(isDarkMode);
                },
              ),
              ListTile(
                leading: Icon(Icons.palette),
                title: Text('Personnalized Color Theme'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Apply system default theme
                  _handleChangingColor(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.auto_awesome),
                title: Text('Default Color Settings'),
                onTap: () {
                  // Apply system default theme
                  context.read<ThemeProvider>().changeColor(Colors.red);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _handleChangingColor(BuildContext context) async {
    Color selectedColor = Colors.red; // Default fallback color

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (Color color) {
                selectedColor = color; // Update the selected color
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context); // Close dialog without applying changes
              },
            ),
            TextButton(
              child: Text('APPLY'),
              onPressed: () {
                context.read<ThemeProvider>().changeColor(selectedColor);
                Navigator.pop(context); // Close dialog and apply the selected color
              },
            ),
          ],
        );
      },
    );
  }


  // Notification Settings
  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                value: _notificationsEnabled, // Replace with actual value from state management
                title: Text('Enable Notifications'),
                secondary: Icon(Icons.notifications),
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value; // Update the state
                    Navigator.pop(context);
                  });
                  _handleNotification(context);// Handle notifications toggle
                },
              ),
              ListTile(
                leading: Icon(Icons.access_time),
                title: Text('Set reminder times'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Apply light theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.cast_for_education),
                title: Text('Set encouragement times'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Apply dark theme
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_notificationsEnabled == true) {
          return AlertDialog(
            title: Text('Notification Enabled'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
        else {
          return AlertDialog(
            title: Text('Notification Disabled'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
        
      },
    );
  }

  // Text-to-speech
  void _handleTextToSpeech(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_textToSpeechEnabled == true) {
          return AlertDialog(
            title: Text('Text-To-Speech Enabled'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
        else {
          return AlertDialog(
            title: Text('Text-To-Speech Disabled'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
      },
    );
  }
  
  // Speech-to-text
  void _handleSpeechToText(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_speechToTextEnabled == true) {
          return AlertDialog(
            title: Text('Speech-To-Text Enabled'),actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
        else {
          return AlertDialog(
            title: Text('Speech-To-Text Disabled'),actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        }
      },
    );
  }

  // Tag Settings
  void _showTagSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tags'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.new_label),
                title: Text('Add new tags'),
                onTap: () {
                  // Apply light theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.list),
                title: Text('List of exisiting tags'),
                trailing: Icon(Icons.chevron_right),
                onTap: () {
                  // Apply dark theme
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );
  }

  // Custom Repeating Period Settings
  void _showPeriodSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Custom Repeating Period'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      }
    );
  }

  // About App Dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About To-Do App'),
          content: Text(
            'This is a simple To-Do application built with Flutter. Version 1.0.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
