import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nutripal/models/water_record.dart';
import 'package:nutripal/viewmodels/diary_record_viewmodel.dart';
import 'package:nutripal/viewmodels/water_tracking_viewmodel.dart';
import 'package:nutripal/views/screens/add_water_screen.dart';

class WaterDiaryTile extends ConsumerStatefulWidget {
  const WaterDiaryTile({super.key});

  @override
  ConsumerState<WaterDiaryTile> createState() => _WaterDiaryTileState();
}

class _WaterDiaryTileState extends ConsumerState<WaterDiaryTile> {
  String _formatTime(TimeOfDay time) {
    final formatter = DateFormat.Hm();
    DateTime temp = DateTime.now();
    DateTime date = DateTime(
      temp.year,
      temp.month,
      temp.day,
      time.hour,
      time.minute,
    );

    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    final diaryTrackingState = ref.watch(diaryRecordViewModelProvider);
    final waterTrackingViewModel = ref.read(
      waterTrackingViewModelProvider.notifier,
    );
    final recordsByDate = diaryTrackingState.recordsByDate;
    final waterRecords = recordsByDate.waterRecords;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withValues(alpha: 0.4), width: 2),
        borderRadius: BorderRadius.circular(14),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: 3,
            ),
            child: Row(
              children: [
                Text(
                  "Nước",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Text(
                  "${recordsByDate.totalWaterAmount.toInt()}ml",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Divider(thickness: 1),

          waterRecords.isEmpty
              ? const SizedBox.shrink()
              : ListView.builder(
                  itemCount: waterRecords.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final WaterRecord record = waterRecords[index];
                    return Dismissible(
                      key: ObjectKey(record),
                      direction: DismissDirection.endToStart,
                      movementDuration: const Duration(milliseconds: 200),
                      resizeDuration: const Duration(milliseconds: 300),
                      dismissThresholds: const {
                        DismissDirection.endToStart: 0.25,
                      },
                      confirmDismiss: (direction) async {
                        return await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text("Xác nhận"),
                            content: Text(
                              "Bạn có muốn xóa lượng nước này?",
                              style: TextStyle(fontSize: 16),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () {
                                  waterTrackingViewModel.removeWaterRecord(
                                    index,
                                  );
                                  Navigator.of(context).pop(true);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text(
                                  "Xoá",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Huỷ"),
                              ),
                            ],
                          ),
                        );
                      },
                      background: Container(
                        width: 50,
                        color: Colors.red,
                        padding: const EdgeInsets.only(right: 14),
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.delete_outline, color: Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 3,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${record.amount}ml",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              _formatTime(record.consumedAt),
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

          waterRecords.isEmpty
              ? const SizedBox.shrink()
              : const Divider(thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddWaterScreen()),
                );
              },
              child: Text("Thêm", style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
