import '../../models/food.dart';

abstract class IFoodRepository {
  Future<List<Food>> getAllFoods();

  Future<Food?> getFoodById(int id);

  Future<List<Food>> searchFoods(String query);

  Future<List<Food>> getFoodsByCategory(String category);

  Future<int> insertFood(Food food);

  Future<int> updateFood(Food food);

  Future<int> deleteFood(int id);

  Future<void> insertMultipleFoods(List<Food> foods);

  Future<int> getFoodCount();

  Future<void> clearAllFoods();

  Future<List<String>> getAllCategoryNames();

  Future<List<Food>> getFoodsByCategoryPaginated(
    String category, {
    int page = 0,
    int limit = 20,
  });
}
