import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:nutripal/models/weight_record.dart';

class WeightTrackingFirestoreService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference get _collection {
    return _firestore
        .collection("weightRecords")
        .doc(_uid)
        .collection("records");
  }

  Future<File?> _compressImage(File imageFile) async {
    try {
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        imageFile.absolute.path,
        "${imageFile.parent.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg",
        quality: 86,
        minWidth: 600,
        minHeight: 600,
      );

      if (compressedFile == null) {
        throw Exception("Failed to compress image");
      }

      return File(compressedFile.path);
    } catch (e) {
      throw Exception("Image compression failed: ${e.toString()}");
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final compressedFile = await _compressImage(imageFile);

    if (compressedFile == null) {
      throw Exception("Failed to compress image");
    }

    String fileName = "${DateTime.now().millisecondsSinceEpoch}";
    final ref = _storage.ref().child("weight_images/$_uid/$fileName");
    final uploadTask = ref.putFile(compressedFile);

    final snapshot = await uploadTask;

    return await snapshot.ref.getDownloadURL();
  }

  Future<void> saveWeightRecord(WeightRecord record) async {
    String? imageUrl;
    if (record.image != null) {
      imageUrl = await _uploadImage(record.image!);
      record = record.copyWith(imageUrl: imageUrl);
    }

    _collection.add(record.toJson());
  }

  Future<List<WeightRecord>?> get weightRecords async {
    final querySnapshot = await _collection
        .orderBy("date", descending: true)
        .get();

    return querySnapshot.docs
        .map(
          (record) =>
              WeightRecord.fromJson(record.data() as Map<String, dynamic>),
        )
        .toList();
  }

  Future<void> removeWeightRecord(DateTime date) async {
    final querySnapshot = await _collection
        .where("date", isEqualTo: date.toIso8601String())
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.delete();
    }
  }

  Future<void> updateRecord(DateTime oldDate, WeightRecord newRecord) async {
    final querySnapshot = await _collection
        .where("date", isEqualTo: oldDate.toIso8601String())
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String? imageUrl;
      if (newRecord.image != null) {
        imageUrl = await _uploadImage(newRecord.image!);

        newRecord = newRecord.copyWith(imageUrl: imageUrl);
      }

      await querySnapshot.docs.first.reference.update(newRecord.toJson());
    }
  }
}
