import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/viewmodels/water_tracking_viewmodel.dart';
import 'package:nutripal/views/widgets/water_progress_indicator.dart';

class AddWaterScreen extends ConsumerStatefulWidget {
  const AddWaterScreen({super.key});

  @override
  ConsumerState<AddWaterScreen> createState() => _AddWaterScreenState();
}

class _AddWaterScreenState extends ConsumerState<AddWaterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _customAmountController = TextEditingController();
  double _totalAmount = 0;

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final primaryColor = Theme.of(context).primaryColor;

    final waterTrackingState = ref.watch(waterTrackingViewModelProvider);
    final recommendedDailyWater = ref.watch(recommendedDailyWaterProvider);
    final double currentIntake = waterTrackingState.totalAmount;
    final double goal = recommendedDailyWater;
    final double progress = currentIntake / goal;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ghi nhận lượng nước",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              WaterProgressIndicator(
                currentIntake: currentIntake,
                goal: goal,
                radius: 88,
                progress: progress,
              ),

              const SizedBox(height: 32),
              Container(
                width: deviceSize.width * 0.7,
                padding: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Tổng lượng nước",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _totalAmount.toString(),
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: _totalAmount == 0.0
                                ? Colors.grey[350]
                                : primaryColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "ml",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w500,
                            color: _totalAmount == 0.0
                                ? Colors.grey[350]
                                : primaryColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
              const SizedBox(height: 43),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildWaterSelection(
                    "assets/images/water/cup.png",
                    "250ml",
                    deviceSize,
                    () {
                      setState(() {
                        _totalAmount += 250;
                      });
                    },
                  ),
                  _buildWaterSelection(
                    "assets/images/water/bottle.png",
                    "500ml",
                    deviceSize,
                    () {
                      setState(() {
                        _totalAmount += 500;
                      });
                    },
                  ),
                  _buildWaterSelection(
                    "assets/images/water/jug.png",
                    "1000ml",
                    deviceSize,
                    () {
                      setState(() {
                        _totalAmount += 1000;
                      });
                    },
                  ),
                  _buildWaterSelection(
                    "assets/images/water/water.png",
                    "Tuỳ chỉnh",
                    deviceSize,
                    () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => AnimatedPadding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          duration: const Duration(milliseconds: 100),
                          child: _buildCustomWaterAmountInput(
                            deviceSize.height * 0.2,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _totalAmount == 0
                    ? null
                    : () {
                        ref
                            .read(waterTrackingViewModelProvider.notifier)
                            .addWaterRecord(
                              amount: _totalAmount,
                              consumedAt: TimeOfDay.now(),
                            );
                        ScaffoldMessenger.of(context).clearSnackBars();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Thêm thành công"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  minimumSize: Size(double.infinity, 45),
                  elevation: 6,
                ),
                child: Text(
                  "Lưu",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 19,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    _totalAmount = 0;
                  });
                },
                icon: Icon(Icons.restart_alt_rounded, size: 28),
                label: Text(
                  "Reset",
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomWaterAmountInput(double height) {
    return PopScope(
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _customAmountController.clear();
        }
      },
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Nhập lượng nước",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _customAmountController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "100-5000";
                    }
                    double amount = double.tryParse(value) ?? 0;
                    if (amount < 100 || amount > 5000) {
                      return "100-5000";
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState!.validate()) {
                      double amount = double.parse(value);
                      setState(() {
                        _totalAmount += amount;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[350]!),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    suffixText: "ml",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaterSelection(
    String imagePath,
    String label,
    Size deviceSize,
    VoidCallback onAdd,
  ) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          width: deviceSize.width * 0.2,
          child: Image.asset(imagePath),
        ),
        Text(label),
        const SizedBox(height: 8),
        IconButton.filled(onPressed: onAdd, icon: Icon(Icons.add)),
      ],
    );
  }
}
