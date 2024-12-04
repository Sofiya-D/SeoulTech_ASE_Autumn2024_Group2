import 'package:flutter/material.dart';

class SettingsManager {
  static final SettingsManager _instance = SettingsManager._internal();

  factory SettingsManager() => _instance;

  SettingsManager._internal();

  bool speechToTextEnabled = false;
  bool textToSpeechEnabled = false;

  void handleTextToSpeech(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Text-to-Speech Action'),
          content: Text('You have activated the Text-to-Speech feature!'),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text-to-Speech Activated')),
    );
  }

  void handleSpeechToText(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Speech-to-Text Action'),
          content: Text('You have activated the Speech-to-Text feature!'),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Speech-to-Text Activated')),
    );
  }
}

final settingsManager = SettingsManager();
