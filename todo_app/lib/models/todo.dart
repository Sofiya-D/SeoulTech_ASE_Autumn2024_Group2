

class Todo {
  // we need :
  // title
  // description
  // importance level
  // tags
  // start date
  // due date
  // periodicity (step ?)
  // is_deleted tag
  // is_completed tag
  // is_missed/is_due tag
  // smaller task list
  // folder/links list
  // point value

  String title;
  String description;
  int importanceLevel;
  List<String> tags;
  DateTime? startDate;
  DateTime? dueDate;
  Duration? periodicity;
  bool isDeleted;
  bool isCompleted;
  bool isMissed;
  List<TodoTask> tasks;
  List<String> folders;
  List<String> links;
  int points;

  Todo({
    required this.title,
    this.description = '',
    this.importanceLevel = 1,
    this.tags = const [],
    this.startDate,
    this.dueDate,
    this.periodicity,
    this.isDeleted = false,
    this.isCompleted = false,
    this.isMissed = false,
    this.tasks = const [],
    this.folders = const [],
    this.links = const [],
    this.points = 0,
  });


}

class TodoTask {
  // we need :
  // title
  // description
  // intermediate steps (text list)
  // start date
  // due date
  // periodicity (step ?)
  // is_deleted tag
  // is_completed tag
  // is_missed/is_due tag
  // folder/links list

  // maybe :
  // tags
  // points

  // not sure :
  // importance level

  String title;
  String description;

  List<String> tags;
  DateTime? startDate;
  DateTime? dueDate;
  Duration? periodicity;
  bool isDeleted;
  bool isCompleted;
  bool isMissed;
  List<TodoTask> tasks;
  List<String> folders;
  List<String> links;
  int points;

  TodoTask({
    required this.title,
    this.description = '',

    this.tags = const [],
    this.startDate,
    this.dueDate,
    this.periodicity,
    this.isDeleted = false,
    this.isCompleted = false,
    this.isMissed = false,
    this.tasks = const [],
    this.folders = const [],
    this.links = const [],
    this.points = 0,
  });


}