import 'package:flutter/material.dart';
import 'package:nutripal/views/screens/welcome.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  String _selectedGender = ""; // "male" hoặc "female"
  final _formKey = GlobalKey<FormState>();
  String _enteredAge = "";
  String _enteredHeight = "";
  String _enteredWeight = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 100,
        title: Text(
          "Thông tin cơ bản",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Text(
                "Để tính toán chính xác nhu cầu dinh dưỡng, chúng tôi cần một số thông tin cơ bản về bạn",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Giới tính",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGender = "male";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _selectedGender == "male"
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedGender == "male"
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.male,
                                  size: 26, // Giảm icon size
                                  color: _selectedGender == "male"
                                      ? Theme.of(context).primaryColor
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Nam",
                                  style: TextStyle(
                                    fontSize: 16, // Giảm font size
                                    fontWeight: FontWeight.w600,
                                    color: _selectedGender == "male"
                                        ? Theme.of(context).primaryColor
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedGender = "female";
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _selectedGender == "female"
                                  ? Theme.of(
                                      context,
                                    ).primaryColor.withValues(alpha: 0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _selectedGender == "female"
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey[300]!,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.female,
                                  size: 26, // Giảm icon size
                                  color: _selectedGender == "female"
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Nữ",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _selectedGender == "female"
                                        ? Theme.of(
                                            context,
                                          ).colorScheme.secondary
                                        : Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    TextFormField(
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      validator: (String? enteredAge) {
                        if (enteredAge == null || enteredAge.trim().isEmpty) {
                          return "Vui lòng nhập tuổi";
                        }
                        int? age = int.tryParse(enteredAge);
                        if (age == null || age < 10 || age > 100) {
                          return "Tuổi phải từ 10 đến 100";
                        }
                        return null;
                      },
                      onSaved: (String? enteredAge) {
                        _enteredAge = enteredAge!;
                      },
                      decoration: InputDecoration(
                        labelText: "Tuổi",
                        labelStyle: TextStyle(fontSize: 15),
                        prefixIcon: const Icon(Icons.cake_outlined, size: 26),
                        suffixText: "tuổi",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: const BorderSide(width: 1.3),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            validator: (String? enteredHeight) {
                              if (enteredHeight == null ||
                                  enteredHeight.trim().isEmpty) {
                                return "Nhập chiều cao";
                              }
                              double? height = double.tryParse(enteredHeight);
                              if (height == null ||
                                  height < 100 ||
                                  height > 250) {
                                return "100-250cm";
                              }
                              return null;
                            },
                            onSaved: (String? enteredHeight) {
                              _enteredHeight = enteredHeight!;
                            },
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
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autocorrect: false,
                            validator: (String? enteredWeight) {
                              if (enteredWeight == null ||
                                  enteredWeight.trim().isEmpty) {
                                return "Nhập cân nặng";
                              }
                              double? weight = double.tryParse(enteredWeight);
                              if (weight == null ||
                                  weight < 30 ||
                                  weight > 200) {
                                return "30-200kg";
                              }
                              return null;
                            },
                            onSaved: (String? enteredWeight) {
                              _enteredWeight = enteredWeight!;
                            },
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
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    ElevatedButton(
                      onPressed: () {
                        if (_selectedGender.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Vui lòng chọn giới tính")),
                          );
                          return;
                        }

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          // Process form data
                          print("Giới tính: $_selectedGender");
                          print("Tuổi: $_enteredAge");
                          print("Chiều cao: $_enteredHeight cm");
                          print("Cân nặng: $_enteredWeight kg");

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                        elevation: 8,
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      child: Text(
                        "Tiếp tục",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20), // Bottom spacing
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
