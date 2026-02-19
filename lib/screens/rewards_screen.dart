// lib/screens/rewards_screen.dart
import 'package:flutter/material.dart';
import 'package:shopzy/services/reward_service.dart';
import 'package:shopzy/utils/app_colors.dart';
import 'package:shopzy/widgets/badge_widget.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final RewardService _rewardService = RewardService();
  final int _nextRewardTier = 200;

  void _showRedeemConfirmation(String title, int requiredPoints) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.secondarySurface,
        title: const Text('Confirm Redemption', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textCharcoal)),
        content: Text('Spend $requiredPoints points to get "$title"?', style: const TextStyle(color: AppColors.secondaryText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              final success = _rewardService.redeemPoints(requiredPoints);
              if (success && mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('"$title" has been redeemed!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              }
            },
            child: const Text('Redeem', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: _rewardService.totalPoints,
        builder: (context, points, child) {
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildPointsCard(points),
              const SizedBox(height: 32),
              _buildSectionTitle('Redeemable Benefits'),
              _buildRedeemCard(
                  'Get ₹50 Off Your Next Purchase', 200, points),
              _buildRedeemCard(
                  'Free Coffee Voucher', 350, points),
              const SizedBox(height: 24),
              _buildSectionTitle('Badges'),
              _buildBadgesGrid(),
              const SizedBox(height: 24),
              _buildSectionTitle('Recent Activity'),
              _buildActivityList(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textCharcoal,
        ),
      ),
    );
  }

  Widget _buildPointsCard(int points) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accentBlack,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Available Points',
            style: TextStyle(color: AppColors.secondaryText, fontSize: 16),
          ),
          Text(
            '$points',
            style: const TextStyle(
                color: AppColors.textOnBlack, fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          AnimatedPointsProgressBar(points: points, goal: _nextRewardTier),
        ],
      ),
    );
  }

  Widget _buildRedeemCard(String title, int requiredPoints, int currentPoints) {
    bool canRedeem = currentPoints >= requiredPoints;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            const Icon(Icons.card_giftcard, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textCharcoal)),
                  Text('$requiredPoints Points', style: const TextStyle(color: AppColors.secondaryText)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: canRedeem ? () => _showRedeemConfirmation(title, requiredPoints) : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                backgroundColor: canRedeem ? AppColors.primary : AppColors.secondarySurface,
                foregroundColor: canRedeem ? Colors.white : AppColors.secondaryText,
                disabledBackgroundColor: AppColors.secondaryText.withOpacity(0.1),
                disabledForegroundColor: AppColors.secondaryText.withOpacity(0.5),
              ),
              child: const Text('Redeem'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBadgesGrid() {
    final badges = _rewardService.badges;
    return Card(
      color: AppColors.secondarySurface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            mainAxisExtent: 120,
          ),
          itemCount: badges.length,
          itemBuilder: (context, index) {
            return BadgeWidget(badge: badges[index]);
          },
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    final activities = _rewardService.activities;
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        bool isCredit = activity.points > 0;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.secondarySurface,
          child: ListTile(
            leading: Icon(activity.icon, color: isCredit ? AppColors.primary : AppColors.secondaryText),
            title: Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textCharcoal)),
            trailing: Text(
              '${isCredit ? '+' : ''}${activity.points}',
              style: TextStyle(
                color: isCredit ? AppColors.primary : AppColors.secondaryText,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedPointsProgressBar extends StatelessWidget {
  final int points;
  final int goal;

  const AnimatedPointsProgressBar({
    super.key,
    required this.points,
    required this.goal,
  });

  @override
  Widget build(BuildContext context) {
    final double progress = (points / goal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: progress),
          duration: const Duration(milliseconds: 1000),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Container(
              height: 12,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white.withOpacity(0.1),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.transparent,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 8),
        Text(
          '$points / $goal to next reward',
          style: const TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}