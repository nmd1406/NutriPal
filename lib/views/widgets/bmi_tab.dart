import 'package:flutter/material.dart';
import 'package:nutripal/views/widgets/bmi_indicator.dart';

class BMITab extends StatefulWidget {
  const BMITab({super.key});

  @override
  State<BMITab> createState() => _BMITabState();
}

class _BMITabState extends State<BMITab> {
  final _formKey = GlobalKey<FormState>();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "Chỉ số BMI",
                style: TextStyle(
                  color: Colors.black38,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 22),
              Container(
                height: deviceSize.height * 0.26,
                width: deviceSize.width * 0.7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.grey.withValues(alpha: 0.4),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 4,
                      offset: const Offset(-1, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    children: [
                      Text(
                        "24",
                        style: TextStyle(
                          fontSize: 76,
                          color: Theme.of(context).primaryColorDark,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      BMIIndicator(bmiValue: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
              TextFormField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Chiều cao",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: const Icon(Icons.height, size: 26),
                  suffixText: "cm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: "Cân nặng",
                  labelStyle: TextStyle(fontSize: 15),
                  prefixIcon: const Icon(
                    Icons.monitor_weight_outlined,
                    size: 26,
                  ),
                  suffixText: "kg",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(width: 1.3),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () {}, child: Text("Tính BMI")),
            ],
          ),
        ),
      ),
    );
  }
}
