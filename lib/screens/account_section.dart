// lib/screens/account_section.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopzy/providers/auth_provider.dart';
import 'package:shopzy/screens/edit_profile_screen.dart';
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
        backgroundColor: Colors.white,
        title: const Text('Log Out?',
            style: TextStyle(
                fontWeight: FontWeight.w800, color: AppColors.textCharcoal)),
        content: const Text('Are you sure you want to log out of Grozo?',
            style: TextStyle(color: AppColors.secondaryText)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('Cancel',
                style: TextStyle(
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              // ✅ FIX: call AuthProvider.logout() to clear token from storage
              await context.read<AuthProvider>().logout();
              if (!context.mounted) return;
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
            child: const Text('Log Out',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ FIX: Read real user data from AuthProvider instead of hardcoded values
    final auth = context.watch<AuthProvider>();
    final name = auth.fullName ?? 'User';
    final email = auth.email ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F2),
      body: CustomScrollView(
        slivers: [
          // ── Collapsible header ──────────────────────────────
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(32),
                    bottomRight: Radius.circular(32),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 48),
                    // ✨ Avatar with green ring
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.4),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 44,
                            backgroundColor:
                            AppColors.primary.withOpacity(0.1),
                            backgroundImage: const NetworkImage(
                                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=300'),
                            child: const NetworkImage(
                                'https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&w=300') ==
                                null
                                ? Text(initials,
                                style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary))
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              width: 14,
                              height: 14,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textCharcoal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      style: TextStyle(
                          fontSize: 13, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ),
            title: const Text('My Profile',
                style: TextStyle(
                    color: AppColors.textCharcoal,
                    fontWeight: FontWeight.w800,
                    fontSize: 17)),
            centerTitle: true,
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                children: [
                  // ── Stats row ─────────────────────────────────
                  Row(
                    children: [
                      _StatCard(label: 'Orders', value: '12'),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Rewards', value: '840 pts'),
                      const SizedBox(width: 12),
                      _StatCard(label: 'Saved', value: '₹320'),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Premium card ──────────────────────────────
                  _buildPremiumCard(),

                  const SizedBox(height: 20),

                  // ── Options group 1 ───────────────────────────
                  _SectionCard(
                    children: [
                      _OptionTile(
                        icon: Icons.star_outline_rounded,
                        iconColor: const Color(0xFFFF9800),
                        title: 'My Rewards',
                        subtitle: '840 points available',
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const RewardsScreen())),
                      ),
                      _Divider(),
                      _OptionTile(
                        icon: Icons.history_rounded,
                        iconColor: AppColors.primary,
                        title: 'Scan History',
                        subtitle: 'View past scans',
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const ScanHistoryScreen())),
                      ),
                      _Divider(),
                      _OptionTile(
                        icon: Icons.edit_outlined,
                        iconColor: const Color(0xFF5C6BC0),
                        title: 'Edit Profile',
                        subtitle: 'Update your details',
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const EditProfileScreen())),
                      ),
                      _Divider(),
                      _OptionTile(
                        icon: Icons.notifications_outlined,
                        iconColor: const Color(0xFFEF5350),
                        title: 'Notifications',
                        subtitle: 'Manage alerts',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Options group 2 ───────────────────────────
                  _SectionCard(
                    children: [
                      _OptionTile(
                        icon: Icons.help_outline,
                        iconColor: AppColors.secondaryText,
                        title: 'Help & Support',
                        subtitle: 'FAQs & contact us',
                        onTap: () {},
                      ),
                      _Divider(),
                      _OptionTile(
                        icon: Icons.logout_rounded,
                        iconColor: Colors.red,
                        title: 'Log Out',
                        subtitle: 'Sign out of your account',
                        titleColor: Colors.red,
                        onTap: () => _showLogoutConfirmationDialog(context),
                        showArrow: false,
                      ),
                    ],
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: const Color(0xFFFF9800).withOpacity(0.4), width: 1),
            ),
            child: const Icon(Icons.shield_outlined,
                color: Color(0xFFFF9800), size: 26),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premium Member',
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 15,
                        letterSpacing: -0.3)),
                SizedBox(height: 3),
                Text('Exclusive deals & free delivery',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white70, size: 14),
          ),
        ],
      ),
    );
  }
}

// ── Stat card ─────────────────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                    letterSpacing: -0.5)),
            const SizedBox(height: 3),
            Text(label,
                style: TextStyle(
                    fontSize: 11,
                    color: AppColors.secondaryText,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}

// ── Section card container ─────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final List<Widget> children;
  const _SectionCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }
}

// ── Option tile ───────────────────────────────────────────────────────────────
class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? titleColor;
  final bool showArrow;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.titleColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(icon, color: iconColor, size: 21),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: titleColor ?? AppColors.textCharcoal)),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12, color: AppColors.secondaryText)),
                ],
              ),
            ),
            if (showArrow)
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.secondaryText),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 72,
      endIndent: 16,
      color: Colors.grey.shade100,
    );
  }
}