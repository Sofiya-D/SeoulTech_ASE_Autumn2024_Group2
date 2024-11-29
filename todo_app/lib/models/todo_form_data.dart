// lib/views/todo_form/todo_form_data.dart

import 'package:flutter/material.dart';
import 'package:todo_app/models/periodicity.dart';

class TodoFormData {
  // final TextEditingController title = TextEditingController();
  // final TextEditingController description = TextEditingController();
  // final TextEditingController tags = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController tags = TextEditingController();
  DateTime? startDate;
  DateTime? dueDate;
  TimeOfDay? startTime;
  TimeOfDay? dueTime;
  Periodicity? periodicity;
  int importanceLevel = 1;
  String? dateError;
  final List<SubtaskFormData> subtasks = [];
  final List<String> links = [];
  final List<String> folders = [];

  DateTime? get startDateTime {
    if (startDate == null) return null;
    return startTime == null 
      ? startDate 
      : DateTime(
          startDate!.year, 
          startDate!.month, 
          startDate!.day, 
          startTime!.hour, 
          startTime!.minute
        );
  }

  DateTime? get dueDateTime {
    if (dueDate == null) return null;
    return dueTime == null 
      ? dueDate 
      : DateTime(
          dueDate!.year, 
          dueDate!.month, 
          dueDate!.day, 
          dueTime!.hour, 
          dueTime!.minute
        );
  }

  bool validateDates() {
    dateError = null;

    if (startDateTime != null && dueDateTime != null) {
      if (dueDateTime!.isBefore(startDateTime!)) {
        dateError = 'La date et l\'heure de fin doivent être après la date et l\'heure de début';
        return false;
      }
    }
    return true;
  }

  void clearDueDateTime() {
    dueDate = null;
    dueTime = null;
  }

  void dispose() {
    title.dispose();
    description.dispose();
    tags.dispose();
    for (var subtask in subtasks) {
      subtask.dispose();
    }
  }
}

class SubtaskFormData {
  // final TextEditingController title = TextEditingController();
  // final TextEditingController description = TextEditingController();
  // final TextEditingController tags = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController tags = TextEditingController();
  DateTime? startDate;
  DateTime? dueDate;
  TimeOfDay? startTime;
  TimeOfDay? dueTime;
  Periodicity? periodicity;
  int importanceLevel = 1;
  String? dateError;
  final List<String> links = [];
  final List<String> folders = [];

  DateTime? get startDateTime {
    if (startDate == null) return null;
    return startTime == null 
      ? startDate 
      : DateTime(
          startDate!.year, 
          startDate!.month, 
          startDate!.day, 
          startTime!.hour, 
          startTime!.minute
        );
  }

  DateTime? get dueDateTime {
    if (dueDate == null) return null;
    return dueTime == null 
      ? dueDate 
      : DateTime(
          dueDate!.year, 
          dueDate!.month, 
          dueDate!.day, 
          dueTime!.hour, 
          dueTime!.minute
        );
  }

  bool validateDates() {
    dateError = null;

    if (startDateTime != null && dueDateTime != null) {
      if (dueDateTime!.isBefore(startDateTime!)) {
        dateError = 'La date et l\'heure de fin doivent être après la date et l\'heure de début';
        return false;
      }
    }
    return true;
  }

  void clearDueDateTime() {
    dueDate = null;
    dueTime = null;
  }


  void dispose() {
    title.dispose();
    description.dispose();
    tags.dispose();
  }
}