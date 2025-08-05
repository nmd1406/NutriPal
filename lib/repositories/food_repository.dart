import '../models/food.dart';
import '../services/database_helper.dart';
import 'interfaces/food_interface.dart';

class FoodRepository implements IFoodRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Future<List<Food>> getAllFoods() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('foods');

    return List.generate(maps.length, (index) {
      return Food.fromMap(maps[index]);
    });
  }

  @override
  Future<Food?> getFoodById(int id) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Food.fromMap(maps.first);
    }
    return null;
  }

  @override
  Future<List<Food>> searchFoods(String query) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'name LIKE ? OR category LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );

    return List.generate(maps.length, (index) {
      return Food.fromMap(maps[index]);
    });
  }

  @override
  Future<List<Food>> getFoodsByCategory(String category) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'category = ?',
      whereArgs: [category],
    );

    return List.generate(maps.length, (index) {
      return Food.fromMap(maps[index]);
    });
  }

  @override
  Future<int> insertFood(Food food) async {
    final db = await _databaseHelper.database;
    return await db.insert('foods', food.toMapForInsert());
  }

  @override
  Future<int> updateFood(Food food) async {
    final db = await _databaseHelper.database;
    return await db.update(
      'foods',
      food.toMap(),
      where: 'id = ?',
      whereArgs: [food.id],
    );
  }

  @override
  Future<int> deleteFood(int id) async {
    final db = await _databaseHelper.database;
    return await db.delete('foods', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<String>> getAllCategoryNames() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      'SELECT DISTINCT category FROM foods ORDER BY category',
    );

    return maps.map((map) => map['category'] as String).toList();
  }

  Future<List<String>> getAllCategories() async {
    return getAllCategoryNames();
  }

  @override
  Future<List<Food>> getFoodsByCategoryPaginated(
    String category, {
    int page = 0,
    int limit = 20,
  }) async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'foods',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'name ASC',
      limit: limit,
      offset: page * limit,
    );

    return List.generate(maps.length, (index) {
      return Food.fromMap(maps[index]);
    });
  }

  @override
  Future<int> getFoodCount() async {
    final db = await _databaseHelper.database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM foods',
    );
    return result.first['count'] as int;
  }

  @override
  Future<void> insertMultipleFoods(List<Food> foods) async {
    final db = await _databaseHelper.database;
    final batch = db.batch();

    for (final food in foods) {
      batch.insert('foods', food.toMapForInsert());
    }

    await batch.commit();
  }

  @override
  Future<void> clearAllFoods() async {
    final db = await _databaseHelper.database;
    await db.delete('foods');
  }
}
