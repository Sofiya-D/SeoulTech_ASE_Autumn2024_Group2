import 'package:flutter/material.dart';


import 'settings_manager.dart';
import 'floating_buttons.dart';


class CreateTaskPage extends StatelessWidget {
  const CreateTaskPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text('This is the Create Task Page'),
        ],
      ),
      floatingActionButton: FloatingButtons(
        onTextToSpeechPressed: () {
          settingsManager.handleTextToSpeech(context);
        },
        onSpeechToTextPressed: () {
          settingsManager.handleSpeechToText(context);
        },
      ),
    );
  }
}