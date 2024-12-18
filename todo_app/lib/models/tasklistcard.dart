import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/periodicity.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_detail_view.dart'; // Import the file where `Todo` is defined

class TaskListCard extends StatefulWidget {
  const TaskListCard({
    required this.task,
    required this.selectedSort,
  });

  final Todo task;
  final String selectedSort;

  @override
  TaskListCardState createState() => TaskListCardState();
}

class TaskListCardState extends State<TaskListCard> {
  bool _isExpanded = false; // Tracks the expansion state of the card

  @override
  Widget build(BuildContext context) {
    var task = widget.task; // Accessing task via widget.task
    var theme = Theme.of(context);
    var selectedSort = widget.selectedSort;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            // FIRST SECTION
            TaskCardFirstSection(
              task: task,
              isExpanded: _isExpanded,
              onExpandToggle: () {
                // Pass the toggle callback
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              selectedSort: selectedSort,
              onDetailView: _isExpanded 
              ? () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TodoDetailView(todo: task),
                    ),
                  );
                } 
              : null,
            ),
            // SECOND SECTION
            TaskCardSecondSection(
              task: task,
              isExpanded: _isExpanded,
            ),
            // THIRD SECTION
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

/// First section of the TaskListCard
// class TaskCardFirstSection extends StatelessWidget {
//   const TaskCardFirstSection({
//     super.key,
//     required this.task,
//     required this.isExpanded,
//     required this.onExpandToggle,
//     required this.selectedSort,
//     this.onDetailView,
//   });

//   final Todo task;
//   final bool isExpanded;
//   final VoidCallback onExpandToggle;
//   final String selectedSort;
//   final VoidCallback? onDetailView;

//   @override
//   Widget build(BuildContext context) {
//     var theme = Theme.of(context);
//     var titleStyle = theme.textTheme.titleMedium!.copyWith(
//       //color: theme.colorScheme.onPrimary,
//     );

//       String label = task.dueDate != null
//             ? DateFormat('MMM d').format(task.dueDate!)
//             : "ND";

//     // String? label;
//     // switch (selectedSort) {
//     //   case "dueDate":
//     //     label = task.dueDate != null
//     //         ? DateFormat('MMM d').format(task.dueDate!)
//     //         : "ND";
//     //     break;
//     //   case "priority":
//     //     label = task.importanceLevel.toString();
//     //     break;
//     //   case "tag":
//     //     label = task.dueDate != null
//     //         ? DateFormat('MMM d').format(task.dueDate!)
//     //         : "ND";
//     //     break;
//     //   case "cemetery":
//     //     label = null;
//     //     break;
//     //   case "title":
//     //     label = task.dueDate != null
//     //         ? DateFormat('MMM d').format(task.dueDate!)
//     //         : "ND";
//     //     break;
//     //   default:
//     //     throw UnimplementedError(
//     //         'Unhandled sorting parameter chosen for task viewing');
//     // }

