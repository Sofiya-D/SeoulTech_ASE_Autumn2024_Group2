// lib/views/todo_form/widgets/todo_dates_section.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/periodicity_toggle.dart';
import 'package:todo_app/models/quick_date_button.dart';
// import 'package:todo_app/views/todo_form/todo_form_data.dart';
import 'package:todo_app/models/todo_form_data.dart';

class TodoDatesSection extends StatefulWidget {
  final TodoFormData formData;

  const TodoDatesSection({
    Key? key,
    required this.formData,
  }) : super(key: key);

  @override
  State<TodoDatesSection> createState() => _TodoDatesSectionState();
}

class _TodoDatesSectionState extends State<TodoDatesSection> {
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

  void _updatePeriodicity(Duration? periodicity) {
    setState(() {
      widget.formData.periodicity = periodicity;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  child: _DateTile(
                    title: 'Date de début',
                    date: widget.formData.startDate,
                    onTap: _selectStartDate,
                    onClear: () => setState(() {
                      widget.formData.startDate = null;
                      widget.formData.dateError = null;
                    }),
                  ),
                ),
                Expanded(
                  child: _DateTile(
                    title: 'Date de fin',
                    date: widget.formData.dueDate,
                    onTap: _selectDueDate,
                    onClear: () => setState(() {
                      widget.formData.dueDate = null;
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
    Key? key,
    required this.title,
    required this.date,
    required this.onTap,
    required this.onClear,
  }) : super(key: key);

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
