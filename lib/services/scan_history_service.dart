// lib/services/scan_history_service.dart
import 'package:shopzy/models/grocery_item.dart';
import 'package:shopzy/models/scan_history_entry.dart';

class ScanHistoryService {
  // Singleton pattern
  static final ScanHistoryService _instance = ScanHistoryService._internal();
  factory ScanHistoryService() {
    return _instance;
  }
  ScanHistoryService._internal();

  final List<ScanHistoryEntry> _history = [];

  /// Returns a copy of the scan history, with the most recent scans first.
  List<ScanHistoryEntry> get history => List.from(_history.reversed);

  /// Adds a new scanned item to the history.
  void addScan(GroceryItem item) {
    final entry = ScanHistoryEntry(item: item, timestamp: DateTime.now());
    _history.add(entry);
  }
}
