// lib/models/badge.dart
import 'package:flutter/material.dart';

class Badge {
  final String name;
  final IconData icon;
  final String description;
  bool isUnlocked;

  Badge({
    required this.name,
    required this.icon,
    required this.description,
    this.isUnlocked = false,
  });
}
