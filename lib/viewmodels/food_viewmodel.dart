import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/food.dart';
import 'package:nutripal/repositories/food_repository.dart';

class FoodState {
  final List<Food> foods;
  final bool isLoading;
  final String? error;

  const FoodState({this.foods = const [], this.isLoading = false, this.error});

  FoodState copyWith({List<Food>? foods, bool? isLoading, String? error}) {
    return FoodState(
      foods: foods ?? this.foods,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FoodViewModel extends StateNotifier<FoodState> {
  final FoodRepository _foodRepository;

  FoodViewModel(this._foodRepository) : super(const FoodState());

  Future<void> loadAllFoods() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final foods = await _foodRepository.getAllFoods();
      state = state.copyWith(foods: foods, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> searchFoods(String query) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final foods = await _foodRepository.searchFoods(query);
      state = state.copyWith(foods: foods, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> loadFoodsByCategory(String category) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final foods = await _foodRepository.getFoodsByCategory(category);
      state = state.copyWith(foods: foods, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addFood(Food food) async {
    try {
      final insertedId = await _foodRepository.insertFood(food);
      if (insertedId > 0) {
        final newFood = food.copyWith(id: insertedId);
        state = state.copyWith(foods: [...state.foods, newFood]);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> updateFood(Food food) async {
    try {
      final rowsAffected = await _foodRepository.updateFood(food);
      if (rowsAffected > 0) {
        final updatedFoods = state.foods.map((f) {
          return f.id == food.id ? food : f;
        }).toList();
        state = state.copyWith(foods: updatedFoods);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> deleteFood(int id) async {
    try {
      final rowsAffected = await _foodRepository.deleteFood(id);
      if (rowsAffected > 0) {
        final updatedFoods = state.foods.where((f) => f.id != id).toList();
        state = state.copyWith(foods: updatedFoods);
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<List<String>> getAllCategories() async {
    try {
      return await _foodRepository.getAllCategoryNames();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return [];
    }
  }

  Future<int> getFoodCount() async {
    try {
      return await _foodRepository.getFoodCount();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return 0;
    }
  }

  Future<void> loadFoodsByCategoryPaginated(
    String category, {
    int page = 0,
    int limit = 20,
    bool append = false,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final foods = await _foodRepository.getFoodsByCategoryPaginated(
        category,
        page: page,
        limit: limit,
      );

      if (append) {
        state = state.copyWith(
          foods: [...state.foods, ...foods],
          isLoading: false,
        );
      } else {
        state = state.copyWith(foods: foods, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addMultipleFoods(List<Food> foods) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _foodRepository.insertMultipleFoods(foods);
      await loadAllFoods();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> clearAllFoods() async {
    try {
      await _foodRepository.clearAllFoods();
      state = state.copyWith(foods: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<Food?> getFoodById(int id) async {
    try {
      return await _foodRepository.getFoodById(id);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  void sortFoodsByName({bool ascending = true}) {
    final sortedFoods = List<Food>.from(state.foods);
    if (ascending) {
      sortedFoods.sort((a, b) => a.name.compareTo(b.name));
    } else {
      sortedFoods.sort((a, b) => b.name.compareTo(a.name));
    }
    state = state.copyWith(foods: sortedFoods);
  }

  void sortFoodsByCalories({bool ascending = false}) {
    final sortedFoods = List<Food>.from(state.foods);
    if (ascending) {
      sortedFoods.sort(
        (a, b) => a.caloriesPerServing.compareTo(b.caloriesPerServing),
      );
    } else {
      sortedFoods.sort(
        (a, b) => b.caloriesPerServing.compareTo(a.caloriesPerServing),
      );
    }
    state = state.copyWith(foods: sortedFoods);
  }

  void sortFoodsByProtein({bool ascending = false}) {
    final sortedFoods = List<Food>.from(state.foods);
    if (ascending) {
      sortedFoods.sort((a, b) => a.protein.compareTo(b.protein));
    } else {
      sortedFoods.sort((a, b) => b.protein.compareTo(a.protein));
    }
    state = state.copyWith(foods: sortedFoods);
  }

  void sortFoodsByCategory({bool ascending = true}) {
    final sortedFoods = List<Food>.from(state.foods);
    if (ascending) {
      sortedFoods.sort((a, b) => a.category.compareTo(b.category));
    } else {
      sortedFoods.sort((a, b) => b.category.compareTo(a.category));
    }
    state = state.copyWith(foods: sortedFoods);
  }
}

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository();
});

final foodViewModelProvider = StateNotifierProvider<FoodViewModel, FoodState>((
  ref,
) {
  final repository = ref.read(foodRepositoryProvider);
  return FoodViewModel(repository);
});
