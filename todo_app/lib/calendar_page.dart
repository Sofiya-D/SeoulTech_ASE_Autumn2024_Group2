import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/main.dart';


class CalendarPage extends StatefulWidget {
  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Todo>> _groupedTasks = {};

  @override
  void initState() {
    super.initState();
    _groupTasksByDate();
  }

  void _groupTasksByDate() {
    final appState = Provider.of<MyAppState>(context, listen: false);

    // Clear grouped tasks before updating
    _groupedTasks.clear();

    for (var task in appState.taskList) {
      if (task.startDate != null && task.dueDate != null) {
        if (task.startDate!.isAtSameMomentAs(task.dueDate!)) {
          // Single-day task
          final dayKey = DateTime(task.startDate!.year, task.startDate!.month, task.startDate!.day);
          if (_groupedTasks[dayKey] == null) {
            _groupedTasks[dayKey] = [];
          }
          _groupedTasks[dayKey]!.add(task);
        } else {
          // Multi-day task
          DateTime currentDate = task.startDate!;
          while (!currentDate.isAfter(task.dueDate!)) {
            final dayKey = DateTime(currentDate.year, currentDate.month, currentDate.day);
            if (_groupedTasks[dayKey] == null) {
              _groupedTasks[dayKey] = [];
            }
            _groupedTasks[dayKey]!.add(task);

            // Increment the date
            currentDate = currentDate.add(Duration(days: 1));
          }
        }
      }
    }
  }

  List<Todo> _getTasksForDay(DateTime day) {
    return _groupedTasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  // Predefined list of colors for multi-day tasks
  final List<Color> multiDayTaskColors = [
    Colors.blue,
    Colors.green,
    Colors.purple,
    Colors.orange,
    Colors.pink,
    Colors.teal,
  ];

  // Method to assign a unique color to multi-day tasks
  Color getMultiDayTaskColor(int index) {
    return multiDayTaskColors[index % multiDayTaskColors.length];
  }

  // Fixed color for single-day tasks
  final Color singleDayTaskColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay = _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];
    final events = List<Todo>.from(_groupedTasks[_focusedDay] ?? []);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2050, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week', // Remove the 2-week format
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            eventLoader: (day) {
              final dayKey = DateTime(day.year, day.month, day.day);
              return _groupedTasks[dayKey] ?? [];
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
              });
            },

            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                // Get tasks for the focused day
                final events = _groupedTasks[_focusedDay] ?? [];

                if (events.isEmpty) {
                  return null;
                }

                // Separate single-day and multi-day tasks
                final singleDayTasks = events.where((task) {
                  final startDate = task.startDate;
                  final dueDate = task.dueDate;
                  return startDate != null && dueDate != null && startDate.isAtSameMomentAs(dueDate);
                }).toList();

                final multiDayTasks = events.where((task) {
                  final startDate = task.startDate;
                  final dueDate = task.dueDate;
                  return startDate != null && dueDate != null && !startDate.isAtSameMomentAs(dueDate);
                }).toList();

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Marker for single-day tasks
                    if (singleDayTasks.isNotEmpty)
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 1.5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: singleDayTaskColor, // Color for single-day tasks
                        ),
                      ),
                    // Marker for multi-day tasks
                    ...multiDayTasks.asMap().entries.map((entry) {
                      final index = entry.key;
                      final task = entry.value;
                      return Container(
                        margin: const EdgeInsets.only(right: 2.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: getMultiDayTaskColor(index),
                          shape: BoxShape.circle,
                        ),
                      );
                    }),
                  ],
                );
              },
            ),

          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasksForSelectedDay.length,
              itemBuilder: (context, index) {
                final task = tasksForSelectedDay[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Icon(
                    task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: task.isCompleted ? Colors.green : Colors.grey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
