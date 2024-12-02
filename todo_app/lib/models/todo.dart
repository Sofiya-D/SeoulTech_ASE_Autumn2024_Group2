import 'package:flutter/material.dart';

import 'package:todo_app/models/periodicity.dart';

class Todo {
  String title;
  String description;
  int importanceLevel;
  List<String> tags;
  DateTime? startDate;
  DateTime? dueDate;
  Periodicity? periodicity;
  bool isDeleted;
  bool isCompleted;
  bool isMissed;
  List<TodoTask> tasks;
  List<String> folders;
  List<String> links;
  int points;
  Color? taskColor;

  Todo({
    required this.title,
    this.description = '',
    this.importanceLevel = 1,
    this.tags = const [],
    this.startDate,
    this.dueDate,
    this.periodicity,
    this.isDeleted = false,
    this.isCompleted = false,
    this.isMissed = false,
    this.tasks = const [],
    this.folders = const [],
    this.links = const [],
    this.points = 0,
    this.taskColor,
  });

  /// Convert to Map for SQLite.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'importanceLevel': importanceLevel,
      'tags': tags.join(','), // Convert list to a comma-separated string.
      'startDate': startDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'periodicity': periodicity != null
          ? '{"years": ${periodicity!.years}, "months": ${periodicity!.months}, "days": ${periodicity!.days}}'
          : null, // Convert Periodicity to JSON string.
      'isDeleted': isDeleted ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'isMissed': isMissed ? 1 : 0,
      'folders': folders.join(','),
      'links': links.join(','),
      'points': points,
    };
  }

  /// Convert from Map to use SQLite Database.
  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      title: map['title'],
      description: map['description'],
      importanceLevel: map['importanceLevel'],
      tags: map['tags'] != null ? map['tags'].split(',') : [],
      startDate: map['startDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(map['startDate'].toString()) ?? 0)
          : null,
      dueDate: map['dueDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              int.tryParse(map['dueDate'].toString()) ?? 0)
          : null,
      periodicity: map['periodicity'] != null
          ? Periodicity.fromJson(map['periodicity'])
          : null, // Deserialize Periodicity.
      isDeleted: map['isDeleted'] == 1,
      isCompleted: map['isCompleted'] == 1,
      isMissed: map['isMissed'] == 1,
      folders: map['folders'] != null ? map['folders'].split(',') : [],
      links: map['links'] != null ? map['links'].split(',') : [],
      points: map['points'],
    );
  }
}

class TodoTask {
  String title;
  String description;

  List<String> tags;
  DateTime? startDate;
  DateTime? dueDate;
  Periodicity? periodicity;
  bool isDeleted;
  bool isCompleted;
  bool isMissed;
  List<String> folders;
  List<String> links;
  int points;

  String? parentId; // to link the subtask to its parent

  TodoTask({
    required this.title,
    this.description = '',
    this.tags = const [],
    this.startDate,
    this.dueDate,
    this.periodicity,
    this.isDeleted = false,
    this.isCompleted = false,
    this.isMissed = false,
    this.folders = const [],
    this.links = const [],
    this.points = 0,
  });

  /// Convert to Map for SQLite.
  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'description': description,
      'tags': tags.join(','), // Convert list to a comma-separated string.
      'startDate': startDate?.millisecondsSinceEpoch,
      'dueDate': dueDate?.millisecondsSinceEpoch,
      'periodicity': periodicity != null
          ? '{"years": ${periodicity!.years}, "months": ${periodicity!.months}, "days": ${periodicity!.days}}'
          : null, // Convert Periodicity to JSON string.
      'isDeleted': isDeleted ? 1 : 0,
      'isCompleted': isCompleted ? 1 : 0,
      'isMissed': isMissed ? 1 : 0,
      'folders': folders.join(','),
      'links': links.join(','),
      'points': points,
    };

    if (parentId != null) {
      map['parentId'] = parentId; // Add parentId to the map if it's not null.
    }

    return map;
  }
}
