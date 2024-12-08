// lib/views/todo_form/widgets/todo_main_info_section.dart

import 'package:flutter/material.dart';
// import 'package:todo_app/views/todo_form/todo_form_data.dart';
import 'package:todo_app/models/todo_form_data.dart';

class TodoMainInfoSection extends StatelessWidget {
  final TodoFormData formData;

  const TodoMainInfoSection({
    super.key,
    required this.formData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: formData.title,
              decoration: const InputDecoration(
                labelText: 'Title *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: formData.description,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ImportanceLevelSlider(formData: formData),
            const SizedBox(height: 16),
            TextFormField(
              controller: formData.tags,
              decoration: const InputDecoration(
                labelText: 'Tags (comma-separated)',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImportanceLevelSlider extends StatefulWidget {
  final TodoFormData formData;

  const ImportanceLevelSlider({
    super.key,
    required this.formData,
  });

  @override
  State<ImportanceLevelSlider> createState() => _ImportanceLevelSliderState();
}

class _ImportanceLevelSliderState extends State<ImportanceLevelSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Importance Level: '),
        Expanded(
          child: Slider(
            value: widget.formData.importanceLevel.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            label: widget.formData.importanceLevel.toString(),
            onChanged: (value) {
              setState(() {
                widget.formData.importanceLevel = value.round();
              });
            },
          ),
        ),
      ],
    );
  }
}
