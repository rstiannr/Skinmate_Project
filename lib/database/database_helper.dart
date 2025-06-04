import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'skinmate.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // Membuat tabel users
    await db.execute('''
      CREATE TABLE users (
        users_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        gender TEXT CHECK(gender IN ('female', 'male')) DEFAULT NULL,
        age INTEGER DEFAULT NULL,
        skintype TEXT DEFAULT NULL
      )
    ''');

    // Insert users dan simpan users_id
    int restiId = await db.insert('users', {
      'name': 'resti',
      'email': 'r',
      'password': '123',
      'gender': 'female',
      'age': 20,
      'skintype': 'oily',
    });

    int amrizaId = await db.insert('users', {
      'name': 'amriza',
      'email': 'amriza@gmail.com',
      'password': '123',
      'gender': 'female',
      'age': 20,
      'skintype': 'dry',
    });

    int afridaId = await db.insert('users', {
      'name': 'afrida',
      'email': 'afrida@gmail.com',
      'password': '123',
      'gender': 'female',
      'age': 20,
      'skintype': 'normal',
    });

    // Membuat tabel product
    await db.execute('''
      CREATE TABLE product (
        product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        users_id INTEGER NOT NULL,
        type TEXT NOT NULL,
        name TEXT NOT NULL,
        FOREIGN KEY (users_id) REFERENCES users(users_id)
      )
    ''');

    await db.insert('product', {
      'users_id': restiId,
      'type': 'sunscreen',
      'name': 'Emina Sun Protection SPF 30',
    });

    await db.insert('product', {
      'users_id': restiId,
      'type': 'sunscreen',
      'name': 'Wardah Sunscreen Gel SPF 30',
    });

    await db.insert('product', {
      'users_id': restiId,
      'type': 'moisturizer',
      'name': 'Hada Labo Gokujyun Ultimate Moisturizing Lotion',
    });

    await db.insert('product', {
      'users_id': restiId,
      'type': 'moisturizer',
      'name': 'Wardah Hydrating Aloe Vera Gel',
    });

    // Membuat tabel routines
    await db.execute('''
      CREATE TABLE routines (
        routines_id INTEGER PRIMARY KEY AUTOINCREMENT,
        users_id INTEGER NOT NULL,
        product_id INTEGER NOT NULL,
        schedule TEXT CHECK(schedule IN ('morning', 'evening')),
        FOREIGN KEY (users_id) REFERENCES users(users_id),
        FOREIGN KEY (product_id) REFERENCES product(product_id)
      )
    ''');

    // Insert routines dan simpan routines_id
    int routine1 = await db.insert('routines', {
      'users_id': restiId,
      'product_id': 1,
      'schedule': 'morning',
    });

    int routine2 = await db.insert('routines', {
      'users_id': restiId,
      'product_id': 2,
      'schedule': 'evening',
    });

    int routine3 = await db.insert('routines', {
      'users_id': restiId,
      'product_id': 3,
      'schedule': 'morning',
    });

    int routine4 = await db.insert('routines', {
      'users_id': restiId,
      'product_id': 4,
      'schedule': 'evening',
    });

    // Membuat tabel routines_history dengan users_id
    await db.execute('''
      CREATE TABLE routines_history (
        history_id INTEGER PRIMARY KEY AUTOINCREMENT,
        routines_id INTEGER NOT NULL,
        users_id INTEGER NOT NULL,
        done_date TEXT NOT NULL,
        FOREIGN KEY (routines_id) REFERENCES routines(routines_id),
        FOREIGN KEY (users_id) REFERENCES users(users_id)
      )
    ''');

    // Index untuk optimasi query relasi
    await db.execute('CREATE INDEX idx_rh_users_id ON routines_history(users_id)');
    await db.execute('CREATE INDEX idx_rh_routines_id ON routines_history(routines_id)');

    // Menambahkan data default ke tabel routines_history
    await db.insert('routines_history', {
      'routines_id': routine1,
      'users_id': restiId,
      'done_date': '2025-06-05',
    });

    await db.insert('routines_history', {
      'routines_id': routine2,
      'users_id': restiId,
      'done_date': '2025-06-05',
    });

    await db.insert('routines_history', {
      'routines_id': routine3,
      'users_id': restiId,
      'done_date': '2025-06-05',
    });

    await db.insert('routines_history', {
      'routines_id': routine4,
      'users_id': restiId,
      'done_date': '2025-06-05',
    });
  }

  // CRUD Operations for 'users' Table

  Future<int> insertUserWithBasicInfo(
    String name,
    String email,
    String password,
  ) async {
    final db = await database;
    return await db.insert('users', {
      'name': name,
      'email': email,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (res.isNotEmpty) {
      return res.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('users');
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update(
      'users',
      user,
      where: 'users_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('users', where: 'users_id = ?', whereArgs: [id]);
  }

  // CRUD Operations for 'product' Table

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('product', product);
  }

  Future<List<Map<String, dynamic>>> getProductsByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'product',
      where: 'users_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> updateProduct(int productId, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'product',
      product,
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  Future<int> deleteProduct(int productId) async {
    final db = await database;
    return await db.delete(
      'product',
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  }

  // CRUD Operations for 'routines' Table

  Future<int> insertRoutine(Map<String, dynamic> routine) async {
    final db = await database;
    return await db.insert('routines', routine);
  }

  Future<int> updateRoutine(
    int routinesId,
    Map<String, dynamic> routine,
  ) async {
    final db = await database;
    return await db.update(
      'routines',
      routine,
      where: 'routines_id = ?',
      whereArgs: [routinesId],
    );
  }

  Future<int> deleteRoutine(int routinesId) async {
    final db = await database;
    return await db.delete(
      'routines',
      where: 'routines_id = ?',
      whereArgs: [routinesId],
    );
  }

  Future<List<Map<String, dynamic>>> getRoutinesByUserId(int userId) async {
    final db = await database;
    return await db.query(
      'routines',
      where: 'users_id = ?',
      whereArgs: [userId],
    );
  }

  Future<List<Map<String, dynamic>>> getRoutinesByUserIdAndProductId(
    int userId,
    int productId,
  ) async {
    final db = await database;
    return await db.query(
      'routines',
      where: 'users_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  Future<List<Map<String, dynamic>>> getRoutinesByUserIdAndSchedule(
    int userId,
    String schedule,
  ) async {
    final db = await database;
    return await db.query(
      'routines',
      where: 'users_id = ? AND schedule = ?',
      whereArgs: [userId, schedule],
    );
  }

  // CRUD Operations for 'routines_history' Table

  /// Insert routines_history, users_id diambil dari routines
  Future<int> insertRoutineHistory(Map<String, dynamic> history) async {
    final db = await database;
    // Ambil users_id dari routines
    final routine = await db.query(
      'routines',
      where: 'routines_id = ?',
      whereArgs: [history['routines_id']],
      limit: 1,
    );
    if (routine.isEmpty) throw Exception('Routine not found');
    final usersId = routine.first['users_id'];
    final newHistory = Map<String, dynamic>.from(history);
    newHistory['users_id'] = usersId;
    return await db.insert('routines_history', newHistory);
  }

  Future<List<Map<String, dynamic>>> getRoutineHistoryByRoutineId(
    int routinesId,
  ) async {
    final db = await database;
    return await db.query(
      'routines_history',
      where: 'routines_id = ?',
      whereArgs: [routinesId],
    );
  }

  Future<List<Map<String, dynamic>>> getRoutineHistoryByDate(
    String date,
  ) async {
    final db = await database;
    return await db.query(
      'routines_history',
      where: 'done_date = ?',
      whereArgs: [date],
    );
  }

  Future<List<Map<String, dynamic>>> getRoutineHistoryByUserId(
    int userId,
  ) async {
    final db = await database;
    return await db.query(
      'routines_history',
      where: 'users_id = ?',
      whereArgs: [userId],
    );
  }

  Future<int> deleteRoutineHistory(int historyId) async {
    final db = await database;
    return await db.delete(
      'routines_history',
      where: 'history_id = ?',
      whereArgs: [historyId],
    );
  }

  /// Untuk menghapus semua tabel dan database
  Future<void> deleteAllTablesAndDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'skinmate.db');
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
    if (await File(path).exists()) {
      await deleteDatabase(path);
    }
  }

  Future<List<Map<String, dynamic>>>
      getRoutineHistoryByUserIdAndScheduleAndDate(
    int userId,
    String schedule,
    String date,
  ) async {
    final db = await database;
    return await db.rawQuery(
      '''
      SELECT rh.*
      FROM routines_history rh
      JOIN routines r ON rh.routines_id = r.routines_id
      WHERE rh.users_id = ? AND r.schedule = ? AND rh.done_date = ?
      ''',
      [userId, schedule, date],
    );
  }

  Future<int> deleteRoutineHistoryByRoutineIdAndDate(
    int routineId,
    String selectedDateStr,
  ) async {
    final db = await database;
    return await db.delete(
      'routines_history',
      where: 'routines_id = ? AND done_date = ?',
      whereArgs: [routineId, selectedDateStr],
    );
  }
}
