import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/views/widgets/calories_tab.dart';
import 'package:nutripal/views/widgets/date_selector.dart';
import 'package:nutripal/views/widgets/macros_tab.dart';

class NutritionScreen extends ConsumerStatefulWidget {
  const NutritionScreen({super.key});

  @override
  ConsumerState<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends ConsumerState<NutritionScreen>
    with TickerProviderStateMixin {
  late DateTime _selectedDate;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _selectedDate = ref.read(diaryRecordViewModelProvider).selectedDate;
  }

  void _previousDay() {
    setState(() {
      _selectedDate = _selectedDate.subtract(const Duration(days: 1));
    });
    ref.watch(diaryRecordViewModelProvider.notifier).changeDate(_selectedDate);
  }

  void _nextDay() {
    setState(() {
      _selectedDate = _selectedDate.add(const Duration(days: 1));
    });
    ref.watch(diaryRecordViewModelProvider.notifier).changeDate(_selectedDate);
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
      ref
          .watch(diaryRecordViewModelProvider.notifier)
          .changeDate(_selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Dinh dưỡng",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const <Tab>[
            Tab(text: "Calories"),
            Tab(text: "Macros"),
          ],
        ),
      ),
      body: Column(
        children: [
          DateSelector(
            selectedDate: _selectedDate,
            onPreviousDay: _previousDay,
            onNextDay: _nextDay,
            onDateTap: _selectDate,
          ),
          const SizedBox(height: 14),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [const CaloriesTab(), const MacrosTab()],
            ),
          ),
        ],
      ),
    );
  }
}
