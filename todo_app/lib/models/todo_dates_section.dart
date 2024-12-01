// lib/views/todo_form/widgets/todo_dates_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/periodicity.dart';
import 'package:todo_app/models/periodicity_toggle.dart';
import 'package:todo_app/models/quick_date_button.dart';
// import 'package:todo_app/views/todo_form/todo_form_data.dart';
import 'package:todo_app/models/todo_form_data.dart';

class TodoDatesSection extends StatefulWidget {
  final TodoFormData formData;

  const TodoDatesSection({
    super.key,
    required this.formData,
  });

  @override
  State<TodoDatesSection> createState() => _TodoDatesSectionState();
}

class _TodoDatesSectionState extends State<TodoDatesSection> {

  Future<void> _selectStartDateTime() async {
    // Pick start date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.formData.startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      // Pick start time
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: widget.formData.startTime ?? TimeOfDay.now(),
      );

      setState(() {
        widget.formData.startDate = pickedDate;
        widget.formData.startTime = pickedTime;

        // Reset due date/time if it's before the new start date/time
        if (widget.formData.dueDateTime != null && 
            widget.formData.dueDateTime!.isBefore(widget.formData.startDateTime!)) {
          widget.formData.clearDueDateTime();
        }
      });

      widget.formData.validateDates();
    }
  }

    Future<void> _selectDueDateTime() async {
      // Determine the minimum date for due date
      DateTime minDate = widget.formData.startDate ?? DateTime.now();

      // Pick due date
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: widget.formData.dueDate ?? minDate,
        firstDate: minDate,
        lastDate: DateTime(2101),
      );

      if (pickedDate != null) {
        // Pick due time
        final TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: widget.formData.dueTime ?? TimeOfDay.now(),
        );

      setState(() {
        widget.formData.dueDate = pickedDate;
        widget.formData.dueTime = pickedTime;
      });

      widget.formData.validateDates();
    }
  }

  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.formData.startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.formData.startDate = picked;
        if (widget.formData.dueDate != null && 
            widget.formData.dueDate!.isBefore(picked)) {
          widget.formData.dueDate = null;
        }
      });
      widget.formData.validateDates();
    }
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.formData.dueDate ?? 
                  widget.formData.startDate ?? 
                  DateTime.now(),
      firstDate: widget.formData.startDate ?? DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        widget.formData.dueDate = picked;
      });
      widget.formData.validateDates();
    }
  }

  void _updatePeriodicity(Periodicity? periodicity) {
    setState(() {
      widget.formData.periodicity = periodicity;
    });
  }

  void _listenToDateChanges() {
    // if the due date is deleted and the periodicity is active
    if (widget.formData.dueDate == null && widget.formData.periodicity != null) {
      // deactivate periodicity
      setState(() {
        widget.formData.periodicity = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _listenToDateChanges();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dates',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            QuickDateButtons(
              formData: widget.formData,
              onDateChanged: () {
                setState(() {
                  // Trigger a rebuild to update date displays
                  widget.formData.validateDates();
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _DateTimeTile(
                    title: 'Date de début',
                    dateTime: widget.formData.startDateTime,
                    onTap: _selectStartDateTime,
                    onClear: () => setState(() {
                      widget.formData.startDate = null;
                      widget.formData.startTime = null;
                      widget.formData.dateError = null;
                    }),
                  ),
                ),
                Expanded(
                  child: _DateTimeTile(
                    title: 'Date de fin',
                    dateTime: widget.formData.dueDateTime,
                    onTap: _selectDueDateTime,
                    onClear: () => setState(() {
                      widget.formData.clearDueDateTime();
                      widget.formData.dateError = null;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            PeriodicityToggle(
              initialPeriodicity: widget.formData.periodicity,
              onPeriodicityChanged: _updatePeriodicity,
              dueDate: widget.formData.dueDate,
            ),
            if (widget.formData.dateError != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.formData.dateError!,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _DateTile extends StatelessWidget {
  final String title;
  final DateTime? date;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DateTile({
    super.key,
    required this.title,
    required this.date,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        date == null ? 'Non définie' : DateFormat('dd/MM/yyyy').format(date!),
      ),
      onTap: onTap,
      trailing: date != null
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClear,
            )
          : null,
    );
  }
}

class _DateTimeTile extends StatelessWidget {
  final String title;
  final DateTime? dateTime;
  final VoidCallback onTap;
  final VoidCallback onClear;

  const _DateTimeTile({
    super.key,
    required this.title,
    required this.dateTime,
    required this.onTap,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        dateTime == null 
          ? 'Non définie' 
          : DateFormat('dd/MM/yyyy HH:mm').format(dateTime!),
      ),
      onTap: onTap,
      trailing: dateTime != null
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: onClear,
            )
          : null,
    );
  }
}
