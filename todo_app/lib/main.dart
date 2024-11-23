import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/todo.dart';
import 'calendar_page.dart';
import 'cemetry_page.dart';
import 'statistics_page.dart';
import 'tasks_page.dart';
import 'create_task_page.dart';

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
  var taskList = <Todo>[
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
      title:
          'Complete the comprehensive documentation for the new feature update and ensure it includes all edge cases, user guides, and developer references for seamless integration',
      description:
          'This task involves preparing detailed documentation for the latest feature update. Make sure to cover all possible edge cases, usage scenarios, and provide clear developer integration steps.',
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
          description:
              'Revise the documentation based on initial team feedback.',
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
          description:
              'Ensure all revisions are made and publish the final version.',
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
    Todo(
      title: 'Plan the team meeting agenda for Q4 review',
      description:
          'Prepare a detailed agenda for the upcoming Q4 review meeting.',
      importanceLevel: 2,
      tags: ['Meeting', 'Planning'],
      startDate: DateTime(2024, 12, 5, 10, 0), // Has startDate
      isCompleted: false,
      tasks: [],
      folders: ['Team/Meetings/Q4'],
      links: ['https://calendar.app/meeting'],
      points: 10,
    ),
    Todo(
      title: 'Submit project proposal to the funding committee',
      description:
          'Ensure all sections of the proposal are completed and submit by the due date.',
      importanceLevel: 3,
      tags: ['Proposal', 'Funding'],
      dueDate: DateTime(2024, 12, 10, 17, 0), // Has dueDate
      isCompleted: false,
      tasks: [
        TodoTask(
          title: 'Review previous proposals for formatting',
          description:
              'Look at previously submitted proposals to ensure consistency.',
          dueDate: DateTime(2024, 12, 8, 12, 0),
          isCompleted: false,
        ),
        TodoTask(
          title: 'Finalize budget section',
          description: 'Double-check numbers and include justification.',
          isCompleted: false,
        ),
      ],
      folders: ['Projects/FundingCommittee'],
      links: [],
      points: 20,
    ),
    Todo(
      title: 'Daily stand-up meetings',
      description:
          'Regular meetings to sync with the team about daily tasks and blockers.',
      importanceLevel: 1,
      tags: ['Meeting', 'Daily'],
      periodicity: Duration(days: 1), // Recurring task
      isCompleted: false,
      folders: ['Team/StandUps'],
      links: [],
      points: 5,
    ),
    Todo(
      title: 'Organize holiday party',
      description: 'Plan and execute the company’s annual holiday party.',
      importanceLevel: 2,
      tags: ['Event', 'Holiday'],
      startDate: DateTime(2024, 12, 15, 9, 0), // Has startDate
      dueDate: DateTime(2024, 12, 20, 17, 0), // Has dueDate
      isCompleted: false,
      tasks: [
        TodoTask(
          title: 'Book a venue',
          description: 'Find a venue that can accommodate at least 100 people.',
          isCompleted: false,
        ),
        TodoTask(
          title: 'Send out invitations',
          description: 'Send invitations to all employees.',
          startDate: DateTime(2024, 12, 16, 9, 0),
          isCompleted: false,
        ),
      ],
      folders: ['Events/Holiday2024'],
      links: [],
      points: 25,
    ),
    Todo(
      title: 'Personal development: Read a new book every week',
      description: 'Enhance knowledge by reading a new book weekly.',
      importanceLevel: 1,
      tags: ['Personal', 'Reading'],
      periodicity: Duration(days: 7), // Recurring task
      isCompleted: false,
      folders: ['Personal/Development'],
      links: ['https://readinglist.app'],
      points: 15,
    ),
    Todo(
      title: 'Prepare for year-end tax filing',
      description: 'Compile necessary documents and review tax-related forms.',
      importanceLevel: 4,
      tags: ['Finance', 'Tax'],
      isCompleted: false,
      folders: ['Finance/Taxes'],
      links: [],
      points: 30,
    ),
    Todo(
      title: 'Submit final report for the marketing campaign',
      description:
          'Complete the final analysis and submit the report to the management team.',
      importanceLevel: 3,
      tags: ['Report', 'Marketing'],
      dueDate: DateTime(2024, 12, 5, 17, 0), // Only dueDate
      isCompleted: false,
      tasks: [],
      folders: ['Reports/Marketing'],
      links: [],
      points: 20,
    ),
    Todo(
      title: 'Complete client project presentation',
      description:
          'Prepare and finalize the client project presentation for the upcoming meeting.',
      importanceLevel: 2,
      tags: ['Presentation', 'Client'],
      dueDate: DateTime(2024, 12, 8, 14, 0), // Only dueDate
      isCompleted: false,
      tasks: [],
      folders: ['Presentations/Client'],
      links: [],
      points: 15,
    ),
    Todo(
      title: 'Research new features for the app update',
      description:
          'Investigate potential features that can be added in the next app update, including user feedback and competitor analysis.',
      importanceLevel: 4,
      tags: ['Research', 'App Update', 'Features'],
      startDate: DateTime(2024, 11, 30, 9, 0),
      dueDate: DateTime(2024, 12, 10, 17, 0),
      isCompleted: false,
      tasks: [
        TodoTask(
          title: 'Analyze user feedback from last update',
          description:
              'Review user feedback and identify common requests for new features.',
          isCompleted: false,
        ),
        TodoTask(
          title: 'Compare competitor app features',
          description:
              'Research and document features offered by competitors to consider in the app update.',
          isCompleted: false,
        ),
      ],
      folders: ['Research/App Update'],
      links: [
        'https://www.researchapp.com/feature-request',
        'https://www.competitor.com/features',
        'https://docs.appupdate.com/roadmap'
      ], // Multiple links
      points: 40,
    ),
    Todo(
      title: 'Prepare marketing strategy for new product launch',
      description:
          'Develop a comprehensive marketing strategy that includes social media, content creation, and influencer partnerships for the new product.',
      importanceLevel: 4,
      tags: [
        'Marketing',
        'Product Launch',
        'Social Media',
        'Influencer Marketing',
        'Strategy',
        'Content Creation',
        'Campaign'
      ], // Many tags for categorization and filtering
      startDate: DateTime(2024, 12, 1, 9, 0),
      dueDate: DateTime(2024, 12, 15, 17, 0),
      isCompleted: false,
      tasks: [
        TodoTask(
          title: 'Create content plan for product launch',
          description:
              'Develop a content calendar that aligns with the product launch schedule.',
          isCompleted: false,
          tags: ['Content Plan', 'Marketing', 'Launch'],
        ),
        TodoTask(
          title: 'Reach out to influencers for partnership',
          description:
              'Contact influencers for collaboration and set terms for product promotion.',
          isCompleted: false,
          tags: ['Influencer Outreach', 'Marketing', 'Partnership'],
        ),
      ],
      folders: ['Projects/ProductLaunch'],
      links: ['https://company.com/product-launch-strategy'],
      points: 50,
    ),
  ];
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = CreateTaskPage();
        break;
      case 1:
        page = TasksPage();
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
