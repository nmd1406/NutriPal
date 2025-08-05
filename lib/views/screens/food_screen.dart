import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nutripal/models/food.dart';
import 'package:intl/intl.dart';

class FoodScreen extends StatefulWidget {
  final Food food;

  const FoodScreen({super.key, required this.food});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen> {
  TimeOfDay? _selectedTime;
  String _selectedMeal = "Bữa sáng";
  final TextEditingController _servingController = TextEditingController(
    text: "1",
  );

  double get servingAmount {
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
    final now = DateTime.now();
    final dateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );
    final formatter = DateFormat.Hm();

    return formatter.format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    const Divider divider = Divider(height: 24, thickness: 2);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.food.name,
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Ghi nhận thực phẩm này vào List<Food> của bữa tương ứng
              Navigator.of(context).pop();
            },
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
                      child: DropdownButtonFormField<String>(
                        value: _selectedMeal,
                        padding: const EdgeInsets.only(left: 8),
                        style: TextStyle(
                          color: primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        items: [
                          DropdownMenuItem<String>(
                            value: "Bữa sáng",
                            child: Text("Bữa sáng"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Bữa trưa",
                            child: Text("Bữa trưa"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Bữa tối",
                            child: Text("Bữa tối"),
                          ),
                          DropdownMenuItem<String>(
                            value: "Bữa phụ",
                            child: Text("Bữa phụ"),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedMeal = value!;
                          });
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
                        _selectedTime == null
                            ? "Chọn"
                            : _formatTime(_selectedTime!),
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
                                "${(widget.food.caloriesPerServing * servingAmount).round()}",
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
                          value: widget.food.carb * servingAmount,
                          percent: widget.food.carbPercent,
                        ),
                        _buildMacroLegend(
                          color: widget.food.fatColor,
                          label: "Fat",
                          value: widget.food.fat * servingAmount,
                          percent: widget.food.fatPercent,
                        ),
                        _buildMacroLegend(
                          color: widget.food.proteinColor,
                          label: "Protein",
                          value: widget.food.protein * servingAmount,
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
