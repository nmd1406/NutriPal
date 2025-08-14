import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nutripal/models/food.dart';
import 'package:nutripal/models/food_record.dart';
import 'package:nutripal/viewmodels/meal_tracking_viewmodel.dart';

class EditFoodEntryScreen extends ConsumerStatefulWidget {
  final Food food;

  const EditFoodEntryScreen({super.key, required this.food});

  @override
  ConsumerState<EditFoodEntryScreen> createState() =>
      _EditFoodEntryScreenState();
}

class _EditFoodEntryScreenState extends ConsumerState<EditFoodEntryScreen> {
  TimeOfDay _selectedTime = TimeOfDay.now();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _servingController = TextEditingController(
    text: "1",
  );

  double get _servingAmount {
    final value = double.tryParse(_servingController.text);
    return value != null && value > 0 ? value : 1.0;
  }

  @override
  void dispose() {
    _servingController.dispose();
    super.dispose();
  }

  Future<TimeOfDay?> _selectTime() async {
    return await showTimePicker(context: context, initialTime: TimeOfDay.now());
  }

  String _formatTime(TimeOfDay time) {
    final DateTime temp = DateTime.now();
    final dateTime = DateTime(
      temp.year,
      temp.month,
      temp.day,
      time.hour,
      time.minute,
    );
    final formatter = DateFormat.Hm();

    return formatter.format(dateTime);
  }

  void _addFood(Meal selectedMeal) {
    if (_formKey.currentState!.validate()) {
      ref
          .read(mealTrackingViewModelProvider.notifier)
          .addFoodToMeal(
            food: widget.food,
            meal: selectedMeal,
            servingAmount: _servingAmount,
            consumedAt: _selectedTime,
          );

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Thêm thành công"),
          duration: Duration(seconds: 1),
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    const Divider divider = Divider(height: 24, thickness: 2);
    final deviceSize = MediaQuery.of(context).size;

    Meal currentMeal = ref.watch(currentMealProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.food.name,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => _addFood(currentMeal),
            icon: Icon(Icons.check, color: primaryColor, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Bữa", style: TextStyle(fontSize: 18)),
                    SizedBox(
                      width: deviceSize.width * 0.3,
                      child: DropdownButtonFormField<Meal>(
                        value: currentMeal,
                        padding: const EdgeInsets.only(left: 8),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          DropdownMenuItem<Meal>(
                            value: Meal.breakfast,
                            child: Text("Bữa sáng"),
                          ),
                          DropdownMenuItem<Meal>(
                            value: Meal.lunch,
                            child: Text("Bữa trưa"),
                          ),
                          DropdownMenuItem<Meal>(
                            value: Meal.dinner,
                            child: Text("Bữa tối"),
                          ),
                          DropdownMenuItem<Meal>(
                            value: Meal.snack,
                            child: Text("Bữa phụ"),
                          ),
                        ],
                        onChanged: (Meal? selectedMeal) {
                          if (selectedMeal != null) {
                            ref.read(currentMealProvider.notifier).state =
                                selectedMeal;
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Khẩu phần", style: TextStyle(fontSize: 18)),
                    SizedBox(
                      width: deviceSize.width * 0.12,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _servingController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "1-10";
                            }
                            double serving = double.tryParse(value) ?? 0.0;
                            if (serving <= 0 || serving > 10) {
                              return "1-10";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            isDense: true,
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Thời gian", style: TextStyle(fontSize: 18)),
                    TextButton(
                      onPressed: () async {
                        final selectedTime = await _selectTime();
                        if (selectedTime != null) {
                          setState(() {
                            _selectedTime = selectedTime;
                          });
                        }
                      },
                      child: Text(
                        _formatTime(_selectedTime),
                        style: TextStyle(color: primaryColor, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
              divider,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SizedBox(
                      width: 130,
                      height: 130,
                      child: CustomPaint(
                        painter: MacroChartPainter(
                          carbPercent: widget.food.carbPercent,
                          fatPercent: widget.food.fatPercent,
                          proteinPercent: widget.food.proteinPercent,
                          carbColor: widget.food.carbColor,
                          fatColor: widget.food.fatColor,
                          proteinColor: widget.food.proteinColor,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${(widget.food.caloriesPerServing * _servingAmount).round()}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "cal",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildMacroLegend(
                          color: widget.food.carbColor,
                          label: "Carbs",
                          value: widget.food.carb * _servingAmount,
                          percent: widget.food.carbPercent,
                        ),
                        _buildMacroLegend(
                          color: widget.food.fatColor,
                          label: "Fat",
                          value: widget.food.fat * _servingAmount,
                          percent: widget.food.fatPercent,
                        ),
                        _buildMacroLegend(
                          color: widget.food.proteinColor,
                          label: "Protein",
                          value: widget.food.protein * _servingAmount,
                          percent: widget.food.proteinPercent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroLegend({
    required Color color,
    required String label,
    required double value,
    required double percent,
  }) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "${(percent * 100).toStringAsFixed(1)}%",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        Text(
          "${value}g",
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class MacroChartPainter extends CustomPainter {
  final double carbPercent;
  final double fatPercent;
  final double proteinPercent;
  final Color carbColor;
  final Color fatColor;
  final Color proteinColor;

  MacroChartPainter({
    required this.carbPercent,
    required this.fatPercent,
    required this.proteinPercent,
    required this.carbColor,
    required this.fatColor,
    required this.proteinColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final strokeWidth = 12.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    final total = carbPercent + fatPercent + proteinPercent;
    final carbAngle = (carbPercent / total) * 2 * pi;
    final fatAngle = (fatPercent / total) * 2 * pi;
    final proteinAngle = (proteinPercent / total) * 2 * pi;

    double startAngle = -pi / 2;

    paint.color = carbColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      carbAngle,
      false,
      paint,
    );

    startAngle += carbAngle;
    paint.color = fatColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      fatAngle,
      false,
      paint,
    );

    startAngle += fatAngle;
    paint.color = proteinColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      proteinAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
