import 'package:flutter/material.dart';

import 'package:todo_app/models/periodicity.dart';
import 'package:todo_app/models/notification_service.dart';


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

  List<NotificationInfo> notificationIds = [];

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

  Future<void> scheduleNotifications(NotificationService notificationService) async {
    // Planifier les notifications pour la date de début
    if (startDate != null) {
      await notificationService.scheduleTodoNotifications(
        todo: this,
      );
    }

    // Planifier les notifications pour la date d'échéance
    if (dueDate != null) {
      await notificationService.scheduleTodoNotifications(
        todo: this, 
      );
    }
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