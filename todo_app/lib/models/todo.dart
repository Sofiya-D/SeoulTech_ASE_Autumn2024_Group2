import 'package:flutter/material.dart';

class Todo {

  String title;
  String description;
  int importanceLevel;
  List<String> tags;
  DateTime? startDate;
  DateTime? dueDate;
  Duration? periodicity;
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


}

class TodoTask {

  String title;
  String description;

  List<String> tags;
  DateTime? startDate;
  DateTime? dueDate;
  Duration? periodicity;
  bool isDeleted;
  bool isCompleted;
  bool isMissed;
  List<String> folders;
  List<String> links;
  int points;

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


}