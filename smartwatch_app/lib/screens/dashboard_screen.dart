import 'package:flutter/material.dart';
import '../models/health_record.dart';
import '../services/bluetooth_service.dart' as bluetooth_service;
import '../services/firebase_service.dart' as firebase_service;

class DashboardScreen extends StatefulWidget {
  final String userId;

  DashboardScreen({required this.userId});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final firebase_service.FirebaseService _firebaseService =
      firebase_service.FirebaseService();
  final bluetooth_service.BluetoothService _bluetoothService =
      bluetooth_service.BluetoothService();

  Stream<int> _heartRateStream = Stream.empty();
  Stream<int> _stepCountStream = Stream.empty();

  @override
  void initState() {
    super.initState();
    _heartRateStream = _bluetoothService.getHeartRateStream();
    _stepCountStream = _bluetoothService.getStepCountStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCardWithBorder(
              title: 'Heart Rate',
              valueStream: _heartRateStream,
              unit: 'BPM',
            ),
            SizedBox(height: 16.0),
            _buildCardWithBorder(
              title: 'Steps',
              valueStream: _stepCountStream,
              unit: '',
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () async {
                final healthRecord = HealthRecord(
                  id: DateTime.now().toString(),
                  heartRate: 75,
                  steps: 100,
                  timestamp: DateTime.now(),
                );
                await _firebaseService.saveHealthRecord(
                    healthRecord, widget.userId);
              },
              child: Text(
                'Save Data',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardWithBorder({
    required String title,
    required Stream<int> valueStream,
    required String unit,
  }) {
    return StreamBuilder<int>(
      stream: valueStream,
      builder: (context, snapshot) {
        final value = snapshot.data ?? 0;
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 8.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$title:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              Text(
                '$value $unit',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
