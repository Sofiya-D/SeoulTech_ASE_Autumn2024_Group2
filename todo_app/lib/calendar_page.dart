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
    for (var task in appState.taskList) {
      if (task.dueDate != null) { // Add a null check
        final dueDate = DateTime(
          task.dueDate!.year,
          task.dueDate!.month,
          task.dueDate!.day,
        );
        if (_groupedTasks[dueDate] == null) {
          _groupedTasks[dueDate] = [];
        }
        _groupedTasks[dueDate]!.add(task);
      }
    }
  }

  List<Todo> _getTasksForDay(DateTime day) {
    return _groupedTasks[DateTime(day.year, day.month, day.day)] ?? [];
  }

  List<DateTime> _getWeekStartingFromCurrentDate(DateTime currentDay) {
    return List.generate(7, (index) => currentDay.add(Duration(days: index)));
  }

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
              weekNumberBuilder: (context, day) {
                if (_calendarFormat == CalendarFormat.week) {
                  // Display the week starting from the current date in week view
                  final customWeek = _getWeekStartingFromCurrentDate(_focusedDay);
                  return customWeek.contains(day) ? Text(day.toString()) : null;
                }
                return null;
              },
            ),
            daysOfWeekHeight: 40.0,
            calendarStyle: CalendarStyle(
              markerDecoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
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
