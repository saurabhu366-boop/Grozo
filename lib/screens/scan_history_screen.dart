// lib/screens/scan_history_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopzy/models/scan_history_entry.dart';
import 'package:shopzy/services/scan_history_service.dart';
import 'package:shopzy/utils/app_colors.dart';

class ScanHistoryScreen extends StatefulWidget {
  const ScanHistoryScreen({super.key});

  @override
  State<ScanHistoryScreen> createState() => _ScanHistoryScreenState();
}

class _ScanHistoryScreenState extends State<ScanHistoryScreen> {
  final ScanHistoryService _scanHistoryService = ScanHistoryService();
  late List<ScanHistoryEntry> _history;

  @override
  void initState() {
    super.initState();
    _history = _scanHistoryService.history;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan History'),
        centerTitle: true,
      ),
      body: _history.isEmpty
          ? _buildEmptyState()
          : _buildHistoryList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_toggle_off_outlined,
            size: 80,
            color: AppColors.secondaryText.withOpacity(0.2),
          ),
          const SizedBox(height: 20),
          const Text(
            'No Scan History',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textCharcoal,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Your scanned items will appear here.',
            style: TextStyle(fontSize: 16, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length,
      itemBuilder: (context, index) {
        final entry = _history[index];
        final formattedDate = DateFormat('MMM d, yyyy – hh:mm a').format(entry.timestamp);

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.secondarySurface,
              child: Icon(Icons.qr_code_scanner_rounded, color: AppColors.primary),
            ),
            title: Text(
              entry.item.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textCharcoal,
              ),
            ),
            subtitle: Text(
              formattedDate,
              style: const TextStyle(color: AppColors.secondaryText),
            ),
            trailing: Text(
              '₹${entry.item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppColors.primary,
              ),
            ),
          ),
        );
      },
    );
  }
}