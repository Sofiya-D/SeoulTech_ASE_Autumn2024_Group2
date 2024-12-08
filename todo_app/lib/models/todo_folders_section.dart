import 'package:flutter/material.dart';
import 'package:todo_app/models/folder_manager.dart';
import 'package:todo_app/models/todo_form_data.dart';

class TodoFoldersSection extends StatefulWidget {
  final TodoFormData formData;

  const TodoFoldersSection({
    super.key,
    required this.formData,
  });

  @override
  State<TodoFoldersSection> createState() => _TodoFoldersSectionState();
}

class _TodoFoldersSectionState extends State<TodoFoldersSection> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Files and Folders',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            FolderManager(
              folders: widget.formData.folders,
              onFoldersUpdated: (updatedFolders) {
                setState(() {
                  widget.formData.folders.clear();
                  widget.formData.folders.addAll(updatedFolders);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
