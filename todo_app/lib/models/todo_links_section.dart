import 'package:flutter/material.dart';
import 'package:todo_app/models/link_manager.dart';
import 'package:todo_app/models/todo_form_data.dart';

class TodoLinksSection extends StatefulWidget {
  final TodoFormData formData;

  const TodoLinksSection({
    super.key,
    required this.formData,
  });

  @override
  State<TodoLinksSection> createState() => _TodoLinksSectionState();
}

class _TodoLinksSectionState extends State<TodoLinksSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Link',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinkManager(
              links: widget.formData.links,
              onLinksUpdated: (updatedLinks) {
                setState(() {
                  widget.formData.links.clear();
                  widget.formData.links.addAll(updatedLinks);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}