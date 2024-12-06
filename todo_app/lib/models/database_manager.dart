import 'package:sqflite/sqflite.dart'; // for SQL files interactions/management
import 'package:path/path.dart';
import 'package:todo_app/models/todo.dart';

class DatabaseManager {
  static const String dbName =
      'exampleTasks.db'; // !! TEMPORARY !! - For dev & debug purposes, change/remove before release !
  static const int dbVersion = 1;

  // Table Names
  static const String tasksTable = 'tasks';
  static const String subtasksTable = 'subtasks';

  // Singleton instance
  // To ensure only 1 database exists
  static final DatabaseManager instance = DatabaseManager._privateConstructor();
  DatabaseManager._privateConstructor();

  static Database? _database;

  ///
  /// Checks if the database already exists
  /// 
  /// true -> the database exists
  /// 
  /// false -> the database doesn't exist
  /// 
  Future<bool> exists() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return databaseExists(path); // Use sqflite's built-in method
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);

    return await openDatabase(
      path,
      version: dbVersion,
      onCreate: (db, version) async {
        await _createTables(db);
      },
    );
  }

  Future<void> _createTables(Database db) async {
    // Tasks Table
    await db.execute('''
    CREATE TABLE IF NOT EXISTS $tasksTable (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      description TEXT,
      importanceLevel INTEGER,
      tags TEXT,  -- Add this line for the tags column
      startDate TEXT,
      dueDate TEXT,
      periodicity TEXT,  -- Add this line for the periodicity column (as a JSON string)
      isDeleted INTEGER,
      isCompleted INTEGER,
      isMissed INTEGER,
      folders TEXT,  -- Add this line for folders
      links TEXT,  -- Add this line for links
      points INTEGER
    )
  ''');

    // Subtasks Table
    await db.execute('''
  CREATE TABLE IF NOT EXISTS $subtasksTable (
    id TEXT PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    tags TEXT,
    startDate TEXT,
    dueDate TEXT,
    periodicity TEXT,
    isDeleted INTEGER,
    isCompleted INTEGER,
    isMissed INTEGER,
    folders TEXT,
    links TEXT,
    points INTEGER,
    parentId TEXT,  -- Add the parentId column, to link the subtasks to their parent task
    FOREIGN KEY (parentId) REFERENCES $tasksTable(id)  -- Foreign key referencing the tasks table
  )
''');
  }

  ///
  /// To insert multiple tasks into the tasks database.
  ///
  /// will trigger the database creation if it doesn't exist yet
  ///
  Future<void> insertMultipleTasks(List<Todo> tasks) async {
    // Ensure 'db' points to our initialized database.
    // will also create the database if needed
    final db = await database;

    for (var task in tasks) {
      // Insert the main task.
      int taskId = await db.insert(tasksTable, task.toMap());
      // Insert subtasks.
      for (var subtask in task.tasks) {
        await db.insert(
          subtasksTable,
          subtask.toMap()..['parentId'] = taskId, // Include the parent task ID.
        );
      }
    }
  }

  ///
  /// Fetches all the tasks from the database
  /// 
  Future<List<Todo>> getAllTasks() async {
    // Open the database
    final db = await database;

    // Fetch all rows from the "todos" table
    final List<Map<String, dynamic>> mainTasks = await db.query(tasksTable);

    // Map each row to a Todo object
    return mainTasks.map((taskMap) {
      return Todo.fromMap(
          taskMap); // Use the factory constructor of Todo to deserialize
    }).toList();
  }

  ///
  /// To set the entire database to a defined set of tasks
  ///
  /// !! caution !! Deletes all previously present tasks
  ///
  Future<void> setAllTasks(List<Todo> tasks) async {
    await delete();
    await insertMultipleTasks(tasks);
  }

  ///
  /// To delete the database
  ///
  Future<void> delete() async {
    await deleteDatabase(join(await getDatabasesPath(), dbName));
  }
}