import 'package:flutter/material.dart';
import '../widgets/full_screen_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF6C63FF).withValues(alpha: 0.1),
              const Color(0xFFFF6584).withValues(alpha: 0.1),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Notification Settings
            _buildSettingCard(
              title: 'Notifications',
              icon: Icons.notifications,
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() => _notificationsEnabled = value);
              },
              description: 'Receive app notifications',
            ),
            const SizedBox(height: 12),

            // Sound Settings
            _buildSettingCard(
              title: 'Mute Sound',
              icon: Icons.volume_up,
              value: !_soundEnabled,
              onChanged: (value) {
                setState(() => _soundEnabled = !value);
              },
              description: 'Turn off all sound effects',
            ),
            const SizedBox(height: 12),

            // Vibration Settings
            _buildSettingCard(
              title: 'Vibration',
              icon: Icons.vibration,
              value: _vibrationEnabled,
              onChanged: (value) {
                setState(() => _vibrationEnabled = value);
              },
              description: 'Enable haptic feedback',
            ),
            const SizedBox(height: 12),

            // Dark Mode Settings
            _buildSettingCard(
              title: 'Dark Mode',
              icon: Icons.dark_mode,
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() => _darkModeEnabled = value);
              },
              description: 'Use dark theme',
            ),
            const SizedBox(height: 24),

            // Additional Info Section
            _buildInfoCard(
              title: 'App Version',
              content: 'TinyMinds v1.0.0',
            ),
            const SizedBox(height: 12),

            _buildInfoCard(
              title: 'Device Settings',
              content: 'All notifications: ${_notificationsEnabled ? 'ON' : 'OFF'}\n'
                  'Sound: ${_soundEnabled ? 'ON' : 'OFF'}\n'
                  'Vibration: ${_vibrationEnabled ? 'ON' : 'OFF'}',
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Settings'),
      backgroundColor: const Color(0xFF6C63FF),
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FullScreenMenu(currentPage: 'settings'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required IconData icon,
    required bool value,
    required Function(bool) onChanged,
    required String description,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF6C63FF).withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF6C63FF), size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: const Color(0xFF6C63FF),
              inactiveThumbColor: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6C63FF),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
