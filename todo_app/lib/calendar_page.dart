import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/models/todo.dart';
import 'package:intl/intl.dart';

import 'floating_buttons.dart';
import 'settings_manager.dart';

class CalendarPage extends StatefulWidget {
  final List<Todo> taskList;

  const CalendarPage({Key? key, required this.taskList}) : super(key: key);

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

/*
  Map<DateTime, List<Todo>> _generateDateRangeEvents(List<Todo> todos) {
    final Map<DateTime, List<Todo>> events = {};

    for (var todo in todos) {
      // Handle tasks with periodicity
      if (todo.periodicity != null && todo.dueDate != null) {
        DateTime current = todo.startDate ?? todo.dueDate!;
        while (!current.isAfter(todo.dueDate!)) {
          final date = DateTime(current.year, current.month, current.day); // Normalize date
          if (!_isInstanceCompleted(todo, date)) {
            events.putIfAbsent(date, () => []).add(todo);
          }
          current = todo.periodicity!.calculateNextOccurrence(current);
        }
      } 
      else if (todo.startDate != null && todo.dueDate != null) {
        DateTime current = todo.startDate!;
        while (!current.isAfter(todo.dueDate!)) {
          final date = DateTime(current.year, current.month, current.day); // Normalize date
          events.putIfAbsent(date, () => []).add(todo);
          current = current.add(const Duration(days: 1));
        }
      } 
      else if (todo.dueDate != null) {
        final date = DateTime(todo.dueDate!.year, todo.dueDate!.month, todo.dueDate!.day);
        events.putIfAbsent(date, () => []).add(todo);
      }
    }

    return events;
  }
*/ 
/*
  Map<DateTime, List<Todo>> _generateDateRangeEvents(List<Todo> todos) {
  final Map<DateTime, List<Todo>> events = {};

  for (var todo in todos) {
    // Handle tasks with periodicity
    if (todo.periodicity != null && todo.dueDate != null) {
      DateTime current = todo.startDate ?? todo.dueDate!;
      while (!current.isAfter(todo.dueDate!)) {
        final date = DateTime(current.year, current.month, current.day); // Normalize date
        if (!_isInstanceCompleted(todo, date)) {
          events.putIfAbsent(date, () => []).add(todo);
        }
        current = todo.periodicity!.calculateNextOccurrence(current);
      }
    } 
    // Handle tasks with a range of dates
    else if (todo.startDate != null && todo.dueDate != null) {
      DateTime current = todo.startDate!;
      while (!current.isAfter(todo.dueDate!)) {
        final date = DateTime(current.year, current.month, current.day); // Normalize date
        if (!_isInstanceCompleted(todo, date)) {
          events.putIfAbsent(date, () => []).add(todo);
        }
        current = current.add(const Duration(days: 1));
      }
    } 
    // Handle tasks with only a due date
    else if (todo.dueDate != null) {
      final date = DateTime(todo.dueDate!.year, todo.dueDate!.month, todo.dueDate!.day);
      if (!_isInstanceCompleted(todo, date)) {
        events.putIfAbsent(date, () => []).add(todo);
      }
    }
  }

  return events;
}
*/

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

/*
  Map<DateTime, List<Todo>> _groupTasksByDueDate(List<Todo> todos) {
    final Map<DateTime, List<Todo>> events = {};

    for (var todo in todos) {
      if (todo.dueDate != null) {
        final date = DateTime(
          todo.dueDate!.year,
          todo.dueDate!.month,
          todo.dueDate!.day,
        ); // Normalize to just the date.
        if (events[date] == null) {
          events[date] = [];
        }
        events[date]!.add(todo);
      }
    }
    return events;
  }
*/

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
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: events.map((event) {
                      final todo = event as Todo;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        width: 8.0,
                        height: 8.0,
                        decoration: BoxDecoration(
                          color: _getTaskColor(todo),
                          //color: todo.isCompleted ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
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
        textToSpeechEnabled: textToSpeechEnabled,
        speechToTextEnabled: speechToTextEnabled,
        onTextToSpeechPressed: () {
          // Define Text-to-Speech action here
          print("Text-to-Speech button pressed");
        },
        onSpeechToTextPressed: () {
          // Define Speech-to-Text action here
          print("Speech-to-Text button pressed");
        },
      ),*/
      floatingActionButton: FloatingButtons(
        onTextToSpeechPressed: () {
          settingsManager.handleTextToSpeech(context);
        },
        onSpeechToTextPressed: () {
          settingsManager.handleSpeechToText(context);
        },
      ),
    );
  }

  /// Builds an interactive legend for filtering tasks.
  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildLegendButton('Show all tasks', null, Colors.grey),
          _buildLegendButton('Importance level 1', 1, Colors.blue),
          _buildLegendButton('Importance level 2', 2, Colors.orange),
          _buildLegendButton('Importance level 3', 3, Colors.red),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterButton(
            label: 'Repetitive tasks',
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
            label: 'Loose deadlines tasks',
            isActive: _showDifferentDateTasks,
            onPressed: () {
              setState(() {
                _showDifferentDateTasks = !_showDifferentDateTasks;
                _showRepetitiveTasks = false;
                _showSameDateTasks = false;
              });
            },
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
        return Colors.blue;
      case 2:
        return Colors.orange;
      case 3:
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
    List<Todo> tasks = selectedDate != null ? _events[selectedDate] ?? [] : [];
    final filteredTasks = _filterTasks(tasks);

    if (filteredTasks.isEmpty) {
      return const Center(child: Text('No tasks for this day.'));
    }

    return Expanded(
      child: ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          final task = filteredTasks[index];
          final dueTime = task.dueDate != null
            ? DateFormat('h:mm a').format(task.dueDate!)
            : null;
          return ListTile(
            title: Text(
              task.title,
              //style: TextStyle(color: task.isCompleted ? Colors.green : Colors.red),
            ),
            //subtitle: task.description.isNotEmpty ? Text(task.description) : null,
            subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dueTime != null) Text('Due at $dueTime'),
              if (task.description.isNotEmpty) Text(task.description),
            ],
          ),
          trailing: IconButton(
              icon: Icon(
                _isInstanceCompleted(task, _selectedDay!)
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: _isInstanceCompleted(task, _selectedDay!) ? Colors.green : Colors.red,
              ),
              onPressed: () {
                setState(() {
                  final normalizedDate = DateTime(
                    _selectedDay!.year,
                    _selectedDay!.month,
                    _selectedDay!.day,
                  );
                  print('Normalized Date: $normalizedDate');

                  print('Before: $_completedInstances');
                  if (_isInstanceCompleted(task, _selectedDay!)) {
                    // If already completed, mark it as incomplete
                    _completedInstances[normalizedDate]?.remove(task);

                    // Clean up empty sets to avoid memory issues
                    if (_completedInstances[normalizedDate]?.isEmpty ?? true) {
                      _completedInstances.remove(normalizedDate);
                    }
                  } 
                  else {
                    // Mark the task as completed for this date
                    _completedInstances.putIfAbsent(normalizedDate, () => {}).add(task);
                  }
                  _events = _generateDateRangeEvents(widget.taskList);
                  print('After: $_completedInstances');
                });
              },
            ),
            /*
            trailing: IconButton(
              icon: Icon(
                task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: task.isCompleted ? Colors.green : Colors.red,
              ),
              onPressed: () {
                setState(() {
                  task.isCompleted = !task.isCompleted;
                });
              },
            ),
            */
          );
        },
      ),
    );
  }
}


