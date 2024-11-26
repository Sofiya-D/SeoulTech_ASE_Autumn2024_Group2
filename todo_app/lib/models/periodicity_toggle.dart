import 'package:flutter/material.dart';

class PeriodicityToggle extends StatefulWidget {
  final Duration? initialPeriodicity;
  final Function(Duration?) onPeriodicityChanged;

  const PeriodicityToggle({
    Key? key,
    this.initialPeriodicity,
    required this.onPeriodicityChanged,
  }) : super(key: key);

  @override
  _PeriodicityToggleState createState() => _PeriodicityToggleState();
}

class _PeriodicityToggleState extends State<PeriodicityToggle> {
  bool _isPeriodic = false;
  late TextEditingController _periodicityController;

  @override
  void initState() {
    super.initState();
    // Initialiser le state et le contrôleur
    _isPeriodic = widget.initialPeriodicity != null;
    _periodicityController = TextEditingController(
      text: widget.initialPeriodicity?.inDays.toString() ?? '1'
    );
  }

  @override
  void dispose() {
    _periodicityController.dispose();
    super.dispose();
  }

  void _updatePeriodicity() {
    if (_isPeriodic) {
      int days = int.tryParse(_periodicityController.text) ?? 1;
      widget.onPeriodicityChanged(Duration(days: days));
    } else {
      widget.onPeriodicityChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Tâche périodique'),
            Switch(
              value: _isPeriodic,
              onChanged: (bool value) {
                setState(() {
                  _isPeriodic = value;
                });
                _updatePeriodicity();
              },
            ),
          ],
        ),
        if (_isPeriodic) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Répéter tous les'),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _periodicityController,
                  decoration: const InputDecoration(
                    labelText: 'Jours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updatePeriodicity(),
                ),
              ),
              const Text(' jours'),
            ],
          ),
        ],
      ],
    );
  }
}
