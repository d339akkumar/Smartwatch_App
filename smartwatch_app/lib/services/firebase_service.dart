import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/health_record.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveHealthRecord(HealthRecord record, String userId) async {
    try {
      await _db
          .collection('users')
          .doc(userId)
          .collection('health_records')
          .add(record.toMap());
    } catch (e) {
      throw Exception('Failed to save health record: $e');
    }
  }

  Stream<List<HealthRecord>> getHealthRecords(String userId) {
    return _db
        .collection('users')
        .doc(userId)
        .collection('health_records')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return HealthRecord.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
