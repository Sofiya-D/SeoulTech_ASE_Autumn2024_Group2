import 'package:todo_app/models/todo.dart'; // Import the file where `Todo` is defined

List<Todo> sortTasks(List<Todo> tasks, String sortBy) {
  tasks.sort((a, b) {
    switch (sortBy) {
      case 'dueDate':
        return (a.dueDate ?? DateTime(9999)).compareTo(b.dueDate ?? DateTime(9999));
      case 'priority':
        return b.importanceLevel.compareTo(a.importanceLevel); // Higher priority first
      case 'title':
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      default:
        return 0; // No sorting
    }
  });
  return tasks;
}
