import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/weight_record.dart';
import 'package:nutripal/viewmodels/weight_record_viewmodel.dart';

class WeightChart extends ConsumerWidget {
  final Period period;

  const WeightChart({super.key, required this.period});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredRecords = ref.watch(filteredWeightRecordsProvider(period));
    final chartStats = ref.watch(weightChartStatsProvider(period));

    if (filteredRecords.isEmpty) {
      return _buildEmptyChart(context);
    }

    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            child: LineChart(_buildLineChartData(filteredRecords, chartStats)),
          ),
        ],
      ),
    );
  }

  LineChartData _buildLineChartData(
    List<WeightRecord> records,
    Map<String, dynamic> stats,
  ) {
    return LineChartData();
  }

  Widget _buildEmptyChart(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .1),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.analytics_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "Chưa có dữ liệu",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Thêm bản ghi cân nặng để xem biểu đồ",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
