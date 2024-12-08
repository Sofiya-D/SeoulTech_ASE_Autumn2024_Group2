import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/notification_service.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_form_view.dart';
import 'package:todo_app/models/database_manager.dart'; // to manage the tasks database
import 'calendar_page.dart';
import 'statistics_page.dart';
import 'tasks_page.dart';
// import 'create_task_page.dart';
import 'settings_page.dart';
import 'floating_buttons.dart';

import 'package:todo_app/test_data/example_tasks.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the notification service
  final notificationService = NotificationService();
  await notificationService.init();

  final dbManager = DatabaseManager.instance;
  final dbExists = await dbManager.exists();

  if (dbExists) {
    print('Database exists. Proceeding with the app.');
  } else {
    print('Database does not exist. Creating a new one.');
    await dbManager.database;
  }

  // !! TEMPORARY !! - for dev/debug purposes
  await DatabaseManager.instance.setAllTasks(exampleTasks); // Sets the Database to the example_tasks set of tasks
  // await DatabaseManager.instance.delete(); // !! caution !! Deletes any previously present database
  // await DatabaseManager.instance.insertMultipleTasks(exampleTasks); // Inserts the example_tasks set of tasks into the database
  // !! /TEMPORARY !!

  final tasks = await DatabaseManager.instance.getAllTasks(); // Retrieve tasks from SQLite.
  notificationService.resetAllDeviceNotifications(tasks);

  runApp(MyApp(tasks: tasks, notificationService: notificationService)); // Pass tasks to MyApp
}

class MyApp extends StatelessWidget {
  final List<Todo> tasks;

  final NotificationService notificationService;

  const MyApp({super.key, required this.tasks, required this.notificationService});


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MyAppState(tasks, notificationService)),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'To-Do App',
            theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: themeProvider.themeColor),
            ), // Light theme
            darkTheme: ThemeData.dark(), // Dark theme
            themeMode: themeProvider.themeMode, // Control theme switching
            home: MyHomePage(notificationService: notificationService),
          );
        },
      ),
    );
  }
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;
  Color _color = Colors.red; // default color 

  ThemeMode get themeMode => _themeMode;
  Color get themeColor => _color;

  void toggleTheme(bool isDarkMode) {
    _themeMode = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  void changeColor(Color color) {
    _color = color;
    notifyListeners();
  }
}

class MyAppState extends ChangeNotifier {
  // Floating button visibility state
  bool _isFloatingButtonEnabled = false;

  bool get isFloatingButtonEnabled => _isFloatingButtonEnabled;

  void toggleFloatingButton(bool value) {
    _isFloatingButtonEnabled = value;
    notifyListeners();
  }

  List<Todo> taskList;
  final NotificationService _notificationService;

  MyAppState(this.taskList, this._notificationService);  // Initialize taskList with fetched tasks

  // You can add methods here to modify taskList and notify listeners

  void addTask(Todo todo) {
    taskList.add(todo);
    DatabaseManager.instance.insertTask(todo);
    // Schedule notifications for the new task
    //_notificationService.testNotificationImmediately(todo);
    todo.scheduleNotifications(_notificationService);
    _notificationService.checkPendingNotificationRequests();
    notifyListeners();
  }

  void removeTask(Todo todo) {
    // Cancel existing notifications for the task
    todo.isDeleted == true;
    _notificationService.cancelTodoNotifications(todo);
    taskList.remove(todo);
    notifyListeners();
  }

  void completeTask(Todo todo) {
    todo.isCompleted == true;
    DatabaseManager.instance.updateTask(todo);
    _notificationService.cancelTodoNotifications(todo);
    if (todo.periodicity != null && todo.periodicity!.isNull()) {
      Todo newTodo = todo.duplicateWith(dueDate: todo.periodicity!.calculateNextOccurrence(todo.dueDate!));
    }
    addTask(todo);
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  final NotificationService notificationService;

  const MyHomePage({super.key, required this.notificationService});

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
          appState.addTask(todo);
          setState(() {
                    selectedIndex = 1;
                  });
          },
        );
        break;
      case 1:
        page = TasksPage();
        break;
      case 2:
        page = CalendarPage(taskList: taskList);
        break;
      case 3:
        page = StatisticsPage();
        break;
      case 4:
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
      /*floatingActionButton: appState.isFloatingButtonEnabled
          ? FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    content: Text("Button clicked!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Close"),
                      ),
                    ],
                  ),
                );
              },
              child: Icon(Icons.add),
            )
          : null,*/
      floatingActionButton: FloatingButtons(),
    );
  }
}
