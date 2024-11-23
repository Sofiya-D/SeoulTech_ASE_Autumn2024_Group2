import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart'; // Import the state management file containing `MyAppState`
import 'package:todo_app/models/todo.dart'; // Import the file where `Todo` is defined

/// !TODO! add filter (case: page "today" is a subset of "due-date")

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
    var sortingMethod = "date";
    var label;
    switch(sortingMethod) {
      case "date":
        label = task.dueDate != null 
          ? DateFormat('MMM d').format(task.dueDate!) 
          : "no date";
        break;
      case "priority":
        label = task.importanceLevel != null 
          ? task.importanceLevel.toString()
          : "ND";
        break;
      case "tag":
        label = task.tags.isEmpty 
          ? task.tags[0].toString()
          : "ND";
        label.length >= 5 ? label.substring(0, 5) : label;
        break;
      case "cemetery":
        label = null;
        break;
      default:
        throw UnimplementedError('no sorting method chosen for task viewing');
    }

    return Card(
      color: theme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Row( // FIRST ROW
              children: [
                Container( // label on the left
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium!.copyWith(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                  width: 270,
                  child: Container( // task title
                    padding: EdgeInsets.symmetric(horizontal: 6),
                    child: Text(
                      task.title,
                      style: titleStyle,
                      semanticsLabel: task.title,
                    ),
                  ),
                ),
                Spacer(),  // to push the expand/collapse button to the right
                IconButton(
                  icon: Icon(
                    _isExpanded 
                        ? Icons.expand_less 
                        : Icons.expand_more,
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
                for (var tag in task.tags)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      child: Text(
                        tag.length >= 5 ? tag.substring(0, 5) : tag,
                        style: theme.textTheme.bodyLarge!.copyWith(
                          color: theme.colorScheme.onTertiary,
                        ),
                      ),
                    ),
                  ),
                Spacer(),
                !_isExpanded
                ? Row(
                  children: [
                    // timeframe (dates)
                    // periodicity
                    task.periodicity==null
                    ? Padding(
                        padding: const EdgeInsets.all(0),
                        child: task.startDate==null
                        ? Padding(padding: const EdgeInsets.all(0))
                        : Icon(Icons.event),
                      )
                    : Icon(Icons.event_repeat),
                    // description
                    task.description.isEmpty
                    ? Padding(padding: const EdgeInsets.all(0))
                    : Icon(Icons.description),
                    // links
                    task.links.isEmpty
                    ? Padding(padding: const EdgeInsets.all(0))
                    : Icon(Icons.link),
                    // folders
                    task.folders.isEmpty
                    ? Padding(padding: const EdgeInsets.all(0))
                    : Icon(Icons.collections),
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
