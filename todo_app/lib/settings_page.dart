import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
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
          SwitchListTile(
            value: true, // Replace with actual value from state management
            title: Text('Enable Notifications'),
            secondary: Icon(Icons.notifications),
            onChanged: (value) {
              // Handle notifications toggle
            },
          ),
          Divider(),

          // Account Settings
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Account Preferences'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to account settings
            },
          ),
          Divider(),

          // Language Settings
          ListTile(
            leading: Icon(Icons.language),
            title: Text('Change Language'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // Navigate to language settings
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
