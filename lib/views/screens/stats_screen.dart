import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/weight_record.dart' show Period;
import 'package:nutripal/viewmodels/weight_record_viewmodel.dart';
import 'package:nutripal/views/screens/weight_record_screen.dart';
import 'package:nutripal/views/widgets/weight_chart.dart';
import 'package:nutripal/views/widgets/weight_records.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  Period _selectingPeriod = Period.week;

  @override
  Widget build(BuildContext context) {
    final onPrimaryContainer = Theme.of(context).colorScheme.onPrimaryContainer;
    final primaryColor = Theme.of(context).primaryColor;

    final weightRecordsState = ref.watch(weightRecordViewModelProvider);
    final records = weightRecordsState.records;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Thống kê cân nặng",
          style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const WeightRecordScreen(),
              ),
            ),
            icon: Icon(Icons.add),
            color: primaryColor,
            iconSize: 30,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DropdownMenu<Period>(
                  enableSearch: false,
                  initialSelection: _selectingPeriod,
                  inputDecorationTheme: InputDecorationTheme(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.only(
                      left: 17,
                      top: 0,
                      right: 0,
                      bottom: 0,
                    ),
                  ),
                  textStyle: TextStyle(
                    color: onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  leadingIcon: Icon(
                    Icons.calendar_month,
                    color: onPrimaryContainer,
                  ),
                  trailingIcon: Icon(
                    Icons.keyboard_arrow_down,
                    color: onPrimaryContainer,
                    size: 20,
                  ),
                  selectedTrailingIcon: Icon(
                    Icons.keyboard_arrow_up,
                    color: onPrimaryContainer,
                    size: 20,
                  ),
                  onSelected: (Period? period) {
                    setState(() {
                      _selectingPeriod = period!;
                    });
                  },
                  dropdownMenuEntries: Period.values
                      .map(
                        (period) => DropdownMenuEntry(
                          value: period,
                          label: period.label,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
            WeightChart(period: _selectingPeriod),
            const SizedBox(height: 36),
            const WeightRecords(),
          ],
        ),
      ),
    );
  }
}
