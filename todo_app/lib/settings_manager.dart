import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsManager {
  static final SettingsManager _instance = SettingsManager._internal();

  factory SettingsManager() => _instance;

  SettingsManager._internal() {
    // Load saved settings when the instance is created
    _loadSettings();
  }

  final ValueNotifier<bool> _speechToTextEnabledNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<bool> _textToSpeechEnabledNotifier = ValueNotifier<bool>(false);
  SharedPreferences? _prefs;

  // Getters for the value notifiers
  ValueNotifier<bool> get speechToTextEnabledNotifier => _speechToTextEnabledNotifier;
  ValueNotifier<bool> get textToSpeechEnabledNotifier => _textToSpeechEnabledNotifier;

  // Getters for the private variables
  bool get speechToTextEnabled => _speechToTextEnabledNotifier.value;
  bool get textToSpeechEnabled => _textToSpeechEnabledNotifier.value;

  // Method to load saved settings
  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _speechToTextEnabledNotifier.value = _prefs?.getBool('speechToTextEnabled') ?? false;
    _textToSpeechEnabledNotifier.value = _prefs?.getBool('textToSpeechEnabled') ?? false;
  }

  // Method to save settings
  Future<void> _saveSettings() async {
    await _prefs?.setBool('speechToTextEnabled', _speechToTextEnabledNotifier.value);
    await _prefs?.setBool('textToSpeechEnabled', _textToSpeechEnabledNotifier.value);
  }

  // Setter for Speech to Text with persistence
  set speechToTextEnabled(bool value) {
    _speechToTextEnabledNotifier.value = value;
    _saveSettings();
  }

  // Setter for Text to Speech with persistence
  set textToSpeechEnabled(bool value) {
    _textToSpeechEnabledNotifier.value = value;
    _saveSettings();
  }

  void handleTextToSpeech(BuildContext context) {
    if (!_textToSpeechEnabledNotifier.value) return;

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
    if (!_speechToTextEnabledNotifier.value) return;

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