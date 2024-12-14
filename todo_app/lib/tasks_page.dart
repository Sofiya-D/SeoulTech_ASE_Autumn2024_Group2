// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app/main.dart'; // Import the state management file containing `MyAppState`
// import 'package:todo_app/models/todo.dart'; // Import the file where `Todo` is defined

// import 'package:todo_app/models/task_sorter.dart';
// import 'package:todo_app/models/tasklistcard.dart';
// import 'package:todo_app/models/todo_detail_view.dart';

// /// !TODO! add filter (case: page "today" is a subset of "due-date")

// class TasksPage extends StatefulWidget {
//   @override
//   TasksPageState createState() => TasksPageState();
// }

// class TasksPageState extends State<TasksPage> {
//   String selectedSort = 'dueDate'; // Default sorting criteria

//   @override
//   Widget build(BuildContext context) {
//     var appState = context.watch<MyAppState>();
//     var theme = Theme.of(context);
//     var titleStyle = theme.textTheme.titleLarge!.copyWith();

//     if (appState.taskList.isEmpty) {
//       return Center(
//         child: Text('No task yet.'),
//       );
//     }

//     // Sort tasks based on the selected criteria
//     var sortedTasks = sortTasks(appState.taskList, selectedSort);

//     // Sort tasks based on the selected criteria
//     var groupedTasks = groupTasksByCriteria(sortedTasks, selectedSort);

//     return Container(
//       color: theme.colorScheme.surface,
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right: 15.0),
//                   child: Text(
//                     'You have ${sortedTasks.length} tasks:',
//                     style: titleStyle,
//                   ),
//                 ),
//                 // Add the sorting selector
//                 DropdownButton<String>(
//                   value: selectedSort,
//                   items: [
//                     DropdownMenuItem(
//                         value: 'dueDate', child: Text('Sort by Due Date')),
//                     DropdownMenuItem(
//                         value: 'priority', child: Text('Sort by Priority')),
//                     DropdownMenuItem(
//                         value: 'tag', child: Text('Sort by Tag')),
//                     DropdownMenuItem(
//                         value: 'title', child: Text('Sort by Title')),
//                   ],
//                   onChanged: (value) {
//                     if (value != null) {
//                       setState(() {
//                         selectedSort = value; // Update the sorting criteria
//                       });
//                     }
//                   },
//                 ),
//               ],
//             ),
//             // option 1
//             // TaskListSection(
//             //     sectionTitle: "Section 1",
//             //     taskSubList: sortedTasks,
//             //     selectedSort: selectedSort)
//             // end of option 1
//             // option 2
//             Expanded(
//               child: ListView(
//                 children: groupedTasks.entries.map((entry) {
//                   return TaskListSection(
//                     sectionTitle: entry.key,
//                     taskSubList: entry.value,
//                     selectedSort: selectedSort,
//                   );
//                 }).toList(),
//               ),
//             ),
//             // end of option 2
//           ],
//         ),
//       ),
//     );
//   }
// }

// class TaskListSection extends StatefulWidget {
//   const TaskListSection({
//     required this.sectionTitle,
//     required this.taskSubList,
//     required this.selectedSort,
//   });

//   final String sectionTitle;
//   final List<Todo> taskSubList;
//   final String selectedSort;

//   @override
//   TaskListSectionState createState() => TaskListSectionState();
// }

// class TaskListSectionState extends State<TaskListSection> {
//   bool _isExpanded = false; // Tracks the expansion state of the card

//   @override
//   Widget build(BuildContext context) {
//     var sectionTitle = widget.sectionTitle;
//     var taskSubList = widget.taskSubList; // Accessing task via widget.task
//     var theme = Theme.of(context);
//     var selectedSort = widget.selectedSort;

//     return Column(
//       children: [
//         Row(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(right: 10.0),
//               child: Text(
//                 sectionTitle,
//                 style: theme.textTheme.titleMedium!.copyWith(
//                   //color: theme.colorScheme.onSurface,
//                 ),
//               ),
//             ),
//             IconButton(
//               icon: Icon(
//                 _isExpanded ? Icons.expand_less : Icons.expand_more,
//                 // color: theme.colorScheme.onSurface,
//               ),
//               onPressed: () {
//                 // Pass the toggle callback
//                 setState(() {
//                   _isExpanded = !_isExpanded;
//                 });
//               },
//             ),
//           ],
//         ),
//         AnimatedSize(
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeInOut,
//           child: _isExpanded
//               ? Container(
//                   constraints: BoxConstraints(
//                     maxHeight: MediaQuery.of(context).size.height *
//                         0.7, // or some other reasonable constraint
//                   ),
//                   child: ListView(
//                     shrinkWrap: true,
//                     children: [
//                       for (var task in taskSubList)
//                         Column(
//                           children: [
//                             TaskListCard(
//                               task: task,
//                               selectedSort: selectedSort,
//                             ),
//                           ],
//                         ),
//                     ],
//                   ),
//                 )
//               : // COLLAPSED CARD CONTENT (exclusively)
//               SizedBox.shrink(),
//         )
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/models/todo.dart';

import 'package:todo_app/models/task_sorter.dart';
import 'package:todo_app/models/tasklistcard.dart';
import 'package:todo_app/models/todo_detail_view.dart';

class TasksPage extends StatefulWidget {
  @override
  TasksPageState createState() => TasksPageState();
}

class TasksPageState extends State<TasksPage> {
  String selectedSort = 'dueDate'; // Default sorting criteria

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var theme = Theme.of(context);
    var titleStyle = theme.textTheme.titleLarge!.copyWith();

    if (appState.taskList.isEmpty) {
      return Center(
        child: Text('No task yet.'),
      );
    }

    // Sort tasks based on the selected criteria
    var sortedTasks = sortTasks(appState.taskList, selectedSort);

    // Sort tasks based on the selected criteria
    var groupedTasks = groupTasksByCriteria(sortedTasks, selectedSort);

    return Container(
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
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
                        value: 'dueDate', child: Text('Sort by Due Date')),
                    DropdownMenuItem(
                        value: 'priority', child: Text('Sort by Priority')),
                    DropdownMenuItem(
                        value: 'tag', child: Text('Sort by Tag')),
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
          ),
          Expanded(
            child: ListView(
              children: groupedTasks.entries.map((entry) {
                return TaskListSection(
                  sectionTitle: entry.key,
                  taskSubList: entry.value,
                  selectedSort: selectedSort,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class TaskListSection extends StatefulWidget {
  const TaskListSection({
    required this.sectionTitle,
    required this.taskSubList,
    required this.selectedSort,
  });

  final String sectionTitle;
  final List<Todo> taskSubList;
  final String selectedSort;

  @override
  TaskListSectionState createState() => TaskListSectionState();
}

class TaskListSectionState extends State<TaskListSection> {
  bool _isExpanded = false; // Tracks the expansion state of the card

  @override
  Widget build(BuildContext context) {
    var sectionTitle = widget.sectionTitle;
    var taskSubList = widget.taskSubList;
    var theme = Theme.of(context);
    var selectedSort = widget.selectedSort;

    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Text(
                sectionTitle,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded ? Icons.expand_less : Icons.expand_more,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
            ),
          ],
        ),
        if (_isExpanded)
          ...taskSubList.map((task) => TaskListCard(
                task: task,
                selectedSort: selectedSort,
              )).toList(),
      ],
    );
  }
}