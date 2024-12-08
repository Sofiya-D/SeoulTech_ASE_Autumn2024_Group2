import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/todo.dart';
import 'package:intl/intl.dart';

import 'floating_buttons.dart';
import 'settings_manager.dart';

class CalendarPage extends StatefulWidget {
  final List<Todo> taskList;

  const CalendarPage({super.key, required this.taskList});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late Map<DateTime, List<Todo>> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay = DateTime.now();
  int? _selectedImportanceLevel; // Filter by importanceLevel
  bool _showCompleted = true; // Toggle to show/hide completed tasks
  bool _showRepetitiveTasks = false;
  bool _showDifferentDateTasks = false;
  bool _showSameDateTasks = false;
  final Map<DateTime, Set<Todo>> _completedInstances = {};

  @override
  void initState() {
    super.initState();
    _updateTasksWithPeriodicity(widget.taskList);
    //_events = _groupTasksByDueDate(widget.taskList);
    _events = _generateDateRangeEvents(widget.taskList);
  }

  void _updateTasksWithPeriodicity(List<Todo> todos) {
    final now = DateTime.now();
    for (var todo in todos) {
      if (todo.periodicity != null) {
        while (todo.dueDate != null && todo.dueDate!.isBefore(now)) {
          todo.dueDate = todo.periodicity!.calculateNextOccurrence(todo.dueDate!);
        }
      }
    }
  }

Map<DateTime, List<Todo>> _generateDateRangeEvents(List<Todo> todos) {
    final Map<DateTime, List<Todo>> events = {};

    for (var todo in todos) {
      if (todo.startDate != null && todo.dueDate != null) {
        DateTime current = todo.startDate!;
        while (!current.isAfter(todo.dueDate!)) {
          final date = DateTime(current.year, current.month, current.day);
          events.putIfAbsent(date, () => []).add(todo);
          current = current.add(const Duration(days: 1));
        }
      } else if (todo.dueDate != null) {
        final date = DateTime(todo.dueDate!.year, todo.dueDate!.month, todo.dueDate!.day);
        events.putIfAbsent(date, () => []).add(todo);
      }
    }

    return events;
  }

  /// Filters tasks based on selected importanceLevel and completion status.
  List<Todo> _filterTasks(List<Todo> tasks) {
    return tasks.where((task) {
      final matchesImportanceLevel = _selectedImportanceLevel == null ||
          task.importanceLevel == _selectedImportanceLevel;
      final matchesCompletion = _showCompleted || !task.isCompleted;
      // Additional filters
      final isRepetitive = _showRepetitiveTasks ? task.periodicity != null : true;
      final hasDifferentDates =
          _showDifferentDateTasks ? task.startDate != null && task.dueDate != null && task.startDate != task.dueDate : true;
      final hasSameDates =
          _showSameDateTasks ? task.startDate != null && task.startDate == task.dueDate : true;

      return matchesImportanceLevel &&
          matchesCompletion &&
          isRepetitive &&
          hasDifferentDates &&
          hasSameDates;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Calendar'),
      ),
      body: Column(
        children: [
          _buildLegend(),
          _buildAdditionalFilters(),
          TableCalendar(
            firstDay: DateTime.utc(2000, 1, 1),
            lastDay: DateTime.utc(2100, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Month',
              CalendarFormat.week: 'Week', // Remove the 2-week format
            },
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              final date = DateTime(day.year, day.month, day.day);
              final tasks = _events[date] ?? [];
              return _filterTasks(tasks);
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
                if (events.isNotEmpty) {
                  final maxVisibleTasks = 3; // Set the maximum number of tasks to display directly
                  final tasks = events.cast<Todo>();
                  final visibleTasks = tasks.take(maxVisibleTasks).toList();
                  final overflowCount = tasks.length - maxVisibleTasks;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...visibleTasks.map((todo) {
                        return Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: _getTaskColor(todo),
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
                      if (overflowCount > 0)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          padding: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '+$overflowCount',
                            style: const TextStyle(
                              fontSize: 10.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  );
                }
                return null;
              },
            ),

          ),
          const SizedBox(height: 8.0),
          _buildTaskList(),
        ],
      ),
      /*floatingActionButton: FloatingButtons(
        onTextToSpeechPressed: () {
          settingsManager.handleTextToSpeech(context);
        },
        onSpeechToTextPressed: () {
          settingsManager.handleSpeechToText(context);
        },
      ),*/
    );
  }

  /// Builds an interactive legend for filtering tasks.
 Widget _buildLegend() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildLegendButton('All tasks', null, Colors.grey),
          _buildLegendButton('Very Urgent', 5, Colors.red),
          _buildLegendButton('Urgent', 4, Colors.orange),
          _buildLegendButton('Important', 3, const Color.fromARGB(255, 255, 221, 0)),
          _buildLegendButton('Less important', 2, Colors.blue),
          _buildLegendButton('Unimportant', 1, const Color.fromARGB(255, 155, 151, 255)),         
        ],
      ),
    );
  }

  /// Helper to build individual legend buttons.
  Widget _buildLegendButton(String label, int? level, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedImportanceLevel == level ? color : Colors.grey[300],
        foregroundColor: Colors.black,
      ),
      onPressed: () {
        setState(() {
          _selectedImportanceLevel = level;
        });
      },
      child: Text(label),
    );
  }

  Widget _buildAdditionalFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Wrap(
        spacing: 8.0,
        runSpacing: 8.0,
        children: [
          _buildFilterButton(
            label: 'Repetitive',
            isActive: _showRepetitiveTasks,
            onPressed: () {
              setState(() {
                _showRepetitiveTasks = !_showRepetitiveTasks;
                _showDifferentDateTasks = false;
                _showSameDateTasks = false;
              });
            },
          ),
          _buildFilterButton(
            label: 'Loose deadlines',
            isActive: _showDifferentDateTasks,
            onPressed: () {
              setState(() {
                _showDifferentDateTasks = !_showDifferentDateTasks;
                _showRepetitiveTasks = false;
                _showSameDateTasks = false;
              });
            },
          ),
          Row(
            children: [
              Checkbox(
                value: _showCompleted,
                onChanged: (value) {
                  setState(() {
                    _showCompleted = value!;
                  });
                },
              ),
              const Text('Completed'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton({required String label, required bool isActive, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? const Color.fromARGB(255, 204, 146, 214) : Colors.grey[300],
        foregroundColor: Colors.black,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  /// Returns a color based on the task's properties (e.g., importanceLevel or tags).
  Color _getTaskColor(Todo todo) {
    if (todo.isCompleted) return Colors.green;
    switch (todo.importanceLevel) {
      case 1:
        return const Color.fromARGB(255, 155, 151, 255);
      case 2:
        return Colors.blue;
      case 3:
        return const Color.fromARGB(255, 255, 221, 0);
      case 4:
        return Colors.orange;
      case 5:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  bool _isInstanceCompleted(Todo task, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return _completedInstances[normalizedDate]?.contains(task) ?? false;
  }

  Widget _buildTaskList() {
  final selectedDate = _selectedDay != null
      ? DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day)
      : null;
  final tasks = selectedDate != null ? _events[selectedDate] ?? [] : [];

  return Expanded(
    child: ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
              color: task.isCompleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(task.description ?? ''),
          trailing: IconButton(
            icon: Icon(
              task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
              color: task.isCompleted ? Colors.green : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                task.isCompleted = !task.isCompleted; // Toggle the completion status
              });
            },
          ),
        );
      },
    ),
  );
}

}


