// lib/screens/account_section.dart
import 'package:flutter/material.dart';
import 'package:shopzy/screens/login_screen.dart';
import 'package:shopzy/screens/rewards_screen.dart';
import 'package:shopzy/screens/scan_history_screen.dart';
import 'package:shopzy/utils/app_colors.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.secondarySurface,
        title: const Text('Confirm Log Out', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textCharcoal)),
        content: const Text('Are you sure you want to log out?', style: TextStyle(color: AppColors.secondaryText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel', style: TextStyle(color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close the dialog
              // Navigate to login screen and remove all previous routes
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (Route<dynamic> route) => false,
              );
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 120),
        children: [
          _buildProfileHeader(),
          const SizedBox(height: 30),
          _buildPremiumCard(),
          const SizedBox(height: 10),
          _buildOptionTile(
            context,
            icon: Icons.star_outline_rounded,
            title: 'My Rewards',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const RewardsScreen()));
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.history_rounded,
            title: 'Scan History',
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ScanHistoryScreen())
              );
            },
          ),
          _buildOptionTile(
            context,
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: () {},
          ),
          _buildOptionTile(
            context,
            icon: Icons.notifications_outlined,
            title: 'Notifications',
            onTap: () {},
          ),
          const Divider(indent: 24, endIndent: 24, height: 32),
          _buildOptionTile(
            context,
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 50,
          backgroundColor: AppColors.secondarySurface,
          backgroundImage:
          NetworkImage('https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
        ),
        const SizedBox(height: 16),
        const Text(
          'Sahil',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textCharcoal,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'sahil.user@example.com',
          style: TextStyle(
            fontSize: 16,
            color: AppColors.secondaryText,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accentBlack,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.highlight, size: 32),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Member',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textOnBlack,
                      fontSize: 16
                  ),
                ),
                Text(
                  'Unlock exclusive deals & free delivery',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, color: AppColors.secondaryText, size: 16),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required VoidCallback onTap,
      }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textCharcoal,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.secondaryText,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.logout_rounded, color: Colors.red),
        title: const Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.red,
          ),
        ),
        onTap: () => _showLogoutConfirmationDialog(context),
      ),
    );
  }
}