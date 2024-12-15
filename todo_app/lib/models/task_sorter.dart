import 'package:todo_app/models/todo.dart'; // Import the file where `Todo` is defined

List<Todo> sortTasks(List<Todo> tasks, String sortBy) {
  tasks.sort((a, b) {
    switch (sortBy) {
      case 'dueDate':
        return (a.dueDate ?? DateTime(9999))
            .compareTo(b.dueDate ?? DateTime(9999));
      case 'priority':
        return b.importanceLevel
            .compareTo(a.importanceLevel); // Higher priority first
      case 'Title':
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      case 'dead':
        return (b.dueDate ?? DateTime(9999))
            .compareTo(a.dueDate ?? DateTime(9999));
      default:
        return 0; // No sorting
    }
  });
  return tasks;
}

Map<String, List<Todo>> groupTasksByCriteria(
    List<Todo> tasks, String sortCriteria) {
  var now = DateTime.now();
  List<Todo> deadTasks = sortTasks(
      tasks.where((task) {
        return isDead(task);
      }).toList(),
      sortCriteria);

  switch (sortCriteria) {
    case 'dueDate':
      return {
        'Today': tasks.where((task) {
          return task.dueDate != null &&
              !isDead(task) &&
              task.dueDate!.isAfter(DateTime(now.year, now.month, now.day)) &&
              task.dueDate!
                  .isBefore(DateTime(now.year, now.month, now.day + 1));
        }).toList(),
        'This Week': tasks.where((task) {
          var in7days = now.add(Duration(days: 7 - now.weekday));
          return task.dueDate != null &&
              !isDead(task) &&
              task.dueDate!.isAfter(DateTime(now.year, now.month, now.day)) &&
              task.dueDate!.isBefore(in7days);
        }).toList(),
        'Later': tasks.where((task) {
          return task.dueDate == null && !isDead(task) ||
              task.dueDate!.isAfter(DateTime(now.year, now.month, now.day + 7));
        }).toList(),
        'Cemetery': deadTasks,
      };

    case 'priority':
      // Find the biggest priority
      int maxPriority = tasks.isNotEmpty
          ? tasks
              .map((task) => task.importanceLevel)
              .reduce((a, b) => a > b ? a : b)
          : 0;
      // Group tasks by decreasing priority level
      var groupedTasks = Map.fromEntries(
        List.generate(maxPriority, (priority) {
          int currentPriority = maxPriority - priority;
          return MapEntry(
            'Priority $currentPriority',
            tasks
                .where((task) =>
                    task.importanceLevel == currentPriority && !isDead(task))
                .toList(),
          );
        }),
      );
      // Add the "Cemetery" section
      groupedTasks['Cemetery'] = deadTasks;
      return groupedTasks;

    case 'tag':
      // Count tasks per tag
      Map<String, List<Todo>> tagGroups = {};
      for (var task in tasks) {
        for (var tag in task.tags) {
          tagGroups.putIfAbsent(tag, () => []).add(task);
        }
      }
      // Sort sections by number of tasks in descending order
      var sortedTags = tagGroups.keys.toList()
        ..sort((a, b) => tagGroups[b]!.length.compareTo(tagGroups[a]!.length));
      var groupedTasks = {for (var tag in sortedTags) tag: tagGroups[tag]!};
      // Add the "Cemetery" section
      groupedTasks['Cemetery'] = deadTasks;
      return groupedTasks;

    case 'title':
      return {
        'Upcoming':
            sortTasks(tasks.where((task) => !isDead(task)).toList(), 'Title'),
        'Cemetery': deadTasks,
      };
    default:
      return {
        'Upcoming Tasks': tasks.where((task) => !isDead(task)).toList(),
        'Cemetery': deadTasks,
      };
  }
}

bool isDead(Todo task) {
  var now = DateTime.now();
  return (task.dueDate != null &&
      task.dueDate!.isBefore(DateTime(now.year, now.month, now.day)) ||
          task.isCompleted ||
          task.isMissed);
}
