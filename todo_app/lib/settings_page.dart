import 'package:flutter/material.dart';

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
              _showThemeSelector(context);
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
              handleTextToSpeech(context); // Handle Text-to-speech toggle
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
              handleSpeechToText(context);// Handle Speech-to-Text toggle
            },
          ),
          Divider(),

          // Tags Settings
          ListTile(
            leading: Icon(Icons.tag_sharp),
            title: Text('New Tags'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              _showTagSettings(context); // Navigate to Tags settings
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

  // Tag Settings
  void _showTagSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add new Tags'),
        );
      }
    );
  }

  // Speech-to-text
  void handleSpeechToText(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_notificationsEnabled == true) {
          return AlertDialog(
            title: Text('Speech-To-Text Enabled'),
          );
        }
        else {
          return AlertDialog(
            title: Text('Speech-To-Text Disabled'),
          );
        }
      },
    );
  }

  // Text-to-speech
  void handleTextToSpeech(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_notificationsEnabled == true) {
          return AlertDialog(
            title: Text('Text-To-Speech Enabled'),
          );
        }
        else {
          return AlertDialog(
            title: Text('Text-To-Speech Disabled'),
          );
        }
        
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
                  });
                  handleNotification(context);// Handle notifications toggle
                },
              ),
              ListTile(
                leading: Icon(Icons.light_mode),
                title: Text('Light Theme'),
                onTap: () {
                  // Apply light theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Theme'),
                onTap: () {
                  // Apply dark theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.auto_awesome),
                title: Text('System Default'),
                onTap: () {
                  // Apply system default theme
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void handleNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        if (_notificationsEnabled == true) {
          return AlertDialog(
            title: Text('Notification Enabled'),
          );
        }
        else {
          return AlertDialog(
            title: Text('Notification Disabled'),
          );
        }
        
      },
    );
  }

  // Theme Selector Dialog
  void _showThemeSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Theme'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.light_mode),
                title: Text('Light Theme'),
                onTap: () {
                  // Apply light theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode),
                title: Text('Dark Theme'),
                onTap: () {
                  // Apply dark theme
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.auto_awesome),
                title: Text('System Default'),
                onTap: () {
                  // Apply system default theme
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
