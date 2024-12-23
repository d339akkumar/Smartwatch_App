import 'package:cloud_firestore/cloud_firestore.dart'; // Import this line

class HealthRecord {
  final String id;
  final int heartRate;
  final int steps;
  final DateTime timestamp;

  HealthRecord({
    required this.id,
    required this.heartRate,
    required this.steps,
    required this.timestamp,
  });

  // Convert a HealthRecord object into a Map object for Firestore
  Map<String, dynamic> toMap() {
    return {
      'heartRate': heartRate,
      'steps': steps,
      'timestamp': Timestamp.fromDate(timestamp), // Save as Firestore Timestamp
    };
  }

  // Create a HealthRecord object from a Firestore document
  factory HealthRecord.fromMap(Map<String, dynamic> map) {
    return HealthRecord(
      id: map['id'],
      heartRate: map['heartRate'],
      steps: map['steps'],
      timestamp: (map['timestamp'] as Timestamp)
          .toDate(), // Convert Firestore Timestamp to DateTime
    );
  }
}
