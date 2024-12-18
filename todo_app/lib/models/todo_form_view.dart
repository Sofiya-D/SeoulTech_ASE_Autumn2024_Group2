// lib/views/todo_form/todo_form_view.dart

import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
// import 'package:todo_app/views/todo_form/widgets/todo_dates_section.dart';
// import 'package:todo_app/views/todo_form/widgets/todo_main_info_section.dart';
// import 'package:todo_app/views/todo_form/widgets/todo_subtasks_section.dart';
import 'package:todo_app/models/todo_dates_section.dart';
import 'package:todo_app/models/todo_main_info_section.dart';
import 'package:todo_app/models/todo_subtasks_section.dart';
import 'package:todo_app/models/todo_form_data.dart';
import 'todo_links_section.dart';
import 'package:todo_app/models/todo_folders_section.dart';

class TodoFormView extends StatefulWidget {
  final Function(Todo) onSubmit;

  const TodoFormView({super.key, required this.onSubmit});

  @override
  _TodoFormViewState createState() => _TodoFormViewState();
}

class _TodoFormViewState extends State<TodoFormView> {
  final _formKey = GlobalKey<FormState>();
  final TodoFormData _formData = TodoFormData();

  void _handleSubmit() {
    if (_formKey.currentState!.validate() && _formData.validateDates()) {
      final todo = Todo(
        title: _formData.title.text,
        description: _formData.description.text,
        importanceLevel: _formData.importanceLevel,
        tags: _formData.tags.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        startDate: _formData.startDateTime,
        dueDate: _formData.dueDateTime,
        periodicity: _formData.periodicity,
        links: _formData.links,
        folders: _formData.folders,
        tasks: _formData.subtasks.map((subtaskData) {
          return TodoTask(
            title: subtaskData.title.text,
            description: subtaskData.description.text,
            tags: subtaskData.tags.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList(),
            startDate: subtaskData.startDateTime,
            dueDate: subtaskData.dueDateTime,
            periodicity: subtaskData.periodicity,
            links: subtaskData.links,
            folders: subtaskData.folders,
          );
        }).toList(),
        
      );
      widget.onSubmit(todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TodoMainInfoSection(formData: _formData),
              const SizedBox(height: 16),
              TodoDatesSection(formData: _formData),
              const SizedBox(height: 16),
              TodoLinksSection(formData: _formData),
              const SizedBox(height: 16),
              TodoFoldersSection(formData: _formData),
              const SizedBox(height: 16),
              TodoSubtasksSection(formData: _formData),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _handleSubmit,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    child: Text('Create Task'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _formData.dispose();
    super.dispose();
  }
}