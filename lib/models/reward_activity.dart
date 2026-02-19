// lib/models/reward_activity.dart
import 'package:flutter/material.dart';

class RewardActivity {
  final String title;
  final int points;
  final IconData icon;
  final DateTime date;

  RewardActivity({
    required this.title,
    required this.points,
    required this.icon,
    required this.date,
  });
}
