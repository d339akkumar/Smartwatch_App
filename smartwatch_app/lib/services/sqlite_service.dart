import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_record.dart';

class SQLiteService {
  Database? _db;

  Future<void> init() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'health_records.db');
    _db = await openDatabase(path, version: 1, onCreate: (db, version) {
      return db.execute('''
        CREATE TABLE records(
          id TEXT PRIMARY KEY,
          heartRate INTEGER,
          steps INTEGER,
          timestamp TEXT
        )
      ''');
    });
  }

  Future<void> saveHealthRecord(HealthRecord record) async {
    await _db?.insert('records', {
      'id': record.id,
      'heartRate': record.heartRate,
      'steps': record.steps,
      'timestamp': record.timestamp.toIso8601String(),
    });
  }

  Future<List<HealthRecord>> getHealthRecords() async {
    final List<Map<String, dynamic>> maps = await _db!.query('records');
    return List.generate(maps.length, (i) {
      return HealthRecord(
        id: maps[i]['id'],
        heartRate: maps[i]['heartRate'],
        steps: maps[i]['steps'],
        timestamp: DateTime.parse(maps[i]['timestamp']),
      );
    });
  }
}
