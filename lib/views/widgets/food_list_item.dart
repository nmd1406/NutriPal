import 'package:flutter/material.dart';

class FoodListItem extends StatelessWidget {
  final String name;
  final String category;

  const FoodListItem({super.key, required this.name, required this.category});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: primaryColor, width: 2),
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
        leading: SizedBox(
          height: 50,
          width: 50,
          child: Image.asset("assets/images/images.jpg"),
        ),
        title: Text(name),
        subtitle: Text(category),
        trailing: IconButton(
          onPressed: () {},
          icon: Icon(Icons.add, color: primaryColor),
        ),
      ),
    );
  }
}
