// lib/services/reward_service.dart
import 'package:flutter/material.dart';
import 'package:shopzy/models/badge.dart' as model;
import 'package:shopzy/models/reward_activity.dart';

class RewardService {
  static final RewardService _instance = RewardService._internal();
  factory RewardService() => _instance;
  RewardService._internal();

  final ValueNotifier<int> totalPoints = ValueNotifier<int>(120);
  int lifetimePoints = 120;
  final List<RewardActivity> _activities = [
    RewardActivity(title: 'Welcome Bonus', points: 50, icon: Icons.celebration, date: DateTime.now().subtract(const Duration(days: 2))),
    RewardActivity(title: 'First Purchase', points: 70, icon: Icons.shopping_bag_outlined, date: DateTime.now().subtract(const Duration(days: 1))),
  ];
  final List<model.Badge> _badges = [
    model.Badge(name: 'First Scan', icon: Icons.qr_code_scanner, description: 'Scan your first item.', isUnlocked: true),
    model.Badge(name: 'Smart Shopper', icon: Icons.school_outlined, description: 'Buy a recommended item.'),
    model.Badge(name: 'Healthy Choice', icon: Icons.eco_outlined, description: 'Purchase 5 healthy items.'),
    model.Badge(name: 'Combo Master', icon: Icons.fastfood_outlined, description: 'Buy a promotional combo.'),
    model.Badge(name: 'Loyal Customer', icon: Icons.star_border, description: 'Make 5 purchases.'),
  ];

  List<RewardActivity> get activities => List.from(_activities.reversed);
  List<model.Badge> get badges => _badges;

  void addPoints(int points, String title, IconData icon) {
    totalPoints.value += points;
    lifetimePoints += points;
    _activities.add(RewardActivity(
      title: title,
      points: points,
      icon: icon,
      date: DateTime.now(),
    ));

    // Mock badge unlocking logic
    if (title.contains('Purchase') && !_badges[4].isUnlocked) {
      _badges[4].isUnlocked = true; // Unlock loyal customer
    }
  }

  bool redeemPoints(int points) {
    if (totalPoints.value >= points) {
      totalPoints.value -= points;
      _activities.add(RewardActivity(
        title: 'Redeemed Offer',
        points: -points,
        icon: Icons.card_giftcard,
        date: DateTime.now(),
      ));
      return true;
    }
    return false;
  }
}
