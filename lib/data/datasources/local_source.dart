import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:task_dropper/data/models/task_model.dart';
import 'package:task_dropper/data/models/user_model.dart';

class LocalDataSource {
  static final LocalDataSource _instance = LocalDataSource._();

  factory LocalDataSource() => _instance;

  LocalDataSource._();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<void> _createUserTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY,
        username TEXT,
        mail TEXT UNIQUE,
        password TEXT,
        isActive INTEGER,
        createdAt DATETIME,
        updatedAt DATETIME
      )
      ''',
    );
  }

  Future<void> _createTaskTable(Database db) async {
    await db.execute(
      '''
      CREATE TABLE tasks(
        id INTEGER PRIMARY KEY,
        title TEXT,
        description TEXT,
        isDeleted INTEGER,
        isCompleted INTEGER,
        createdAt DATETIME,
        updatedAt DATETIME,
        userId INTEGER,
        FOREIGN KEY (userId) REFERENCES users(id)
      )
      ''',
    );
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'task_dropper.db');
    return openDatabase(
      path,
      onCreate: (db, version) async {
        await _createTaskTable(db);
        await _createUserTable(db);
      },
      version: 1,
    );
  }

  Future<void> insertTask(String title, String description, int userId) async {
    final task = Task(
      title: title,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      userId: userId
    );
    final db = await database;
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getTasksForUser(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  Future<void> updateTask(Task task) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'title': task.title,
        'description': task.description,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<void> changeTaskDeletedStatus(int taskId, bool status) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'isDeleted': status ? 1 : 0
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<void> changeTaskCompletedStatus(int taskId, bool status) async {
    final db = await database;
    await db.update(
      'tasks',
      {
        'isCompleted': status ? 1 : 0
      },
      where: 'id = ?',
      whereArgs: [taskId],
    );
  }

  Future<bool> registerUser(String username, String mail, String password) async {
    try {
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
      final user = User(
        username: username,
        mail: mail,
        password: hashedPassword,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final db = await database;
      await db.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      return true;
    } catch (e) {
      print('Erro durante o registro do usuário: $e');
      return false;
    }
  }

  Future<bool> verifyLogin(String mail, String password) async {
    final user = await getUserByMail(mail);
    if (user != null && user.isActive == true) {
      return await user.verifyPassword(password);
    }
    return false;
  }

  Future<List<User>> getUsers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('users');
    return List.generate(maps.length, (i) {
      return User.fromMap(maps[i]);
    });
  }

  Future<User?> getUserByMail(String mail) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'mail = ?',
      whereArgs: [mail],
    );
    if (maps.isNotEmpty) {
      return User(
        id: maps[0]['id'],
        username: maps[0]['username'],
        mail: maps[0]['mail'],
        password: maps[0]['password'],
        isActive: maps[0]['isActive'] == 1 ? true : false,
        createdAt: DateTime.parse(maps[0]['createdAt']),
        updatedAt: DateTime.parse(maps[0]['updatedAt']),
      );
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    final hashedPassword = BCrypt.hashpw(user.password, BCrypt.gensalt());

    await db.update(
      'users',
      {
        'username': user.username,
        'mail': user.mail,
        'passwordHash': hashedPassword,
        'updatedAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<void> changeUserActiveStatus(int userId, bool status) async {
    final db = await database;

    await db.update(
      'users',
      {
        'isActive': status ? 1 : 0
      },
      where: 'id = ?',
      whereArgs: [userId],
    );
  }
}