import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class AddWeightRecordScreen extends ConsumerStatefulWidget {
  const AddWeightRecordScreen({super.key});

  @override
  ConsumerState<AddWeightRecordScreen> createState() =>
      _AddWeightRecordScreenState();
}

class _AddWeightRecordScreenState extends ConsumerState<AddWeightRecordScreen> {
  late TextEditingController _weightController;
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    double currentWeight = ref.read(currentWeightProvider);
    _weightController = TextEditingController(
      text: _formatDouble(currentWeight),
    );
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  String _formatDouble(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return value.toStringAsFixed(1);
  }

  Future<DateTime?> _selectDate() async {
    return await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      initialDate: DateTime.now(),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _pickImageFromGallery() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedImage = File(picked.path);
    });
  }

  Future<void> _pickImageFromCamera() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.camera);

    if (picked == null) {
      return;
    }

    setState(() {
      _selectedImage = File(picked.path);
    });
  }

  void _pickImage() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Chọn ảnh"),
        actions: [
          ListTile(
            leading: Icon(Icons.image),
            onTap: _pickImageFromGallery,
            title: Text("Thư viện"),
          ),
          ListTile(
            leading: Icon(Icons.camera),
            onTap: _pickImageFromCamera,
            title: Text("Camera"),
          ),
          if (_selectedImage != null)
            ListTile(
              leading: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _selectedImage = null;
                });
              },
              title: Text("Xoá"),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final currentWeight = ref.watch(currentWeightProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cập nhật cân nặng",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.check, color: primaryColor, size: 32),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 32),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Cân nặng", style: TextStyle(fontSize: 16)),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Form(
                      key: _formKey,
                      child: TextFormField(
                        controller: _weightController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Ngày", style: TextStyle(fontSize: 16)),
                  TextButton(
                    onPressed: () async {
                      final selectedDate = await _selectDate();
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDate = selectedDate;
                        });
                      }
                    },
                    child: Text(
                      _formatDate(_selectedDate),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Ảnh", style: TextStyle(fontSize: 16)),
                  GestureDetector(
                    onTap: _pickImage,
                    child: _selectedImage == null
                        ? Icon(Icons.camera_alt_outlined)
                        : Image.file(
                            _selectedImage!,
                            width: 100,
                            height: 100,
                            alignment: Alignment.centerRight,
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
