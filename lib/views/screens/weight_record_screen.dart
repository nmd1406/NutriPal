import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/weight_record.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';
import 'package:nutripal/viewmodels/weight_record_viewmodel.dart';

class WeightRecordScreen extends ConsumerStatefulWidget {
  final int? recordIndex;

  const WeightRecordScreen({super.key, this.recordIndex});

  @override
  ConsumerState<WeightRecordScreen> createState() => _WeightRecordScreenState();
}

class _WeightRecordScreenState extends ConsumerState<WeightRecordScreen> {
  late TextEditingController _weightController;
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  bool get _isEditMode => widget.recordIndex != null;

  WeightRecord? get _existingRecord {
    if (!_isEditMode) {
      return null;
    }

    return ref
        .read(weightRecordViewModelProvider.notifier)
        .getRecord(widget.recordIndex!);
  }

  void _initializeData() {
    if (_isEditMode && _existingRecord != null) {
      final WeightRecord record = _existingRecord!;
      _weightController = TextEditingController(
        text: _formatDouble(record.weight),
      );
      _selectedDate = record.date;
      _selectedImage = record.image;
    } else {
      final currentWeight = ref.read(currentWeightProvider);
      _weightController = TextEditingController(
        text: _formatDouble(currentWeight),
      );
    }
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
    final image = await ref
        .watch(weightRecordViewModelProvider.notifier)
        .pickImageFromGallery();

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
    });
  }

  Future<void> _pickImageFromCamera() async {
    final image = await ref
        .watch(weightRecordViewModelProvider.notifier)
        .pickImageFromCamera();

    if (image == null) {
      return;
    }

    setState(() {
      _selectedImage = image;
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

  void _saveRecord() {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      double weight = double.parse(_weightController.text);

      if (_isEditMode) {
        ref
            .read(weightRecordViewModelProvider.notifier)
            .updateRecord(
              widget.recordIndex!,
              weight,
              _selectedDate,
              _selectedImage,
            );
      } else {
        ref
            .read(weightRecordViewModelProvider.notifier)
            .addRecord(weight, _selectedDate, _selectedImage);
      }

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã lưu"), duration: Duration(seconds: 1)),
      );

      if (!_isEditMode) {
        Navigator.of(context).pop();
      }
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    final weightRecordViewModel = ref.read(
      weightRecordViewModelProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Cập nhật cân nặng",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _saveRecord,
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
                        validator: weightRecordViewModel.validateWeight,
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
                        : Container(
                            height: 70,
                            width: 70,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[200],
                            ),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                            ),
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
