import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'calendar_page.dart';
import 'cemetry_page.dart';
import 'statistics_page.dart';
import 'tasks_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
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

  // var taskList = <Todo>[];

  // !! SHOULD BE REMOVED !!
  // !! HERE FOR TESTING PURPOSES ONLY !!
  var taskList= <Todo>[
  Todo(
    title: 'Finish project report',
    description: 'Complete the final report for the project by the deadline.',
    importanceLevel: 3,
    tags: ['work', 'urgent'],
    startDate: DateTime(2024, 11, 1),
    dueDate: DateTime(2024, 11, 10),
    isCompleted: false,
    points: 20,
    tasks: [
      TodoTask(
        title: 'Draft report structure',
        description: 'Outline the key sections of the report.',
        tags: ['work'],
        startDate: DateTime(2024, 11, 1),
        dueDate: DateTime(2024, 11, 3),
        isCompleted: true,
      ),
      TodoTask(
        title: 'Write executive summary',
        description: 'Summarize the key points of the report.',
        tags: ['work'],
        startDate: DateTime(2024, 11, 4),
        dueDate: DateTime(2024, 11, 7),
        isCompleted: false,
      ),
    ],
  ),
  Todo(
    title: 'Buy groceries',
    description: 'Purchase fruits, vegetables, and other essentials.',
    importanceLevel: 1,
    tags: ['personal', 'shopping'],
    startDate: DateTime(2024, 11, 5),
    dueDate: DateTime(2024, 11, 5),
    isCompleted: false,
    points: 5,
    tasks: [
      TodoTask(
        title: 'Make a shopping list',
        description: 'List all items to buy for the week.',
        tags: ['personal'],
        startDate: DateTime(2024, 11, 4),
        dueDate: DateTime(2024, 11, 5),
        isCompleted: true,
      ),
      TodoTask(
        title: 'Visit the grocery store',
        description: 'Buy items listed on the shopping list.',
        tags: ['personal', 'shopping'],
        startDate: DateTime(2024, 11, 5),
        dueDate: DateTime(2024, 11, 5),
        isCompleted: false,
      ),
    ],
  ),
  Todo(
    title: 'Prepare presentation slides',
    description: 'Design slides for upcoming team meeting.',
    importanceLevel: 2,
    tags: ['work'],
    startDate: DateTime(2024, 11, 2),
    dueDate: DateTime(2024, 11, 8),
    isCompleted: false,
    points: 15,
    tasks: [
      TodoTask(
        title: 'Gather meeting topics',
        description: 'Collect topics to be discussed in the meeting.',
        tags: ['work'],
        startDate: DateTime(2024, 11, 2),
        dueDate: DateTime(2024, 11, 3),
        isCompleted: true,
      ),
      TodoTask(
        title: 'Design slide templates',
        description: 'Create visual themes for slides.',
        tags: ['work'],
        startDate: DateTime(2024, 11, 3),
        dueDate: DateTime(2024, 11, 5),
        isCompleted: false,
      ),
    ],
  ),
  Todo(
    title: 'Workout session',
    description: 'Complete the weekly strength training workout.',
    importanceLevel: 1,
    tags: ['health', 'fitness'],
    startDate: DateTime(2024, 11, 3),
    dueDate: DateTime(2024, 11, 3),
    isCompleted: true,
    points: 10,
    tasks: [
      TodoTask(
        title: 'Warm-up exercises',
        description: 'Stretch and light cardio.',
        tags: ['health'],
        startDate: DateTime(2024, 11, 3),
        dueDate: DateTime(2024, 11, 3),
        isCompleted: true,
      ),
      TodoTask(
        title: 'Strength training',
        description: 'Complete a full-body workout.',
        tags: ['fitness'],
        startDate: DateTime(2024, 11, 3),
        dueDate: DateTime(2024, 11, 3),
        isCompleted: true,
      ),
    ],
  ),
  Todo(
    title: 'Plan weekend trip',
    description: 'Organize a trip to the mountains for relaxation.',
    importanceLevel: 1,
    tags: ['personal', 'travel'],
    startDate: DateTime(2024, 11, 4),
    dueDate: DateTime(2024, 11, 9),
    isCompleted: false,
    points: 10,
    tasks: [
      TodoTask(
        title: 'Book accommodation',
        description: 'Reserve a cabin in the mountains.',
        tags: ['travel'],
        startDate: DateTime(2024, 11, 4),
        dueDate: DateTime(2024, 11, 5),
        isCompleted: true,
      ),
      TodoTask(
        title: 'Plan activities',
        description: 'Make a list of things to do during the trip.',
        tags: ['personal', 'travel'],
        startDate: DateTime(2024, 11, 6),
        dueDate: DateTime(2024, 11, 7),
        isCompleted: false,
        ),
      ],
    ),
    Todo(
    title: 'Complete the comprehensive documentation for the new feature update and ensure it includes all edge cases, user guides, and developer references for seamless integration',
    description: 'This task involves preparing detailed documentation for the latest feature update. Make sure to cover all possible edge cases, usage scenarios, and provide clear developer integration steps.',
    importanceLevel: 3,
    tags: ['Documentation', 'Critical', 'Development'],
    startDate: DateTime(2024, 11, 24, 9, 0),
    dueDate: DateTime(2024, 12, 1, 17, 0),
    periodicity: Duration(days: 0), // Non-recurring task
    isDeleted: false,
    isCompleted: false,
    isMissed: false,
    tasks: [
      TodoTask(
        title: 'Draft initial outline of the documentation',
        description: 'Prepare a skeleton structure for the documentation.',
        tags: ['Draft', 'Documentation'],
        startDate: DateTime(2024, 11, 24, 9, 30),
        dueDate: DateTime(2024, 11, 25, 12, 0),
        isDeleted: false,
        isCompleted: false,
        isMissed: false,
        folders: ['Documents/FeatureUpdate'],
        links: ['https://docs.company.com/template'],
      ),
      TodoTask(
        title: 'Incorporate feedback from team',
        description: 'Revise the documentation based on initial team feedback.',
        tags: ['Feedback', 'Documentation'],
        startDate: DateTime(2024, 11, 26, 10, 0),
        dueDate: DateTime(2024, 11, 28, 15, 0),
        isDeleted: false,
        isCompleted: false,
        isMissed: false,
        folders: ['Documents/FeatureUpdate'],
        links: [],
      ),
      TodoTask(
        title: 'Finalize and publish documentation',
        description: 'Ensure all revisions are made and publish the final version.',
        tags: ['Finalize', 'Documentation', 'Publish'],
        startDate: DateTime(2024, 11, 29, 9, 0),
        dueDate: DateTime(2024, 11, 30, 17, 0),
        isDeleted: false,
        isCompleted: false,
        isMissed: false,
        folders: ['Documents/FeatureUpdate'],
        links: ['https://docs.company.com/latest'],
      ),
    ],
    folders: ['Projects/FeatureUpdate'],
    links: ['https://docs.company.com'],
    points: 50,
  ),
];


}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch(selectedIndex) {
      case 0:
        page = TasksPage();
        break;
      case 1:
        page = CalendarPage();
        break;
      case 2:
        page = StatisticsPage();
        break;
      case 3:
        page = CemetryPage();
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
                leading: Icon(Icons.task),
                title: Text('Tasks'),
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.calendar_month),
                title: Text('Calendar'),
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Statistics'),
                onTap: () {
                  setState(() {
                    selectedIndex = 2;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text('Cemetery'),
                onTap: () {
                  setState(() {
                    selectedIndex = 3;
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


