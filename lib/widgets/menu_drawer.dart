import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final String currentPage;

  const MenuDrawer({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6C63FF).withOpacity(0.1),
              const Color(0xFFFF6584).withOpacity(0.1),
            ],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // Header with logo/title
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Color(0xFF6C63FF),
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'TinyMinds',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Learn & Play',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // Menu Items
            const SizedBox(height: 8),

            // Home
            _buildMenuItemDivider(
              context: context,
              icon: Icons.home_rounded,
              title: 'Home',
              isActive: currentPage == 'home',
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'home') {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                }
              },
            ),

            // Privacy Policy
            _buildMenuItem(
              context: context,
              icon: Icons.privacy_tip_rounded,
              title: 'Privacy Policy',
              isActive: currentPage == 'privacy',
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'privacy') {
                  Navigator.pushNamed(context, '/privacy');
                }
              },
            ),

            // Terms and Conditions
            _buildMenuItem(
              context: context,
              icon: Icons.description_rounded,
              title: 'Terms & Conditions',
              isActive: currentPage == 'terms',
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'terms') {
                  Navigator.pushNamed(context, '/terms');
                }
              },
            ),

            // FAQ
            _buildMenuItem(
              context: context,
              icon: Icons.help_rounded,
              title: 'FAQ',
              isActive: currentPage == 'faq',
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'faq') {
                  Navigator.pushNamed(context, '/faq');
                }
              },
            ),

            // Settings
            _buildMenuItemDivider(
              context: context,
              icon: Icons.settings_rounded,
              title: 'Settings',
              isActive: currentPage == 'settings',
              onTap: () {
                Navigator.pop(context);
                if (currentPage != 'settings') {
                  Navigator.pushNamed(context, '/settings');
                }
              },
            ),

            const Spacer(),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  const SizedBox(height: 12),
                  Text(
                    '© 2026 TinyMinds\nAll Rights Reserved',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF6C63FF).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? const Color(0xFF6C63FF) : Colors.grey[700],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            color: isActive ? const Color(0xFF6C63FF) : Colors.black87,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMenuItemDivider({
    required BuildContext context,
    required IconData icon,
    required String title,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        _buildMenuItem(
          context: context,
          icon: icon,
          title: title,
          isActive: isActive,
          onTap: onTap,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Divider(color: Colors.grey.withOpacity(0.2)),
        ),
      ],
    );
  }
}
