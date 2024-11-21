import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart'; // Import the state management file containing `MyAppState`
import 'package:todo_app/models/todo.dart'; // Import the file where `Todo` is defined

/// add filter (page "today" is a subset of "due-date")


class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onSurface,
    );

    if (appState.taskList.isEmpty) {
      return Center(
        child: Text('No task yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            'You have ${appState.taskList.length} tasks:',
            style: titleStyle,
          ),
        ),
        for (var task in appState.taskList)
          TaskListCard(
            task: task,
          ),
      ],
    );
  }
}

class TaskListCard extends StatefulWidget {
  const TaskListCard({
    super.key,
    required this.task,
  });

  final Todo task;

  @override
  _TaskListCardState createState() => _TaskListCardState();
}

class _TaskListCardState extends State<TaskListCard> {
  bool _isExpanded = false; // Tracks the expansion state of the card

  @override
  Widget build(BuildContext context) {
    var task = widget.task; // Accessing task via widget.task
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var labelStyle = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    var date = task.dueDate != null 
      ? DateFormat('MMM d').format(task.dueDate!) 
      : "no date";

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row( // FIRST ROW
              children: [
                Container( // label on the left
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    date,
                    style: labelStyle,
                  ),
                ),
                Container( // task title
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    task.title,
                    style: titleStyle,
                    semanticsLabel: task.title,
                  ),
                ),
                Spacer(),  // to push the expand/collapse button to the right
                IconButton(
                  icon: Icon(
                    _isExpanded 
                        ? Icons.arrow_drop_up 
                        : Icons.arrow_drop_down,
                    color: theme.colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                ),
              ],
            ),
            Row( // SECOND ROW
              children: [
                Icon(Icons.tag),
                Spacer(),
                !_isExpanded
                ? Row(
                  children: [
                    // timeframe (dates)
                    task.startDate==null
                    ? Icon(Icons.not_accessible) // FIND A BETTER ICON
                    : Icon(Icons.date_range),
                    // periodicity
                    task.periodicity==null
                    ? Icon(Icons.not_accessible) // FIND A BETTER ICON
                    : Icon(Icons.update),
                    // description
                    task.description.isEmpty
                    ? Icon(Icons.no_accounts)
                    : Icon(Icons.description),
                    // links
                    task.links.isEmpty
                    ? Icon(Icons.link_off)
                    : Icon(Icons.link),
                    // folders
                    task.folders.isEmpty
                    ? Icon(Icons.folder_off)
                    : Icon(Icons.folder),
                  ],
                )
                : SizedBox.shrink(),
              ],
            ),
            AnimatedSize( // THIRD "ROW"
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded 
              ? // EXPANDED CARD CONTENT (exclusively)
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Details: ${widget.task.description}', // Accessing task via widget.task
                        style: theme.textTheme.bodyMedium!.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      // Add more widgets here to show more details
                    ],
                  ),
                )
              : // COLLAPSED CARD CONTENT (exclusively)
              SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
