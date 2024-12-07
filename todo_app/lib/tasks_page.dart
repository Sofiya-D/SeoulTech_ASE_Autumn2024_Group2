import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart'; // Import the state management file containing `MyAppState`
import 'package:todo_app/models/periodicity.dart';
import 'package:todo_app/models/todo.dart'; // Import the file where `Todo` is defined

import 'package:todo_app/models/task_sorter.dart';
import 'package:todo_app/models/tasklistcard.dart';

/// !TODO! add filter (case: page "today" is a subset of "due-date")

class TasksPage extends StatefulWidget {
  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  String selectedSort = 'priority'; // Default sorting criteria

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.onSurface,
    );

    if (appState.taskList.isEmpty) {
      return Center(
        child: Text('No task yet.'),
      );
    }

    // Sort tasks based on the selected criteria
    var sortedTasks = sortTasks(appState.taskList, selectedSort);

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'You have ${sortedTasks.length} tasks:',
                  style: titleStyle,
                ),
              ),
              // Add the sorting selector
              DropdownButton<String>(
                value: selectedSort,
                items: [
                  DropdownMenuItem(
                      value: 'priority', child: Text('Sort by Priority')),
                  DropdownMenuItem(
                      value: 'dueDate', child: Text('Sort by Due Date')),
                  DropdownMenuItem(
                      value: 'title', child: Text('Sort by Title')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedSort = value; // Update the sorting criteria
                    });
                  }
                },
              ),
            ],
          ),
          TaskListSection(taskSubList: sortedTasks, selectedSort: selectedSort)
        ],
      ),
    );
  }
}

class TaskListSection extends StatefulWidget {
  const TaskListSection({
    required this.taskSubList,
    required this.selectedSort,
  });

  final List<Todo> taskSubList;
  final String selectedSort;

  @override
  TaskListSectionState createState() => TaskListSectionState();
}

class TaskListSectionState extends State<TaskListSection> {
  bool _isExpanded = false; // Tracks the expansion state of the card

  @override
  Widget build(BuildContext context) {
    var taskSubList = widget.taskSubList; // Accessing task via widget.task
    var theme = Theme.of(context);
    var selectedSort = widget.selectedSort;

    return Column(
      children: [
        Row(
          children: [
            Text(
              "hello",
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
            ),
            Spacer(), // to push the expand/collapse button to the right
            IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: () {
                // Pass the toggle callback
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ],
        ),
        AnimatedSize(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height *
                        0.7, // or some other reasonable constraint
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (var task in taskSubList)
                        TaskListCard(
                          task: task,
                          selectedSort: selectedSort,
                        ),
                    ],
                  ),
                )
              : // COLLAPSED CARD CONTENT (exclusively)
              SizedBox.shrink(),
        )
      ],
    );
  }
}
