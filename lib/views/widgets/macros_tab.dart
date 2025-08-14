import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/viewmodels/profile_viewmodel.dart';

class MacrosTab extends ConsumerStatefulWidget {
  const MacrosTab({super.key});

  @override
  ConsumerState<MacrosTab> createState() => _MacrosTabState();
}

class _MacrosTabState extends ConsumerState<MacrosTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  String _formatPercentage(double value) {
    if (value.isNaN || value.isInfinite || value.isNegative) {
      return "0%";
    }

    return "${(value * 100).round()}%";
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    const double chartRadius = 90;

    final targetMacros = ref.watch(targetMacrosProvider);
    final diaryTrackingState = ref.watch(diaryRecordViewModelProvider);
    final recordsByDate = diaryTrackingState.recordsByDate;
    final carbsPercentage = recordsByDate.totalDailyCarbsPercentage.isNaN
        ? 0.0
        : recordsByDate.totalDailyCarbsPercentage;
    final fatPercentage = recordsByDate.totalDailyFatPercentage.isNaN
        ? 0.0
        : recordsByDate.totalDailyFatPercentage;
    final proteinPercentage = recordsByDate.totalDailyProteinPercentage.isNaN
        ? 0.0
        : recordsByDate.totalDailyProteinPercentage;

    final carbsColor = const Color.fromARGB(255, 44, 127, 47);
    final fatColor = Colors.deepPurple;
    final proteinColor = Colors.amber;

    final textStyle = TextStyle(
      color: Theme.of(context).primaryColor,
      fontWeight: FontWeight.bold,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 1),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          recordsByDate.isMealRecordsEmpty
              ? const SizedBox(height: 10)
              : const SizedBox.shrink(),
          const SizedBox(height: 45),
          recordsByDate.isMealRecordsEmpty
              ? Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    shape: BoxShape.circle,
                  ),
                )
              : FittedBox(
                  fit: BoxFit.contain,
                  child: SizedBox(
                    height: 200,
                    width: 200,
                    child: PieChart(
                      duration: Duration.zero,
                      curve: Curves.linear,
                      PieChartData(
                        startDegreeOffset: 0,
                        centerSpaceRadius: 0,
                        sections: [
                          _sectionData(
                            carbsPercentage,
                            chartRadius,
                            carbsColor,
                          ),
                          _sectionData(fatPercentage, chartRadius, fatColor),
                          _sectionData(
                            proteinPercentage,
                            chartRadius,
                            proteinColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
          const SizedBox(height: 62),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: <int, TableColumnWidth>{
                0: FlexColumnWidth(6),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
              },
              children: <TableRow>[
                const TableRow(
                  children: [SizedBox.shrink(), Text("Tổng"), Text("Mục tiêu")],
                ),
                _spacingRow(),

                TableRow(
                  children: [
                    _buildMacroLegend(
                      "Carbs",
                      recordsByDate.totalDailyCarbs,
                      carbsColor,
                    ),
                    Text(_formatPercentage(carbsPercentage)),
                    Text("${targetMacros["carb"]!.round()}%", style: textStyle),
                  ],
                ),
                _spacingRow(),
                TableRow(
                  children: [
                    _buildMacroLegend(
                      "Fat",
                      recordsByDate.totalDailyFat,
                      fatColor,
                    ),
                    Text(_formatPercentage(fatPercentage)),
                    Text("${targetMacros["fat"]!.round()}%", style: textStyle),
                  ],
                ),
                _spacingRow(),
                TableRow(
                  children: [
                    _buildMacroLegend(
                      "Protein",
                      recordsByDate.totalDailyProtein,
                      proteinColor,
                    ),
                    Text(_formatPercentage(proteinPercentage)),
                    Text(
                      "${targetMacros["protein"]!.round()}%",
                      style: textStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TableRow _spacingRow() => const TableRow(
    children: [
      SizedBox(height: 10),
      SizedBox(height: 10),
      SizedBox(height: 10),
    ],
  );

  PieChartSectionData _sectionData(double value, double radius, Color color) =>
      PieChartSectionData(
        value: value,
        radius: radius,
        color: color,
        title: _formatPercentage(value),
        titlePositionPercentageOffset: 0.55,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );

  Widget _buildMacroLegend(String name, double value, Color color) => Row(
    children: [
      Container(height: 20, width: 20, color: color),
      const SizedBox(width: 10),
      Text("$name (${value.round()}g)"),
    ],
  );
}
