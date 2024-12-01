import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_form_view.dart';
import 'package:todo_app/models/database_helper.dart'; // to manage the tasks database
import 'calendar_page.dart';
import 'cemetry_page.dart';
import 'statistics_page.dart';
import 'tasks_page.dart';
// import 'create_task_page.dart';
import 'settings_page.dart';

import 'package:todo_app/test_data/example_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper.instance;
  final dbExists = await dbHelper.databaseExists();

  if (dbExists) {
    print('Database exists. Proceeding with the app.');
  } else {
    print('Database does not exist. Creating a new one.');
    await dbHelper.database;
  }

  // !! TEMPORARY !! - for dev/debug purposes
  // Set the tasks database to the example_tasks set of tasks
  await DatabaseHelper.instance.setAllTasks(exampleTasks);
  // !! /TEMPORARY !!

  final tasks = await DatabaseHelper.instance.getAllTasks(); // Retrieve tasks from SQLite.

  runApp(MyApp(tasks: tasks)); // Pass tasks to MyApp
}

class MyApp extends StatelessWidget {
  final List<Todo> tasks;

  const MyApp({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(tasks),
      child: MaterialApp(
        title: 'To-Do App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  List<Todo> taskList;

  MyAppState(this.taskList);  // Initialize taskList with fetched tasks

  // You can add methods here to modify taskList and notify listeners
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var taskList = appState.taskList;
    Widget page;
    switch (selectedIndex) {
      case 0:
        // page = CreateTaskPage();
        page = TodoFormView(
          onSubmit: (Todo todo) {
            // debug
            print('Nouvelle tâche créée : ${todo.title}');
            taskList.add(todo);
            setState(() {
              selectedIndex = 1;
            });
          },
        );
        break;
      case 1:
        page = TasksPage(tasks: taskList);
        break;
      case 2:
        page = CalendarPage();
        break;
      case 3:
        page = StatisticsPage();
        break;
      case 4:
        page = CemetryPage();
        break;
      case 5:
        page = SettingsPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      appBar: AppBar(
        //title: Text('Hamburger Menu Example'),
        //iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.plus_one),
                title: Text('Create Task'),
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.task),
                title: Text('Tasks'),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text('Calendar'),
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Statistics'),
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Cemetery'),
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  setState(() {
                    selectedIndex = 4;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.primaryContainer,
        child: page,
      ),
    );
  }
}
