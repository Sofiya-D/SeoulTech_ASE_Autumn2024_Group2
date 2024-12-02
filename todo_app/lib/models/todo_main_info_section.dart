// lib/views/todo_form/widgets/todo_main_info_section.dart

import 'package:flutter/material.dart';
// import 'package:todo_app/views/todo_form/todo_form_data.dart';
import 'package:todo_app/models/todo_form_data.dart';

class TodoMainInfoSection extends StatelessWidget {
  final TodoFormData formData;

  const TodoMainInfoSection({
    Key? key,
    required this.formData,
  }) : super(key: key);

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
                labelText: 'Titre *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer un titre';
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
                labelText: 'Tags (séparés par des virgules)',
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
    Key? key,
    required this.formData,
  }) : super(key: key);

  @override
  State<ImportanceLevelSlider> createState() => _ImportanceLevelSliderState();
}

class _ImportanceLevelSliderState extends State<ImportanceLevelSlider> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Niveau d\'importance: '),
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
