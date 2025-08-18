import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutripal/models/diary_record.dart';

class DiaryFirestoreService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference get _diaryCollection {
    if (_uid == null) {
      throw Exception("User not authenticated");
    }
    return _firestore.collection("diary").doc(_uid).collection("records");
  }

  Future<void> saveDiaryRecord(DiaryRecord diaryRecord) async {
    final dateString = diaryRecord.date.toIso8601String().split("T")[0];
    await _diaryCollection.doc(dateString).set(diaryRecord.toJson());
  }

  Future<DiaryRecord?> getDiaryRecord(DateTime date) async {
    final dateString = date.toIso8601String().split("T")[0];
    final doc = await _diaryCollection.doc(dateString).get();

    if (doc.exists) {
      return DiaryRecord.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }
}
