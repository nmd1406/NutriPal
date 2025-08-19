import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutripal/viewmodels/weight_record_viewmodel.dart';
import 'package:nutripal/views/screens/photo_screen.dart';
import 'package:nutripal/views/screens/weight_record_screen.dart';

class WeightRecords extends ConsumerWidget {
  const WeightRecords({super.key});

  void _showEditDialog(
    BuildContext context,
    int index,
    WeightRecordViewModel viewModel,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        WeightRecordScreen(recordIndex: index),
                  ),
                );
              },
              leading: const Icon(Icons.edit),
              title: Text("Thay đổi"),
            ),
            ListTile(
              onTap: () {
                viewModel.removeRecord(index);

                Navigator.of(context).pop();
              },
              leading: Icon(Icons.delete),
              title: Text("Xoá"),
            ),
          ],
        ),
      ),
    );
  }

  void _openImage(BuildContext context, File? image, String date) {
    if (image != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PhotoScreen(image: image, date: date),
        ),
      );
    }

    return;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final records = ref.watch(weightRecordViewModelProvider).records;
    final viewModel = ref.read(weightRecordViewModelProvider.notifier);

    return ListView.separated(
      shrinkWrap: true,
      itemCount: records.length,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final record = records[index];

        return ListTile(
          onTap: () {
            _openImage(context, record.image, record.formattedDate);
          },
          onLongPress: () {
            _showEditDialog(context, index, viewModel);
          },
          title: Text(
            record.formattedDate,
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text("${record.formattedWeight} kg"),
          trailing: record.image == null
              ? Icon(Icons.photo_outlined)
              : Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[200],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Image.file(record.image!, fit: BoxFit.cover),
                ),
        );
      },
      separatorBuilder: (_, _) =>
          Divider(height: 1, color: Colors.grey.shade200),
    );
  }
}
