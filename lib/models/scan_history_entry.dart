// lib/models/scan_history_entry.dart
import 'package:shopzy/models/grocery_item.dart';

class ScanHistoryEntry {
  final GroceryItem item;
  final DateTime timestamp;

  ScanHistoryEntry({
    required this.item,
    required this.timestamp,
  });
}