//     return Row(
//       children: [
//         Container(
//           // label on the left
//           decoration: BoxDecoration(
//             //color: theme.colorScheme.primary,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//           child: Text(
//             label ?? "", // uses label if not null, else uses ""
//             style: theme.textTheme.titleMedium!.copyWith(
//               // color: theme.colorScheme.onPrimary,
//             ),
//           ),
//         ),
//         SizedBox(
//           // height: !isExpanded ? 25 : null,
//           //width: 230, // task title width limitation
//           width: MediaQuery.of(context).size.width - 200,
//           child: Container(
//             padding: EdgeInsets.symmetric(horizontal: 6),
//             child: Text(
//               task.title,
//               maxLines: !isExpanded ? 1 : 4, // Limit lines when collapsed
//               overflow: TextOverflow.ellipsis, // Add ellipsis if cropped
//               style: titleStyle,
//               semanticsLabel: task.title,
//             ),
//           ),
//         ),
//         // Flexible(
//         //   child: Tooltip(
//         //     message: task.title,
//         //     child: Container(
//         //       padding: EdgeInsets.symmetric(horizontal: 6),
//         //       child: Text(
//         //         task.title,
//         //         maxLines: !isExpanded ? 1 : 2,
//         //         overflow: TextOverflow.ellipsis,
//         //         style: titleStyle,
//         //         semanticsLabel: task.title,
//         //       ),
//         //     ),
//         //   ),
//         // ),
//         // Flexible(
//         //   child: Container(
//         //     padding: EdgeInsets.symmetric(horizontal: 6),
//         //     child: Text(
//         //       task.title,
//         //       maxLines: !isExpanded ? 1 : null, // Changez null au lieu de 2 quand étendu
//         //       overflow: !isExpanded ? TextOverflow.ellipsis : TextOverflow.visible, // Ajustez le comportement de l'overflow
//         //       style: titleStyle,
//         //       semanticsLabel: task.title,
//         //     ),
//         //   ),
//         // ),
//         Spacer(), // to push the expand/collapse button to the right
//         if (isExpanded)
//           IconButton(
//             icon: Icon(Icons.visibility, color: theme.colorScheme.primary),
//             onPressed: onDetailView,
//           ),
//         IconButton(
//           icon: Icon(
//             isExpanded ? Icons.expand_less : Icons.expand_more,
//             // color: theme.colorScheme.onPrimary,
//           ),
//           onPressed: onExpandToggle,
//         ),
//       ],
//     );
//   }
// }

class TaskCardFirstSection extends StatelessWidget {
  const TaskCardFirstSection({
    super.key,
    required this.task,
    required this.isExpanded,
    required this.onExpandToggle,
    required this.selectedSort,
    this.onDetailView,
  });

  final Todo task;
  final bool isExpanded;
  final VoidCallback onExpandToggle;
  final String selectedSort;
  final VoidCallback? onDetailView;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleMedium!.copyWith();

    String label = task.dueDate != null
          ? DateFormat('MMM d').format(task.dueDate!)
          : "ND";

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          child: Text(
            label,
            style: theme.textTheme.titleMedium!.copyWith(),
          ),
        ),
        SizedBox(width: 8),
        SizedBox(
          width: MediaQuery.of(context).size.width - 250,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              task.title,
              maxLines: !isExpanded ? 1 : 4,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
              semanticsLabel: task.title,
            ),
          ),
        ),
        Spacer(),
        if (!isExpanded)
          IconButton(
            icon: Icon(Icons.expand_more),
            onPressed: onExpandToggle,
          )
        else
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.expand_less),
                onPressed: onExpandToggle,
              ),
              IconButton(
                icon: Icon(Icons.visibility),
                onPressed: onDetailView,
              ),
            ],
          ),
      ],
    );
  }
}

