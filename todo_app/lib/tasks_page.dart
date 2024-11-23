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
    var titleStyle = theme.textTheme.titleLarge!.copyWith(
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
          _TaskListCard(
            task: task,
          ),
      ],
    );
  }
}

class _TaskListCard extends StatefulWidget {
  const _TaskListCard({
    required this.task,
  });

  final Todo task;

  @override
  _TaskListCardState createState() => _TaskListCardState();
}

class _TaskListCardState extends State<_TaskListCard> {
  bool _isExpanded = false; // Tracks the expansion state of the card

  @override
  Widget build(BuildContext context) {
    var task = widget.task; // Accessing task via widget.task
    var theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.secondary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // FIRST ROW
            TaskCardFirstSection(
              task: task,
              isExpanded: _isExpanded,
              onExpandToggle: () {
                // Pass the toggle callback
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
            // SECOND ROW
            TaskCardSecondSection(
              task: task,
              isExpanded: _isExpanded,
            ),
            // THIRD ROW
            TaskCardThirdSection(
              task: task,
              isExpanded: _isExpanded,
            ),
          ],
        ),
      ),
    );
  }
}

/// First row of the TaskListCard
class TaskCardFirstSection extends StatelessWidget {
  const TaskCardFirstSection({
    super.key,
    required this.task,
    required this.isExpanded,
    required this.onExpandToggle,
  });

  final Todo task;
  final bool isExpanded;
  final VoidCallback onExpandToggle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    var sortingMethod = "date";
    String? label;
    switch (sortingMethod) {
      case "date":
        label = task.dueDate != null
            ? DateFormat('MMM d').format(task.dueDate!)
            : "no date";
        break;
      case "priority":
        label = task.importanceLevel.toString();
        break;
      case "tag":
        label = task.tags.isEmpty ? task.tags[0].toString() : "ND";
        label.length >= 5 ? label.substring(0, 5) : label;
        break;
      case "cemetery":
        label = null;
        break;
      default:
        throw UnimplementedError('no sorting method chosen for task viewing');
    }

    return Row(
      children: [
        Container(
          // label on the left
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            label ?? "", // uses label if not null, else uses ""
            style: theme.textTheme.titleMedium!.copyWith(
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 25,
          width: 250, // task title width limitation
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              task.title,
              style: titleStyle,
              semanticsLabel: task.title,
            ),
          ),
        ),
        Spacer(), // to push the expand/collapse button to the right
        IconButton(
          icon: Icon(
            isExpanded ? Icons.expand_less : Icons.expand_more,
            color: theme.colorScheme.onPrimary,
          ),
          onPressed: onExpandToggle,
        ),
      ],
    );
  }
}

/// Second row of the TaskListCard
class TaskCardSecondSection extends StatelessWidget {
  const TaskCardSecondSection({
    super.key,
    required this.task,
    required this.isExpanded,
  });

  final Todo task;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Row(
      children: [
        Icon(
          // tags
          Icons.tag,
          color: theme.colorScheme.onSecondary,
        ),
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
                style: isExpanded
                    ? theme.textTheme.bodyMedium!
                        .copyWith(color: theme.colorScheme.onTertiary)
                    : theme.textTheme.bodyLarge!
                        .copyWith(color: theme.colorScheme.onTertiary),
              ),
            ),
          ),
        Spacer(),
        !isExpanded
            ? Row(
                // content icons
                children: [
                  // timeframe (dates) / periodicity
                  task.startDate == null
                      ? Padding(padding: const EdgeInsets.all(0))
                      : Icon(Icons.event),
                  // periodicity
                  getTaskPeriodicityString(task.periodicity) == null
                      ? Padding(padding: const EdgeInsets.all(0))
                      : Icon(Icons.event_repeat),
                  // description
                  task.description.isEmpty
                      ? Padding(padding: const EdgeInsets.all(0))
                      : Icon(Icons.description),
                  // subtasks
                  task.tasks.isEmpty
                      ? Padding(padding: const EdgeInsets.all(0))
                      : Icon(Icons.playlist_play),
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
    );
  }
}

/// Third row of the TaskListCard (expanded/collapsed card content)
class TaskCardThirdSection extends StatelessWidget {
  const TaskCardThirdSection({
    super.key,
    required this.task,
    required this.isExpanded,
  });

