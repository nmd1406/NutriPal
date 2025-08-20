import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/models/weight_record.dart';
import 'package:nutripal/viewmodels/weight_record_viewmodel.dart';

class WeightChart extends ConsumerWidget {
  final Period period;

  const WeightChart({super.key, required this.period});

  String _formattedWeight(double weight) {
    if (weight == weight.roundToDouble()) {
      return weight.toStringAsFixed(0);
    }
    return weight.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).colorScheme.secondary;

    final filteredRecords = ref.watch(filteredWeightRecordsProvider(period));
    final chartStats = ref.watch(weightChartStatsProvider(period));

    if (filteredRecords.isEmpty) {
      return _buildEmptyChart(context);
    }

    if (filteredRecords.length < 2) {
      return _buildSingleRecordChart(filteredRecords.first, primaryColor);
    }

    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: LineChart(
              _buildLineChartData(filteredRecords, chartStats, primaryColor),
            ),
          ),
          _buildSummaryStats(filteredRecords),
        ],
      ),
    );
  }

  Widget _buildSingleRecordChart(WeightRecord record, Color primaryColor) {
    return SizedBox(
      height: 350,
      child: Column(
        children: [
          Expanded(
            child: LineChart(_buildSingleLineChartData(record, primaryColor)),
          ),
        ],
      ),
    );
  }

  LineChartData _buildSingleLineChartData(WeightRecord record, Color color) {
    final weight = record.weight;
    const padding = 10.0;

    return LineChartData(
      minX: -1,
      maxX: 1,
      minY: weight - padding,
      maxY: weight + padding,
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: 5,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withValues(alpha: 0.3), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, _) {
              if (value == 0) {
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    record.formatDateForChart(period),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const Text("");
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 5,
            getTitlesWidget: (double value, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  _formattedWeight(value),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 2.1),
          left: BorderSide(color: Colors.grey, width: 2.1),
        ),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) => touchedSpots.map((barSpot) {
            return LineTooltipItem(
              record.formattedWeight,
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: [FlSpot(-1, weight), FlSpot(0, weight), FlSpot(1, weight)],
          isCurved: false,
          barWidth: 4,
          isStrokeCapRound: true,
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.6),
              color.withValues(alpha: 0.7),
              color,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          dotData: FlDotData(
            show: true,
            checkToShowDot: (spot, barData) =>
                spot.x == 0, // Chỉ hiển thị dot ở giữa
            getDotPainter: (spot, percent, barData, index) =>
                FlDotCirclePainter(
                  radius: 6,
                  color: color,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                ),
          ),
        ),
      ],
    );
  }

  LineChartData _buildLineChartData(
    List<WeightRecord> records,
    Map<String, dynamic> stats,
    Color color,
  ) {
    final spots = records.asMap().entries.map((entry) {
      final index = entry.key;
      final record = entry.value;

      return FlSpot(index.toDouble(), record.weight);
    }).toList();

    final minWeight = stats["minWeight"] as double;
    final maxWeight = stats["maxWeight"] as double;
    final padding = 5.0;

    return LineChartData(
      minX: 0,
      maxX: records.length - 1,
      minY: minWeight - padding,
      maxY: maxWeight + padding,
      gridData: FlGridData(
        drawVerticalLine: false,
        horizontalInterval: records.length > 10 ? 5 : 4,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.grey.withValues(alpha: 0.3), strokeWidth: 1),
      ),
      titlesData: FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: records.length > 10 ? 4 : 1,
            getTitlesWidget: (value, _) {
              if (value.toInt() >= 0 && value.toInt() < records.length) {
                final record = records[value.toInt()];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    record.formatDateForChart(period),
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const Text("");
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: records.length > 10 ? 5 : 4,
            getTitlesWidget: (double weight, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  _formattedWeight(weight),
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 2.1),
          left: BorderSide(color: Colors.grey, width: 2.1),
        ),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) => touchedSpots.map((barSpot) {
            if (barSpot.x.toInt() >= 0 && barSpot.x.toInt() < records.length) {
              final record = records[barSpot.x.toInt()];
              return LineTooltipItem(
                record.formattedWeight,
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              );
            }
          }).toList(),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          preventCurveOverShooting: true,
          barWidth: 4,
          isStrokeCapRound: true,
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.6),
              color.withValues(alpha: 0.7),
              color,
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          spots: spots,
          dotData: FlDotData(checkToShowDot: (spot, barData) => true),
        ),
      ],
    );
  }

  Widget _buildSummaryStats(List<WeightRecord> records) {
    if (records.length < 2) return const SizedBox();

    final firstRecord = records.first;
    final lastRecord = records.last;
    final weightChange = lastRecord.weight - firstRecord.weight;
    final isGain = weightChange > 0;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isGain
            ? Colors.red.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                '${firstRecord.formattedWeight} kg',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Đầu kỳ', style: TextStyle(fontSize: 12)),
            ],
          ),
          Icon(
            isGain ? Icons.trending_up : Icons.trending_down,
            color: isGain ? Colors.red : Colors.green,
          ),
          Column(
            children: [
              Text(
                '${lastRecord.formattedWeight} kg',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Text('Cuối kỳ', style: TextStyle(fontSize: 12)),
            ],
          ),
          Column(
            children: [
              Text(
                '${isGain ? '+' : ''}${weightChange.toStringAsFixed(1)} kg',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isGain ? Colors.red : Colors.green,
                ),
              ),
              const Text('Thay đổi', style: TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChart(BuildContext context) {
    return SizedBox(
      height: 300,
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