/// Second section of the TaskListCard:
/// tags and content icons
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
          Icons.tag,
          // color: theme.colorScheme.onSecondary,
        ),
        Expanded(
          child: SizedBox(
            // tags
            height: 28,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Allow horizontal scrolling
              child: Row(
                children: [
                  for (var tag in task.tags)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: Container(
                        decoration: BoxDecoration(
                          // color: theme.colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        child: Text(
                          isExpanded
                          ? tag
                          : tag.length >= 4
                              ? tag.substring(0,4)
                              : tag, // show only the first 6 letters of the tag
                          style: isExpanded
                              ? theme.textTheme.bodyMedium!
                                  .copyWith() //copyWith(color: theme.colorScheme.onTertiary)
                              : theme.textTheme.bodyLarge!.copyWith(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        !isExpanded
            ? Row(
                children: [
                  if (task.startDate != null) Icon(Icons.event),
                  if (formatTaskPeriodicity(task.periodicity) != null)
                    Icon(Icons.event_repeat),
                  if (task.description.isNotEmpty) Icon(Icons.description),
                  if (task.tasks.isNotEmpty) Icon(Icons.playlist_play),
                  if (task.links.isNotEmpty) Icon(Icons.link),
                  if (task.folders.isNotEmpty) Icon(Icons.collections),
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
    var contentStyle = theme.textTheme.bodyMedium!
        .copyWith();
    var taskDateStr = formatTaskDate(task.startDate, task.dueDate);
    var taskPeriodicityStr = formatTaskPeriodicity(task.periodicity);

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: isExpanded
          ? // Expanded card content (exclusively)
          Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Row(
                    // FIRST ROW
                    // priority/importance level
                    crossAxisAlignment:
                        CrossAxisAlignment.start, // Align icon to top
                    // children: [
                    //   Icon(Icons.format_list_numbered),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    //     child: Text(
                    //       "priority ${task.importanceLevel}",
                    //       style: contentStyle,
                    //     ),
                    //   ),
                    //   // Event dates
                    //   taskDateStr != null
                    //       ? Row(
                    //           children: [
                    //             SizedBox(width: 20),
                    //             Icon(Icons.event),
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 4.0),
                    //               child: Text(
                    //                 taskDateStr,
                    //                 style: contentStyle,
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       : Padding(padding: const EdgeInsets.all(0)),
                    //   // Periodicity
                    //   taskPeriodicityStr != null
                    //       ? Row(
                    //           children: [
                    //             SizedBox(width: 20),
                    //             Icon(Icons.event_repeat),
                    //             Padding(
                    //               padding: const EdgeInsets.symmetric(
                    //                   horizontal: 4.0),
                    //               child: Text(
                    //                 taskPeriodicityStr,
                    //                 style: contentStyle,
                    //               ),
                    //             ),
                    //           ],
                    //         )
                    //       : Padding(padding: const EdgeInsets.all(0))
                    // ],
                    children: [
                      Icon(Icons.format_list_numbered),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: Text(
                                  "priority ${task.importanceLevel}",
                                  style: contentStyle,
                                  softWrap: false,
                                ),
                              ),
                              // Event dates
                              taskDateStr != null
                                ? Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Icon(Icons.event),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: Text(
                                          taskDateStr,
                                          style: contentStyle,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink(),
                              // Periodicity
                              taskPeriodicityStr != null
                                ? Row(
                                    children: [
                                      SizedBox(width: 20),
                                      Icon(Icons.event_repeat),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: Text(
                                          taskPeriodicityStr,
                                          style: contentStyle,
                                          softWrap: false,
                                        ),
                                      ),
                                    ],
                                  )
                                : SizedBox.shrink()
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
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
                          maxLines: 6,
                          overflow: TextOverflow.ellipsis,
                          style: contentStyle,
                        ),
                      ),
                    ],
                  ),
                  if (task.tasks.isNotEmpty) SizedBox(height: 5),
                  if (task.tasks.isNotEmpty)
                    Row(
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
                            child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 160.0, // Max height of 200
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (var subtask in task.tasks)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2.0, vertical: 4.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        // color: contentStyle.color,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      child: Text(
                                        subtask.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.bodyMedium!
                                            .copyWith(),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        )),
                      ],
                    ),
                  if (task.links.isNotEmpty) SizedBox(height: 5),
                  if (task.links.isNotEmpty)
                    Row(
                      // FOURTH ROW
                      // links
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Align icon to top
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 2.0),
                          child: Icon(Icons.link),
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var link in task.links)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Text(
                                  link,
                                  style: contentStyle,
                                ),
                              ),
                          ],
                        )),
                      ],
                    ),
                  if (task.folders.isNotEmpty) SizedBox(height: 5),
                  if (task.folders.isNotEmpty)
                    Row(
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

String? formatTaskDate(DateTime? startDate, DateTime? endDate) {
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

String? formatTaskPeriodicity(Periodicity? periodicity) {
  if (periodicity == null ||
      (periodicity.years <= 0 &&
          periodicity.months <= 0 &&
          periodicity.days <= 0)) {
    return null; // For null or zero duration
  }

  int days = periodicity.days;

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
