import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../services/firebase_service.dart';

class HistoryScreen extends StatelessWidget {
  final String userId;

  HistoryScreen({required this.userId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Health History',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder<List<HealthRecord>>(
        stream: FirebaseService().getHealthRecords(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No records found.'));
          }

          final records = snapshot.data!;
          return ListView.builder(
            itemCount: records.length,
            padding: EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final record = records[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 6.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Heart Rate: ${record.heartRate} BPM',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Steps: ${record.steps}',
                      style: TextStyle(fontSize: 14.0),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Timestamp: ${record.timestamp}',
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
