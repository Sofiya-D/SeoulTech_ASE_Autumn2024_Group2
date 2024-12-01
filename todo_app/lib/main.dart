import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/models/periodicity.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/models/todo_form_view.dart';
import 'calendar_page.dart';
import 'cemetry_page.dart';
import 'statistics_page.dart';
import 'tasks_page.dart';
import 'create_task_page.dart';
import 'settings_page.dart';


void main() async {
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
    title: 'Project',
    description: 'Total duration of the prject',
    importanceLevel: 1,
    tags: ['work'],
    startDate: DateTime(2024, 11, 1),
    dueDate: DateTime(2024, 12, 15),
    periodicity: Periodicity(months: 1),
    isCompleted: false,
    points: 20,
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
      title:
          'Complete the comprehensive documentation for the new feature update and ensure it includes all edge cases, user guides, and developer references for seamless integration',
      description:
          'This task involves preparing detailed documentation for the latest feature update. Make sure to cover all possible edge cases, usage scenarios, and provide clear developer integration steps.',
      importanceLevel: 3,
      tags: ['Documentation', 'Critical', 'Development'],
      startDate: DateTime(2024, 11, 24, 9, 0),
      dueDate: DateTime(2024, 12, 1, 17, 0),
      //periodicity: Duration(days: 0), // Non-recurring task
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
      periodicity: Periodicity(days: 1), // Recurring task
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
      periodicity: Periodicity(days: 7), // Recurring task
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
    Todo(
      title: "Plan birthday party for best friend",
      dueDate: DateTime.now().add(Duration(days: 10)),
      description:
          "Organize a surprise party with decorations, food, and entertainment.",
      folders: ["Personal", "Events"],
      tasks: [
        TodoTask(
          title:
              "Decide on a party theme and color scheme to match the vibe of the event",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Research and book a venue that fits within the budget and accommodates everyone",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Create a detailed guest list including names, contact information, and RSVPs",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Order or prepare food and drinks, including options for dietary restrictions",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Arrange for decorations, lights, and other party supplies to enhance the atmosphere",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Set up entertainment options, like music playlists, games, or hiring a DJ",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Write and send out invitations to all guests with clear details about the event",
          isCompleted: false,
        ),
      ],
      tags: ["Important", "Social"],
      importanceLevel: 4,
      periodicity: null,
    ),
    Todo(
      title:
          "Plan and execute an end-of-year team-building event to foster collaboration, creativity, and a sense of achievement",
      dueDate: DateTime.now().add(Duration(days: 14)),
      description:
          "Organize an impactful and engaging team-building event to mark the end of the year. This event should help strengthen team relationships, inspire creativity, and celebrate achievements made throughout the year. The planning process should consider diverse team interests and include a mix of fun and meaningful activities that encourage collaboration and personal connections.",
      folders: ["Work", "Team Building"],
      tasks: [
        TodoTask(
          title:
              "Research and shortlist venues that are large enough and cater to the planned activities",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Draft a comprehensive agenda that includes both structured and casual activities",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Coordinate with vendors to arrange for food, drinks, and necessary supplies",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Send a detailed invitation email to all team members including a breakdown of the agenda and event logistics",
          isCompleted: false,
        ),
      ],
      tags: ["Team", "Event Planning", "High Priority"],
      importanceLevel: 5,
      periodicity: null,
    ),
    Todo(
      title:
          "Develop a comprehensive marketing strategy for the launch of the new product line",
      dueDate: DateTime.now().add(Duration(days: 30)),
      description:
          "The goal of this task is to create a detailed marketing strategy that will successfully introduce the new product line to the target audience, generate excitement, and drive sales. This strategy should include a thorough analysis of the current market trends and competitor activities. It must outline clear objectives, key performance indicators, and the intended timeline for each phase of the campaign. Moreover, the strategy should incorporate both digital and traditional marketing channels to ensure a broad reach. The digital strategy should leverage social media platforms, search engine optimization, email campaigns, and influencer partnerships. On the other hand, traditional marketing efforts should include print advertising, in-store promotions, and potential partnerships with local businesses. Collaboration with the sales and design teams is crucial to ensure that the marketing materials align with the brand identity and effectively highlight the product's unique selling points. Special attention should be given to creating high-quality, engaging content that resonates with the audience and clearly communicates the value of the new product line. This task will also involve planning a pre-launch teaser campaign to build anticipation, organizing a memorable launch event, and setting up mechanisms to gather feedback from customers post-launch. Finally, regular monitoring of the campaign's performance and the ability to adapt the strategy as needed based on real-time data are essential to ensure success.",
      folders: ["Work", "Marketing"],
      tasks: [
        TodoTask(
          title:
              "Conduct a detailed market analysis to identify opportunities and challenges",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Collaborate with the sales team to define the key features and benefits of the new product line",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Plan and execute a pre-launch teaser campaign across selected platforms",
          isCompleted: false,
        ),
        TodoTask(
          title:
              "Organize a high-impact product launch event to maximize visibility",
          isCompleted: false,
        ),
      ],
      tags: ["Marketing", "Product Launch", "Strategy"],
      importanceLevel: 4,
      periodicity: null,
    ),
    Todo(
      title: "Prepare for the upcoming team meeting",
      description:
          "This task involves preparing all the necessary materials and discussions for the team meeting, including reviewing progress reports, creating a presentation, and preparing some discussion points.",
      importanceLevel: 3,
      tags: ["work", "meeting", "important"],
      startDate: DateTime(2024, 11, 25, 9, 0),
      dueDate: DateTime(2024, 11, 26, 18, 0),
      periodicity: Periodicity(days: 1),
      isDeleted: false,
      isCompleted: false,
      isMissed: false,
      tasks: [
        TodoTask(
          title: "Review the team's progress reports",
          description:
              "Go over the progress reports from all team members and check for any pending items or blockers. Prepare feedback to provide during the meeting.",
          tags: ["review", "team", "progress"],
          startDate: DateTime(2024, 11, 25, 9, 0),
          dueDate: DateTime(2024, 11, 25, 12, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Reports", "Team Updates"],
          links: ["https://docs.team.com/progress_reports"],
          points: 5,
        ),
        TodoTask(
          title: "Create a presentation for the meeting",
          description:
              "Prepare a PowerPoint presentation covering the main points of the meeting, including project milestones, upcoming tasks, and any issues that need to be discussed.",
          tags: ["presentation", "meeting"],
          startDate: DateTime(2024, 11, 25, 12, 0),
          dueDate: DateTime(2024, 11, 25, 16, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Presentations", "Team Meetings"],
          links: ["https://docs.team.com/meeting_presentation_template"],
          points: 7,
        ),
        TodoTask(
          title: "Prepare discussion points for the meeting",
          description:
              "Make a list of the main points to be discussed during the team meeting. This includes deadlines, issues encountered, and team feedback.",
          tags: ["discussion", "meeting", "agenda"],
          startDate: DateTime(2024, 11, 25, 16, 0),
          dueDate: DateTime(2024, 11, 25, 18, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Team Meetings", "Agenda"],
          links: ["https://docs.team.com/discussion_points"],
          points: 4,
        ),
        TodoTask(
          title: "Send out meeting reminders to the team",
          description:
              "Send a reminder to all team members about the upcoming meeting, including the agenda, location, and time.",
          tags: ["reminder", "meeting", "email"],
          startDate: DateTime(2024, 11, 25, 18, 0),
          dueDate: DateTime(2024, 11, 25, 18, 30),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Email", "Reminders"],
          links: ["https://email.team.com/meeting_reminder_template"],
          points: 3,
        ),
        TodoTask(
          title: "Coordinate with the IT team for the meeting room setup",
          description:
              "Ensure that the meeting room is properly set up with all necessary equipment, including projectors, screens, and working microphones. Verify that the IT team has everything ready.",
          tags: ["coordination", "IT", "meeting room"],
          startDate: DateTime(2024, 11, 25, 10, 0),
          dueDate: DateTime(2024, 11, 25, 11, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["IT", "Meeting Setup"],
          links: ["https://docs.team.com/it_meeting_setup"],
          points: 6,
        ),
        TodoTask(
          title: "Confirm attendee list and send invitations",
          description:
              "Check the list of attendees and confirm their availability for the meeting. Send formal calendar invites with all details.",
          tags: ["attendees", "invites", "calendar"],
          startDate: DateTime(2024, 11, 25, 11, 0),
          dueDate: DateTime(2024, 11, 25, 12, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Invitations", "Attendees"],
          links: ["https://calendar.team.com/meeting_invites"],
          points: 4,
        ),
        TodoTask(
          title: "Finalize and distribute meeting agenda",
          description:
              "Finalize the agenda for the meeting, ensuring that all important topics are covered. Distribute the agenda to all attendees in advance.",
          tags: ["agenda", "finalize", "distribution"],
          startDate: DateTime(2024, 11, 25, 14, 0),
          dueDate: DateTime(2024, 11, 25, 15, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Agenda", "Meeting Materials"],
          links: ["https://docs.team.com/meeting_agenda_final"],
          points: 5,
        ),
        TodoTask(
          title: "Prepare backup plan in case of technical difficulties",
          description:
              "In case of any technical difficulties during the meeting, prepare a backup plan. This includes ensuring that the team has alternative tools ready in case the presentation software fails.",
          tags: ["backup", "plan", "technical"],
          startDate: DateTime(2024, 11, 25, 13, 0),
          dueDate: DateTime(2024, 11, 25, 14, 0),
          periodicity: null,
          isDeleted: false,
          isCompleted: false,
          isMissed: false,
          folders: ["Contingency", "Technical"],
          links: ["https://docs.team.com/technical_backup_plan"],
          points: 6,
        ),
      ],
      folders: ["Team Meeting Preparation", "Work Tasks"],
      links: ["https://docs.team.com/team_meeting_guide"],
      points: 40,
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
