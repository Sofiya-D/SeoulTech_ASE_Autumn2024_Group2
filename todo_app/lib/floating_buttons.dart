import 'package:flutter/material.dart';

class FloatingButtons extends StatelessWidget {
  final VoidCallback onTextToSpeechPressed;
  final VoidCallback onSpeechToTextPressed;

  const FloatingButtons({
    Key? key,
    required this.onTextToSpeechPressed,
    required this.onSpeechToTextPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'textToSpeech',
          onPressed: onTextToSpeechPressed,
          tooltip: 'Activate Text-to-Speech',
          child: const Icon(Icons.hearing),
        ),
        const SizedBox(height: 16),
        FloatingActionButton(
          heroTag: 'speechToText',
          onPressed: onSpeechToTextPressed,
          tooltip: 'Activate Speech-to-Text',
          child: const Icon(Icons.mic),
        ),
      ],
    );
  }
}
