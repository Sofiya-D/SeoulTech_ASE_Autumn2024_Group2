import 'package:flutter/material.dart';
import 'settings_manager.dart';

class FloatingButtons extends StatelessWidget {
  const FloatingButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: settingsManager.textToSpeechEnabledNotifier,
      builder: (context, textToSpeechEnabled, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: settingsManager.speechToTextEnabledNotifier,
          builder: (context, speechToTextEnabled, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text-to-Speech Floating Button
                if (textToSpeechEnabled)
                  FloatingActionButton(
                    heroTag: 'textToSpeech',
                    onPressed: () => settingsManager.handleTextToSpeech(context),
                    tooltip: 'Activate Text-to-Speech',
                    child: const Icon(Icons.hearing),
                  ),
                
                // Add some spacing if both buttons are visible
                if (textToSpeechEnabled && speechToTextEnabled)
                  const SizedBox(height: 16),
                
                // Speech-to-Text Floating Button
                if (speechToTextEnabled)
                  FloatingActionButton(
                    heroTag: 'speechToText',
                    onPressed: () => settingsManager.handleSpeechToText(context),
                    tooltip: 'Activate Speech-to-Text',
                    child: const Icon(Icons.mic),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}