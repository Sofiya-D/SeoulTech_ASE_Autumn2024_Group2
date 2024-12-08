import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static final SettingsManager _instance = SettingsManager._internal();

  factory SettingsManager() => _instance;

  SettingsManager._internal() {
    // Load saved settings when the instance is created
    _loadSettings();
  }

  bool _speechToTextEnabled = false;
  bool _textToSpeechEnabled = false;
  SharedPreferences? _prefs;

  // Getters for the private variables
  bool get speechToTextEnabled => _speechToTextEnabled;
  bool get textToSpeechEnabled => _textToSpeechEnabled;

  // Method to load saved settings
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _speechToTextEnabled = _prefs?.getBool('speechToTextEnabled') ?? false;
    _textToSpeechEnabled = _prefs?.getBool('textToSpeechEnabled') ?? false;
  }

  // Method to save settings
  Future<void> _saveSettings() async {
    await _prefs?.setBool('speechToTextEnabled', _speechToTextEnabled);
    await _prefs?.setBool('textToSpeechEnabled', _textToSpeechEnabled);
  }

  // Setter for Speech to Text with persistence
  set speechToTextEnabled(bool value) {
    _speechToTextEnabled = value;
    _saveSettings();
  }

  // Setter for Text to Speech with persistence
  set textToSpeechEnabled(bool value) {
    _textToSpeechEnabled = value;
    _saveSettings();
  }

  void handleTextToSpeech(BuildContext context) {
    if (!_textToSpeechEnabled) return;

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
    if (!_speechToTextEnabled) return;

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