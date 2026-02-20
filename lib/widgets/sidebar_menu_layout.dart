import 'package:flutter/material.dart';
import '../screens/about_us_screen.dart';
import '../screens/faq_screen.dart';
import '../screens/settings_screen.dart';

class SidebarMenuLayout extends StatefulWidget {
  final Widget? initialContent;
  final String? initialPage;

  const SidebarMenuLayout({
    super.key,
    this.initialContent,
    this.initialPage = 'about',
  });

  @override
  State<SidebarMenuLayout> createState() => _SidebarMenuLayoutState();
}

class _SidebarMenuLayoutState extends State<SidebarMenuLayout> {
  late String _currentPage;
  late Widget _currentContent;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage ?? 'about';
    _currentContent = widget.initialContent ?? const AboutUsScreen(showHeader: false);
  }

  void _navigateTo(String page) {
    setState(() {
      _currentPage = page;
      switch (page) {
        case 'home':
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          break;
        case 'about':
          _currentContent = const AboutUsScreen(showHeader: false);
          break;
        case 'privacy':
          _currentContent = const PrivacyPolicySidebarContent();
          break;
        case 'terms':
          _currentContent = const TermsAndConditionsSidebarContent();
          break;
        case 'faq':
          _currentContent = const FAQSidebarContent();
          break;
        case 'settings':
          _currentContent = const SettingsSidebarContent();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Sidebar
          Container(
            width: 200,
            color: const Color(0xFF2563EB),
            child: Column(
              children: [
                // Back Button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_back, color: Colors.white, size: 24),
                        const SizedBox(width: 12),
                        const Text(
                          'Back',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(color: Colors.white.withValues(alpha: 0.2)),

                // Menu Items
                _buildMenuItem(
                  icon: Icons.home,
                  title: 'Home',
                  page: 'home',
                ),
                _buildMenuItem(
                  icon: Icons.star,
                  title: 'About Us',
                  page: 'about',
                  isActive: _currentPage == 'about',
                ),
                _buildMenuItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  page: 'settings',
                  isActive: _currentPage == 'settings',
                ),
                _buildMenuItem(
                  icon: Icons.mail,
                  title: 'FAQ',
                  page: 'faq',
                  isActive: _currentPage == 'faq',
                ),
              ],
            ),
          ),

          // Right Content Area
          Expanded(
            child: _currentContent,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String page,
    bool isActive = false,
  }) {
    return Container(
      color: isActive ? const Color(0xFF1E40AF) : Colors.transparent,
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Rounded',
          ),
        ),
        onTap: () => _navigateTo(page),
      ),
    );
  }
}

// Sidebar content versions (without app bar)
class PrivacyPolicySidebarContent extends StatelessWidget {
  const PrivacyPolicySidebarContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left half - Privacy Policy
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Rounded',
                  ),
                ),
                const SizedBox(height: 12),
                _buildPrivacySection(
                  title: 'Information We Collect',
                  content:
                      'We design our kids game to be safe and minimal data collecting.\n\n'
                      'Non-Personal Information:\n'
                      '• Device type\n'
                      '• Android version\n'
                      '• Country (approx location)\n'
                      '• App usage (game screens used)\n\n'
                      'This helps improve performance and gameplay.',
                ),
                _buildPrivacySection(
                  title: 'Children\'s Privacy',
                  content:
                      '• Our app is designed for children under 13.\n'
                      '• We do not knowingly collect personal data from children.\n'
                      '• If a parent believes their child provided personal data, contact us and we will delete it immediately.',
                ),
                _buildPrivacySection(
                  title: 'How We Use Information',
                  content:
                      'We use collected data to:\n'
                      '• Improve game performance\n'
                      '• Fix bugs\n'
                      '• Show ads (to keep game free)\n'
                      '• Enhance user experience',
                ),
                _buildPrivacySection(
                  title: 'Contact Us',
                  content:
                      'Company: CAPFEX\n'
                      'Email: capfexinfotech@gmail.com',
                ),
              ],
            ),
          ),
        ),
        // Divider
        Container(
          width: 1,
          color: Colors.grey[300],
        ),
        // Right half - Terms of Use
        Expanded(
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Terms of Use',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    fontFamily: 'Rounded',
                  ),
                ),
                const SizedBox(height: 12),
                _buildTermsSection(
                  title: 'Use of App',
                  content:
                      'This game is provided for entertainment and educational purposes for kids.\n\n'
                      'You agree not to:\n'
                      '• Copy game assets\n'
                      '• Modify or hack the game\n'
                      '• Redistribute content illegally\n'
                      '• Reverse engineer the app',
                ),
                _buildTermsSection(
                  title: 'Intellectual Property',
                  content:
                      '• All graphics, design, logo, and content belong to CAPFEX.\n'
                      '• You may not reuse or copy game content without permission.',
                ),
                _buildTermsSection(
                  title: 'Contact',
                  content:
                      'Company: CAPFEX Infotech\n'
                      'Email: capfexinfotech@gmail.com',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPrivacySection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Rounded',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            height: 1.5,
            fontFamily: 'Rounded',
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTermsSection({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Rounded',
          ),
        ),
        const SizedBox(height: 6),
        Text(
          content,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            height: 1.5,
            fontFamily: 'Rounded',
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class TermsAndConditionsSidebarContent extends StatelessWidget {
  const TermsAndConditionsSidebarContent({super.key});

  @override
  Widget build(BuildContext context) {
    // This content is now shown in PrivacyPolicySidebarContent as side-by-side layout
    return const SizedBox.shrink();
  }
}

class FAQSidebarContent extends StatefulWidget {
  const FAQSidebarContent({super.key});

  @override
  State<FAQSidebarContent> createState() => _FAQSidebarContentState();
}

class _FAQSidebarContentState extends State<FAQSidebarContent> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'FAQs',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 16),
          // Just show a few FAQs for sidebar
          _buildFAQItem(
            'What is TinyMinds?',
            'TinyMinds is an interactive educational app for children.',
            0,
          ),
          _buildFAQItem(
            'Is it safe for kids?',
            'Yes, TinyMinds is designed with children\'s safety in mind.',
            1,
          ),
          _buildFAQItem(
            'Are there any purchases?',
            'No, TinyMinds is completely free with no hidden charges.',
            2,
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer, int index) {
    final isExpanded = _expandedIndex == index;
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _expandedIndex = isExpanded ? null : index;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    question,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Rounded',
                    ),
                  ),
                ),
                Icon(
                  isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              answer,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                height: 1.5,
                fontFamily: 'Rounded',
              ),
            ),
          ),
        const Divider(height: 1),
      ],
    );
  }
}

class SettingsSidebarContent extends StatefulWidget {
  const SettingsSidebarContent({super.key});

  @override
  State<SettingsSidebarContent> createState() => _SettingsSidebarContentState();
}

class _SettingsSidebarContentState extends State<SettingsSidebarContent> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingItem(
            'Mute Notifications',
            _notificationsEnabled,
            (value) {
              setState(() => _notificationsEnabled = value);
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            'Mute Sound',
            !_soundEnabled,
            (value) {
              setState(() => _soundEnabled = !value);
            },
          ),
          const SizedBox(height: 12),
          _buildSettingItem(
            'Vibration',
            _vibrationEnabled,
            (value) {
              setState(() => _vibrationEnabled = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, bool value, Function(bool) onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontFamily: 'Rounded',
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF2563EB),
        ),
      ],
    );
  }
}
