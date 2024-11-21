import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/main.dart'; // Import the state management file containing `MyAppState`

class CemetryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // var appState = context.watch<MyAppState>();

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('This is the Cemetry Page'),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                },
                icon: Icon(Icons.plus_one),
                label: Text('Add Task'),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
    );
  }
}
