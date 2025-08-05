import 'dart:async' show Timer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/food.dart';
import 'package:nutripal/models/meal_record.dart';
import 'package:nutripal/viewmodels/food_viewmodel.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';
import 'package:nutripal/views/widgets/food_list_item.dart';

class AddFoodScreen extends ConsumerStatefulWidget {
  final Meal meal;

  const AddFoodScreen({super.key, required this.meal});

  @override
  ConsumerState<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends ConsumerState<AddFoodScreen> {
  Timer? _debounceTimer;
  final TextEditingController _searchController = TextEditingController();
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();

    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasInitialized) {
      _hasInitialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(foodViewModelProvider.notifier).loadAllFoods();
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _search(String query) {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.isEmpty) {
        ref.read(foodViewModelProvider.notifier).loadAllFoods();
      } else {
        ref.read(foodViewModelProvider.notifier).searchFoods(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final foodState = ref.watch(foodViewModelProvider);
    final mealTrackingViewModel = ref.read(
      mealTrackingViewModelProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.meal.title,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _search,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Tìm kiếm thực phẩm",
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _debounceTimer?.cancel();
                          _searchController.clear();
                          ref
                              .read(foodViewModelProvider.notifier)
                              .loadAllFoods();
                        },
                        icon: Icon(Icons.close, color: primaryColor),
                      )
                    : null,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 1.3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(width: 1.3, color: primaryColor),
                ),
                hintStyle: TextStyle(color: Colors.black54),
              ),
            ),
            const SizedBox(height: 20),
            if (foodState.isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (foodState.foods.isEmpty)
              const Expanded(
                child: Center(child: Text("Không có thực phẩm nào")),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: foodState.foods.length,
                  itemBuilder: (context, index) {
                    final Food food = foodState.foods[index];
                    return FoodListItem(
                      food: food,
                      onAdd: () {
                        mealTrackingViewModel.addFoodToMeal(
                          food: food,
                          meal: widget.meal,
                          servingAmount: 1,
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
