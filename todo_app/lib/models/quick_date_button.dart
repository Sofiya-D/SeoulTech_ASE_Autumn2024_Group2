import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/todo_form_data.dart';

class QuickDateButtons extends StatelessWidget {
  final TodoFormData formData;
  final VoidCallback? onDateChanged;
  final bool isSubtask;

  const QuickDateButtons({
    Key? key, 
    required this.formData,
    this.onDateChanged,
    this.isSubtask = false,
  }) : super(key: key);

  void _setQuickDate(QuickDateOption option) {
    final now = DateTime.now();
    switch (option) {
      case QuickDateOption.today:
        formData.startDate = now;
        formData.dueDate = now;
        break;
      case QuickDateOption.thisWeek:
        formData.startDate = now;
        formData.dueDate = now.add(Duration(days: 6 - now.weekday));
        break;
      case QuickDateOption.thisMonth:
        formData.startDate = now;
        formData.dueDate = DateTime(now.year, now.month + 1, 0);
        break;
    }
    
    // Call the callback if provided to trigger any necessary updates
    onDateChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _QuickDateButton(
          label: 'Aujourd\'hui',
          onPressed: () => _setQuickDate(QuickDateOption.today),
        ),
        _QuickDateButton(
          label: 'Cette semaine',
          onPressed: () => _setQuickDate(QuickDateOption.thisWeek),
        ),
        _QuickDateButton(
          label: 'Ce mois',
          onPressed: () => _setQuickDate(QuickDateOption.thisMonth),
        ),
      ],
    );
  }
}

class _QuickDateButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _QuickDateButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12)),
    );
  }
}

enum QuickDateOption {
  today,
  thisWeek,
  thisMonth,
}