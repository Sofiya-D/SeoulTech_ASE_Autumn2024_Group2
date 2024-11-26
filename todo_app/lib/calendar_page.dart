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

  /*void _debugPrintGroupedTasks() {
    _groupedTasks.forEach((date, tasks) {
      debugPrint('Date: $date');
      for (var task in tasks) {
        debugPrint('  - Task: ${task.title}, Periodicity: ${task.periodicity}');
      }
    });
  }*/

  void _groupTasksByDate() {
    final appState = Provider.of<MyAppState>(context, listen: false);
    _groupedTasks.clear(); // Clear previous entries to avoid duplicates

    for (var task in appState.taskList) {
      if (task.startDate != null && task.dueDate != null) {
        if (task.periodicity != null) {
          // Handle periodic tasks
          DateTime currentDate = task.startDate!;
          while (currentDate.isBefore(task.dueDate!) || currentDate.isAtSameMomentAs(task.dueDate!)) {
            final taskDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
            if (_groupedTasks[taskDate] == null) {
              _groupedTasks[taskDate] = [];
            }
            _groupedTasks[taskDate]!.add(task);
            currentDate = currentDate.add(task.periodicity!);
            print("Adding periodic task '${task.title}' on date: $taskDate");
          }
        } else {
          // Handle single-day tasks
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          if (_groupedTasks[taskDate] == null) {
            _groupedTasks[taskDate] = [];
          }
          _groupedTasks[taskDate]!.add(task);
          print("Adding single-day task '${task.title}' on date: $taskDate");
        }
      }
    }

    print("Grouped tasks:");
    _groupedTasks.forEach((key, value) {
      print("$key: ${value.map((task) => task.title).join(', ')}");
    });
  }

  /*void _groupTasksByDate() {
    final appState = Provider.of<MyAppState>(context, listen: false);
    
    for (var task in appState.taskList) {
      if (task.startDate != null && task.dueDate != null){
        if (task.periodicity != null){ // Periodic tasks
          DateTime currentDate = task.startDate!;
          while (currentDate.isBefore(task.dueDate!) || currentDate.isAtSameMomentAs(task.dueDate!)) {
            final taskDate = DateTime(currentDate.year, currentDate.month, currentDate.day);
            if (_groupedTasks[taskDate] == null){
              _groupedTasks[taskDate] = [];
            }
            _groupedTasks[taskDate]!.add(task);
            currentDate = currentDate.add(task.periodicity!);
          } 
        }
        else{ // Single Day tasks
          final taskDate = DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
          if (_groupedTasks[taskDate] == null){
            _groupedTasks[taskDate] = [];
          }
          _groupedTasks[taskDate]!.add(task);
        }
      }
    }

     // Debug print after grouping tasks
    _debugPrintGroupedTasks();
  }*/

  List<Todo> _getTasksForDay(DateTime day) {
    return _groupedTasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  /*List<DateTime> _getWeekStartingFromCurrentDate(DateTime currentDay) {
    return List.generate(7, (index) => currentDay.add(Duration(days: index)));
  }*/

  @override
  Widget build(BuildContext context) {
    final tasksForSelectedDay = _selectedDay != null ? _getTasksForDay(_selectedDay!) : [];

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
            eventLoader: _getTasksForDay,
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
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;

                List<Todo> singleDayTasks = [];
                List<Todo> periodicTasks = [];

                for (var event in events) {
                  if (event is Todo){ // Explicitly cast the event to Todo
                    if (event.periodicity != null) {
                      periodicTasks.add(event);
                    } else {
                      singleDayTasks.add(event);
                    }
                  }
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Single-day tasks (circle indicator)
                    if (singleDayTasks.isNotEmpty)
                      Container(
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: Colors.red, // Single-task color
                          shape: BoxShape.circle,
                        ),
                      ),
                    // Periodic tasks (line indicator)
                    if (periodicTasks.isNotEmpty)
                      Container(
                        width: 20.0,
                        height: 4.0,
                        decoration: BoxDecoration(
                          color: Colors.blue, // Periodic-task color
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
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
