import 'package:flutter/material.dart';

class FullScreenMenu extends StatelessWidget {
  final String currentPage;

  const FullScreenMenu({super.key, required this.currentPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Menu List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(32, 80, 32, 32),
                children: [
                  _buildMenuButton(
                    context: context,
                    icon: Icons.home_rounded,
                    title: 'Home',
                    page: 'home',
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context: context,
                    icon: Icons.info_rounded,
                    title: 'About Us',
                    page: 'about',
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context: context,
                    icon: Icons.privacy_tip_rounded,
                    title: 'Privacy Policy',
                    page: 'privacy',
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context: context,
                    icon: Icons.description_rounded,
                    title: 'Terms & Conditions',
                    page: 'terms',
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context: context,
                    icon: Icons.help_rounded,
                    title: 'FAQs',
                    page: 'faq',
                  ),
                  const SizedBox(height: 20),
                  _buildMenuButton(
                    context: context,
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    page: 'settings',
                  ),
                ],
              ),
            ),
            // Close Button at Bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Text(
                    'Close Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String page,
  }) {
    final isActive = currentPage == page;

    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, '/$page');
        } else {
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? Colors.transparent : Colors.white.withValues(alpha: 0.4),
            width: 2,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF6C63FF) : Colors.white,
              size: 28,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isActive ? const Color(0xFF6C63FF) : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
