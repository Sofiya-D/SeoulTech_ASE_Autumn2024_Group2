// lib/views/todo_form/widgets/todo_subtasks_section.dart

import 'package:flutter/material.dart';
import 'package:todo_app/models/folder_manager.dart';
// import 'package:todo_app/views/todo_form/todo_form_data.dart';
// import 'package:todo_app/views/todo_form/widgets/todo_dates_section.dart';
// import 'package:todo_app/views/todo_form/widgets/todo_main_info_section.dart';
import 'package:todo_app/models/todo_form_data.dart';
import 'package:todo_app/models/todo_dates_section.dart';
import 'package:todo_app/models/todo_main_info_section.dart';
import 'package:todo_app/models/link_manager.dart';

class TodoSubtasksSection extends StatefulWidget {
  final TodoFormData formData;

  const TodoSubtasksSection({
    super.key,
    required this.formData,
  });

  @override
  State<TodoSubtasksSection> createState() => _TodoSubtasksSectionState();
}

class _TodoSubtasksSectionState extends State<TodoSubtasksSection> {
  void _addSubtask() {
    setState(() {
      widget.formData.subtasks.add(SubtaskFormData());
    });
  }

  void _removeSubtask(int index) {
    setState(() {
      final subtask = widget.formData.subtasks[index];
      subtask.dispose();
      widget.formData.subtasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtasks',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addSubtask,
                  icon: const Icon(Icons.add),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedList(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              key: GlobalKey<AnimatedListState>(),
              initialItemCount: widget.formData.subtasks.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(
                    Tween(
                      begin: const Offset(1.0, 0.0),
                      end: const Offset(0.0, 0.0),
                    ),
                  ),
                  child: SubtaskCard(
                    index: index,
                    subtask: widget.formData.subtasks[index],
                    onRemove: () => _removeSubtask(index),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SubtaskCard extends StatefulWidget {
  final int index;
  final SubtaskFormData subtask;
  final VoidCallback onRemove;

  const SubtaskCard({
    super.key,
    required this.index,
    required this.subtask,
    required this.onRemove,
  });

  @override
  State<SubtaskCard> createState() => _SubtaskCardState();
}

class _SubtaskCardState extends State<SubtaskCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text('Subtask ${widget.index + 1}'),
            subtitle: TextFormField(
              controller: widget.subtask.title,
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onRemove,
                  color: Theme.of(context).colorScheme.error,
                ),
              ],
            ),
          ),
          if (_isExpanded) ...[
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: widget.subtask.description,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: widget.subtask.tags,
                    decoration: const InputDecoration(
                      labelText: 'Tags (comma-separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TodoDatesSection(formData: _createSubtaskFormData()),
                  const SizedBox(height: 16),
                  ImportanceLevelSlider(formData: _createSubtaskFormData()),
                  const SizedBox(height: 16),
                  LinkManager(
                    links: widget.subtask.links,
                    onLinksUpdated: (updatedLinks) {
                      setState(() {
                        widget.subtask.links.clear();
                        widget.subtask.links.addAll(updatedLinks);
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  FolderManager(
                    folders: widget.subtask.folders,
                    onFoldersUpdated: (updatedFolders) {
                      setState(() {
                        widget.subtask.folders.clear();
                        widget.subtask.folders.addAll(updatedFolders);
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  TodoFormData _createSubtaskFormData() {
    // Crée un TodoFormData temporaire pour réutiliser les widgets existants
    return TodoFormData()
      ..title = widget.subtask.title
      ..description = widget.subtask.description
      ..tags = widget.subtask.tags
      ..startDate = widget.subtask.startDate
      ..dueDate = widget.subtask.dueDate
      ..importanceLevel = widget.subtask.importanceLevel;
  }
}


