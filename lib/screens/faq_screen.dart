import 'package:flutter/material.dart';
import '../widgets/full_screen_menu.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int? _expandedIndex;

  final List<FAQItem> _faqList = [
    FAQItem(
      question: 'What is TinyMinds?',
      answer:
          'TinyMinds is an interactive educational app designed for young children. It features coloring templates, creative games, and educational content to develop fine motor skills, creativity, and cognitive abilities.',
    ),
    FAQItem(
      question: 'Is TinyMinds safe for my child?',
      answer:
          'Yes! TinyMinds is designed with children\'s safety in mind. The app contains no ads, external links, or inappropriate content. We do not collect personal information from children without parental consent.',
    ),
    FAQItem(
      question: 'Are there in-app purchases?',
      answer:
          'No, TinyMinds is completely free with no in-app purchases or hidden charges. All features are available for free to all users.',
    ),
    FAQItem(
      question: 'What age group is TinyMinds for?',
      answer:
          'TinyMinds is recommended for children ages 3-8 years old. The activities are designed to be age-appropriate and developmentally beneficial.',
    ),
    FAQItem(
      question: 'Can I turn off notifications?',
      answer:
          'Yes, you can manage notifications in the Settings. Go to Settings > Notifications and toggle the option to turn notifications on or off.',
    ),
    FAQItem(
      question: 'How do I mute the sound?',
      answer:
          'You can mute all sound effects by going to Settings > Mute Sound and toggling the switch. This will silence all game sounds and music.',
    ),
    FAQItem(
      question: 'Why is the app in landscape mode?',
      answer:
          'TinyMinds is designed in landscape mode to provide the best experience for children using tablets or larger devices while playing.',
    ),
    FAQItem(
      question: 'How do I contact support?',
      answer:
          'If you have any issues or questions, please contact us at support@tinyminds.com. We\'re here to help!',
    ),
    FAQItem(
      question: 'Can I save my progress?',
      answer:
          'Yes, your progress and preferences are automatically saved on your device. You can continue where you left off next time you open the app.',
    ),
    FAQItem(
      question: 'What should I do if the app crashes?',
      answer:
          'Try closing and reopening the app. If the problem persists, try clearing the app cache or reinstalling it. If issues continue, please contact our support team.',
    ),
  ];

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'FAQs',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _faqList.length,
                itemBuilder: (context, index) {
                  return _buildFAQCard(index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('FAQs'),
      backgroundColor: const Color(0xFF6C63FF),
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const FullScreenMenu(currentPage: 'faq'),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFAQCard(int index) {
    final faq = _faqList[index];
    final isExpanded = _expandedIndex == index;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              title: Text(
                faq.question,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              trailing: AnimatedRotation(
                turns: isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 220),
                child: const Icon(
                  Icons.expand_more,
                  color: Color(0xFF6C63FF),
                  size: 22,
                ),
              ),
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.grey[300], thickness: 0.6),
                    const SizedBox(height: 8),
                    Text(
                      faq.answer,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
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
}

class FAQItem {
  final String question;
  final String answer;

  FAQItem({required this.question, required this.answer});
}
