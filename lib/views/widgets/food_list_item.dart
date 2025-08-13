import 'package:flutter/material.dart';
import 'package:nutripal/models/food.dart';
import 'package:nutripal/views/screens/edit_food_entry_screen.dart';

class FoodListItem extends StatelessWidget {
  final Food food;
  final VoidCallback onAdd;

  const FoodListItem({super.key, required this.food, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => EditFoodEntryScreen(food: food),
          ),
        ),
        title: Text(
          food.name,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${food.category} • ${food.caloriesPerServing.toStringAsFixed(0)} cal, ${food.servingSize.toStringAsFixed(0)} ${food.servingUnit}",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
        ),
        trailing: IconButton(
          onPressed: () {
            onAdd();
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Thêm thành công"),
                duration: Duration(seconds: 1),
              ),
            );
          },
          icon: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
