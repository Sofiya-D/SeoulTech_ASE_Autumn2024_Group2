import 'package:flutter/material.dart';
import 'package:todo_app/models/periodicity.dart';

// enum for predefined periodicities
enum PresetPeriodicity {
  daily,
  weekly,
  monthly,
  yearly
}

class PeriodicityToggle extends StatefulWidget {
  final Periodicity? initialPeriodicity;
  final Function(Periodicity?) onPeriodicityChanged;
  final DateTime? dueDate;

  const PeriodicityToggle({
    Key? key,
    this.initialPeriodicity,
    required this.onPeriodicityChanged,
    required this.dueDate,
  }) : super(key: key);

  @override
  _PeriodicityToggleState createState() => _PeriodicityToggleState();
}

class _PeriodicityToggleState extends State<PeriodicityToggle> {
  bool _isPeriodic = false;
  late TextEditingController _daysController;
  late TextEditingController _monthsController;
  late TextEditingController _yearsController;
  
  // new state to follow choixe of predifined button
  PresetPeriodicity? _selectedPreset;

  @override
  void initState() {
    super.initState();
    
    // Initialisation based on the initialPeriodicity and exsitence of due date
    _isPeriodic = widget.initialPeriodicity != null && widget.dueDate != null;
    
    _daysController = TextEditingController(
      text: (widget.initialPeriodicity?.days ?? 0).toString()
    );
    _monthsController = TextEditingController(
      text: (widget.initialPeriodicity?.months ?? 0).toString()
    );
    _yearsController = TextEditingController(
      text: (widget.initialPeriodicity?.years ?? 0).toString()
    );

    // determine preset if possible
    _determinePresetFromPeriodicity(widget.initialPeriodicity);
  }

  @override
  void didUpdateWidget(covariant PeriodicityToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // update _isPeriodic if due date changes
    if (oldWidget.dueDate != widget.dueDate) {
      setState(() {
        // deactivate periodicity if no due date
        _isPeriodic = widget.dueDate != null && widget.initialPeriodicity != null;
      });
    }
  }

  // method to determinate preset choice from periodicity
  void _determinePresetFromPeriodicity(Periodicity? periodicity) {
    if (periodicity == null) {
      _selectedPreset = null;
      return;
    }

    if (periodicity.days == 1 && periodicity.months == 0 && periodicity.years == 0) {
      _selectedPreset = PresetPeriodicity.daily;
    } else if (periodicity.days == 7 && periodicity.months == 0 && periodicity.years == 0) {
      _selectedPreset = PresetPeriodicity.weekly;
    } else if (periodicity.days == 0 && periodicity.months == 1 && periodicity.years == 0) {
      _selectedPreset = PresetPeriodicity.monthly;
    } else if (periodicity.days == 0 && periodicity.months == 0 && periodicity.years == 1) {
      _selectedPreset = PresetPeriodicity.yearly;
    } else {
      _selectedPreset = null;
    }
  }

  // method to define a predefined periodicity
  void _setPresetPeriodicity(PresetPeriodicity preset) {
    if (widget.dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez d\'abord sélectionner une date de fin'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isPeriodic = true;
      _selectedPreset = preset;

      // reinitialize manual controller
      _daysController.text = '0';
      _monthsController.text = '0';
      _yearsController.text = '0';

      // define periodicity based on presets
      Periodicity periodicity;
      switch (preset) {
        case PresetPeriodicity.daily:
          periodicity = Periodicity(days: 1);
          _daysController.text = '1';
          break;
        case PresetPeriodicity.weekly:
          periodicity = Periodicity(days: 7);
          _daysController.text = '7';
          break;
        case PresetPeriodicity.monthly:
          periodicity = Periodicity(months: 1);
          _monthsController.text = '1';
          break;
        case PresetPeriodicity.yearly:
          periodicity = Periodicity(years: 1);
          _yearsController.text = '1';
          break;
      }

      // update periodicity
      widget.onPeriodicityChanged(periodicity);
    });
  }

  void _updatePeriodicity() {
    if (_isPeriodic) {

      if (widget.dueDate == null) {
        setState(() {
          _isPeriodic = false;
        });
        widget.onPeriodicityChanged(null);
        return;
      }

      int days = int.tryParse(_daysController.text) ?? 0;
      int months = int.tryParse(_monthsController.text) ?? 0;
      int years = int.tryParse(_yearsController.text) ?? 0;

      // reinitialise periodicity if defined value do not correspond
      _determinePresetFromPeriodicity(Periodicity(days: days, months: months, years: years));

      widget.onPeriodicityChanged(Periodicity(
        days: days,
        months: months,
        years: years
      ));
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
                if (value && widget.dueDate == null) {
                // show error message if no there is no due date
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Veuillez d\'abord sélectionner une date de fin'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
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
          // row of predefined buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: PresetPeriodicity.values.map((preset) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(_getPresetLabel(preset)),
                    selected: _selectedPreset == preset,
                    onSelected: (_) => _setPresetPeriodicity(preset),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          // manual input field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _daysController,
                  decoration: const InputDecoration(
                    labelText: 'Jours',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updatePeriodicity(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _monthsController,
                  decoration: const InputDecoration(
                    labelText: 'Mois',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updatePeriodicity(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _yearsController,
                  decoration: const InputDecoration(
                    labelText: 'Années',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => _updatePeriodicity(),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Method to get text associated with presets
  String _getPresetLabel(PresetPeriodicity preset) {
    switch (preset) {
      case PresetPeriodicity.daily:
        return 'Quotidien';
      case PresetPeriodicity.weekly:
        return 'Hebdomadaire';
      case PresetPeriodicity.monthly:
        return 'Mensuel';
      case PresetPeriodicity.yearly:
        return 'Annuel';
    }
  }

  @override
  void dispose() {
    _daysController.dispose();
    _monthsController.dispose();
    _yearsController.dispose();
    super.dispose();
  }
}