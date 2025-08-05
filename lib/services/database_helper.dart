import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'nutripal.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE foods (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        category TEXT NOT NULL,
        servingSize REAL NOT NULL,
        servingUnit TEXT NOT NULL,
        caloriesPerServing REAL NOT NULL,
        protein REAL NOT NULL,
        carb REAL NOT NULL,
        fat REAL NOT NULL,
        createdAt TEXT DEFAULT CURRENT_TIMESTAMP,
        updatedAt TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Insert some sample data
    await _insertSampleData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades here
    if (oldVersion < newVersion) {
      // Example: Add new columns, tables, etc.
    }
  }

  Future<void> _insertSampleData(Database db) async {
    final sampleFoods = [
      {
        'name': 'Cơm trắng',
        'category': 'Tinh bột',
        'servingSize': 100.0,
        'servingUnit': 'gram',
        'caloriesPerServing': 130.0,
        'protein': 2.7,
        'carb': 28.0,
        'fat': 0.3,
      },
      {
        'name': 'Thịt bò',
        'category': 'Protein',
        'servingSize': 100.0,
        'servingUnit': 'gram',
        'caloriesPerServing': 250.0,
        'protein': 26.0,
        'carb': 0.0,
        'fat': 17.0,
      },
      {
        'name': 'Chuối',
        'category': 'Trái cây',
        'servingSize': 1.0,
        'servingUnit': 'quả',
        'caloriesPerServing': 105.0,
        'protein': 1.3,
        'carb': 27.0,
        'fat': 0.3,
      },
    ];

    for (var food in sampleFoods) {
      await db.insert('foods', food);
    }
  }

  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