  final Todo task;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var contentStyle = theme.textTheme.bodyMedium!.copyWith(
      color: theme.colorScheme.onSurface
    );
    var taskDateStr = getTaskDateString(task.startDate, task.dueDate);
    var taskPeriodicityStr = getTaskPeriodicityString(task.periodicity);

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isExpanded
          ? // Expanded card content (exclusively)
          Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // FIRST ROW
                    // priority/importance level
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align icon to top
                    children: [
                      Icon(Icons.format_list_numbered),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          "priority ${task.importanceLevel}",
                          style: contentStyle,
                        ),
                      ),
                      // Event dates
                      taskDateStr != null
                          ? Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(Icons.event),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    taskDateStr,
                                    style: contentStyle,
                                  ),
                                ),
                              ],
                            )
                          : Padding(padding: const EdgeInsets.all(0)),
                      // Periodicity
                      taskPeriodicityStr != null
                          ? Row(
                              children: [
                                SizedBox(width: 20),
                                Icon(Icons.event_repeat),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 4.0),
                                  child: Text(
                                    taskPeriodicityStr,
                                    style: contentStyle,
                                  ),
                                ),
                              ],
                            )
                          : Padding(padding: const EdgeInsets.all(0))
                    ],
                  ),
                  Row(
                    // SECOND ROW
                    // description
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align icon to top
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Icon(Icons.description),
                      ),
                      Expanded(
                        child: Text(
                          task.description,
                          style: contentStyle,
                        ),
                      ),
                    ],
                  ),
                  task.tasks.isEmpty
                  ? Padding(padding: const EdgeInsets.all(0))
                  : Row(
                    // THIRD ROW
                    // sub-tasks
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align icon to top
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0, top: 4.0),
                        child: Icon(Icons.playlist_play),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var subtask in task.tasks)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 4.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: contentStyle.color,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                child: Text(
                                  subtask.title,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                      color: theme.colorScheme.onTertiary),
                                ),
                              ),
                            ),
                        ],
                      )),
                    ],
                  ),
                  task.links.isEmpty
                  ? Padding(padding: const EdgeInsets.all(0))
                  : Row(
                    // FOURTH ROW
                    // links
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align icon to top
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0, top: 4.0),
                        child: Icon(Icons.link),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var link in task.links)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 4.0),
                              child: Text(
                                link,
                                style: contentStyle,
                              ),
                            ),
                        ],
                      )),
                    ],
                  ),
                  task.links.isEmpty
                  ? Padding(padding: const EdgeInsets.all(0))
                  : Row(
                    // FIFTH ROW
                    // folders
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align icon to top
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 2.0, top: 4.0),
                        child: Icon(Icons.collections),
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var folder in task.folders)
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 4.0),
                              child: Text(
                                folder,
                                style: contentStyle,
                              ),
                            ),
                        ],
                      )),
                    ],
                  ),
                  // Add expanded card content here
                ],
              ),
            )
          : // COLLAPSED CARD CONTENT (exclusively)
          SizedBox.shrink(),
    );
  }
}

String? getTaskDateString(DateTime? startDate, DateTime? endDate) {
  // Define the desired date format
  DateFormat formatter = DateFormat('MMM d');

  // Check conditions and format appropriately
  if (startDate != null && endDate != null) {
    return '${formatter.format(startDate)} ~ ${formatter.format(endDate)}';
  } else if (startDate != null) {
    return '${formatter.format(startDate)} ~';
  } else if (endDate != null) {
    return '~ ${formatter.format(endDate)}';
  } else {
    return null;
  }
}

String? getTaskPeriodicityString(Duration? periodicity) {
  if (periodicity == null || periodicity.inDays <= 0) {
    return null; // For null or zero duration
  }

  int days = periodicity.inDays;

  if (days < 7) {
    // Less than a week, use days
    return '$days day${days > 1 ? 's' : ''}';
  } else if (days < 30) {
    // Less than a month, use weeks
    int weeks = (days / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''}';
  } else if (days < 365) {
    // Less than a year, use months
    int months = (days / 30).floor();
    return '$months month${months > 1 ? 's' : ''}';
  } else {
    // For periods of a year or more, use years
    int years = (days / 365).floor();
    return '$years year${years > 1 ? 's' : ''}';
  }
}
