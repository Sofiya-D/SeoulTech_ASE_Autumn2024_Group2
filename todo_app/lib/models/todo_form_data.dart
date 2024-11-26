// lib/views/todo_form/todo_form_data.dart

import 'package:flutter/material.dart';

class TodoFormData {
  // final TextEditingController title = TextEditingController();
  // final TextEditingController description = TextEditingController();
  // final TextEditingController tags = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController tags = TextEditingController();
  DateTime? startDate;
  DateTime? dueDate;
  Duration? periodicity;
  int importanceLevel = 1;
  String? dateError;
  final List<SubtaskFormData> subtasks = [];
  final List<String> links = [];
  final List<String> folders = [];

  bool validateDates() {
    dateError = null;

    if (startDate != null && dueDate != null) {
      if (dueDate!.isBefore(startDate!)) {
        dateError = 'La date de fin doit être après la date de début';
        return false;
      }
    }
    return true;
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
  Duration? periodicity;
  int importanceLevel = 1;
  String? dateError;
  final List<String> links = [];
  final List<String> folders = [];

  bool validateDates() {
    dateError = null;

    if (startDate != null && dueDate != null) {
      if (dueDate!.isBefore(startDate!)) {
        dateError = 'La date de fin doit être après la date de début';
        return false;
      }
    }
    return true;
  }

  void dispose() {
    title.dispose();
    description.dispose();
    tags.dispose();
  }
}