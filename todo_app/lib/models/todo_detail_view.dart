

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/database_manager.dart';
import 'package:todo_app/models/todo.dart';

class TodoDetailView extends StatefulWidget {
  final Todo todo;

  const TodoDetailView({Key? key, required this.todo}) : super(key: key);

  @override
  _TodoDetailViewState createState() => _TodoDetailViewState();
}

class _TodoDetailViewState extends State<TodoDetailView> {
  late Todo _todo;

  @override
  void initState() {
    super.initState();
    _todo = widget.todo;//.copyWith();
  }

  void _toggleSubtaskCompletion(TodoTask task) {
    setState(() {
      // Find the index of the task in the list
      int index = _todo.tasks.indexWhere((t) => t == task);
      if (index != -1) {
        // Create a new task with toggled completion status
        _todo.tasks[index] = _todo.tasks[index].copyWith(
          isCompleted: !_todo.tasks[index].isCompleted
        );
      }
    });
  }

  bool _areAllSubtasksCompleted() {
    return _todo.tasks.isNotEmpty && 
           _todo.tasks.every((task) => task.isCompleted);
  }

  void _saveSubtaskChanges() async {
    // Update the task in the database
    await DatabaseManager.instance.updateTask(_todo);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Add WillPopScope to handle back navigation
      onWillPop: () async {
        // Save subtask changes before leaving
        _saveSubtaskChanges();
        return true; // Allow navigation back
      },
      child: Scaffold(
            appBar: AppBar(
              title: Text(_todo.title),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigation vers l'édition de la tâche
                    // Navigator.push(context, MaterialPageRoute(...))
                  },
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Informations principales
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _todo.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _todo.description.isNotEmpty ? _todo.description : 'No description',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text('Importance : '),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getImportanceColor(_todo.importanceLevel),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  _todo.importanceLevelText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (_todo.tags.isNotEmpty)
                            Wrap(
                              spacing: 8,
                              children: _todo.tags.map((tag) => 
                                Chip(label: Text(tag))
                              ).toList(),
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Section Dates
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Dates',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildDetailRow('Start Date', _todo.formattedStartDate),
                          _buildDetailRow('End Date', _todo.formattedDueDate),
                          _buildDetailRow('Periodicity', _todo.periodicityText),
                        ],
                      ),
                    ),
                  ),

                  // Section Sous-tâches
                  if (_todo.tasks.isNotEmpty)
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Subtasks',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...List<Widget>.generate(_todo.tasks.length, (index) {
                              final task = _todo.tasks[index];
                              return CheckboxListTile(
                                title: Text(task.title),
                                subtitle: Text(task.description),
                                value: task.isCompleted,
                                onChanged: (bool? value) {
                                  _toggleSubtaskCompletion(task);
                                },
                                secondary: task.isCompleted 
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : const Icon(Icons.pending, color: Colors.orange),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              heroTag: 'save',
              onPressed: () {
                _saveSubtaskChanges();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Changes saved')),
                );
              },
              child: const Icon(Icons.save),
            ),
            const SizedBox(height: 10),
            FloatingActionButton(
              heroTag: 'complete',
              onPressed: () {
                var appState = Provider.of<MyAppState>(context, listen: false);
                
                if (_areAllSubtasksCompleted()) {
                  appState.completeTask(_todo);
                  // Use Navigator.of(context).popUntil to return to the previous screen
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Incomplete Subtasks'),
                        content: const Text('Do you really want to mark this task as completed? Some subtasks are still in progress.'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Confirm'),
                            onPressed: () {
                              appState.completeTask(_todo);
                              // Use Navigator.of(context).popUntil to return to the first route
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Icon(Icons.check),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode utilitaire pour créer des lignes de détail
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  // Méthode pour obtenir une couleur basée sur le niveau d'importance
  Color _getImportanceColor(int level) {
    switch (level) {
      case 1: return Colors.green;
      case 2: return Colors.lightGreen;
      case 3: return Colors.orange;
      case 4: return Colors.deepOrange;
      case 5: return Colors.red;
      default: return Colors.grey;
    }
  }
}
