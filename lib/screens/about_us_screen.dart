import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  final bool showHeader;

  const AboutUsScreen({super.key, this.showHeader = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // CAPFEX Apps Heading
          const Text(
            'CAPFEX Apps',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 16),

          // Welcome Text
          const Text(
            'We are thrilled to have you as part of our community of over 250 million parents who already trust us. With our collection of 23 educational apps and 2000+ education activities for preschoolers, we hope that Colour & Fun for Kids will become a daily part of your child\'s education.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 32),

          // Why Parents Trust Us Title
          const Text(
            'Why Parents Trust Us',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 24),

          // Trust Points Grid (2 rows x 3 columns) — each item uses Expanded so three fit per row
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildTrustIcon(
                      imagePath: 'assets/icons/icons8-no-ads-96.png',
                      title: 'No ADS',
                      description:
                          'Our apps are free from ads, ensuring a safe and uninterrupted learning experience for your child',
                    ),
                  ),
                  Expanded(
                    child: _buildTrustIcon(
                      imagePath: 'assets/icons/icons8-verified-96.png',
                      title: 'Safe Content',
                      description:
                          'Our content is expertly crafted to ensure that it is safe and appropriate for children',
                    ),
                  ),
                  Expanded(
                    child: _buildTrustIcon(
                      imagePath: 'assets/icons/icons8-kid-96.png',
                      title: 'Preschool-Aged Kids',
                      description:
                          'Our apps are suitable for children aged 2 to 5, making them perfect for preschool-aged children',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: _buildTrustIcon(
                      imagePath: 'assets/icons/icons8-world-96.png',
                      title: 'Localization in Apps',
                      description:
                          'Our apps are available in multiple languages, making them accessible to children all over the world',
                    ),
                  ),
                  Expanded(
                    child: _buildTrustIcon(
                      imagePath: 'assets/icons/icons8-degree-96.png',
                      title: 'Interactive Learning',
                      description:
                          'Our apps are interactive and educational, fostering development and teaching vital skills',
                    ),
                  ),
                  Expanded(
                    child: _buildTrustIcon(
                      imagePath: 'assets/icons/icons8-gift-96.png',
                      title: 'Free Games',
                      description:
                          'Try our games for free and fuel your child\'s development. Unlock a world of educational fun!',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Rate Us Section - Green container with text on left and button on right
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Enjoying our apps?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Rounded',
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Please help us to be better!',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontFamily: 'Rounded',
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Color(0xFF4CAF50), size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Rate Us',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Rounded',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

            // Social left corner; Privacy & Terms stacked at right corner
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: social icons (compact row)
                Row(
                  children: [
                    _buildSocialIconFromAsset('assets/icons/icons8-instagram-48.png', 'https://instagram.com/'),
                    const SizedBox(width: 8),
                    _buildSocialIconFromAsset('assets/icons/icons8-facebook-48.png', 'https://facebook.com/'),
                    const SizedBox(width: 8),
                    _buildSocialIconFromAsset('assets/icons/icons8-x-48.png', 'https://x.com/'),
                    const SizedBox(width: 8),
                    _buildSocialIconFromAsset('assets/icons/icons8-youtube-48.png', 'https://youtube.com/'),
                    const SizedBox(width: 8),
                    _buildSocialIconFromAsset('assets/icons/icons8-tik-tok-48.png', 'https://tiktok.com/'),
                    const SizedBox(width: 8),
                    _buildSocialIconFromAsset('assets/icons/icons8-pinterest-48.png', 'https://pinterest.com/'),
                  ],
                ),

                // Spacer pushes right content to the far right
                const Spacer(),

                // Right: Privacy & Terms side-by-side (right-aligned)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => _launchUrl('https://capfex.in/colour-and-fun-for-kids/privacy-policy'),
                      child: const Text(
                        'Privacy Policy',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Rounded',
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () => _launchUrl('https://capfex.in/colour-and-fun-for-kids/terms-and-conditions'),
                      child: const Text(
                        'Terms of Use',
                        style: TextStyle(
                          color: Color(0xFF2563EB),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                          fontFamily: 'Rounded',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTrustIcon({
    required String imagePath,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            child: Center(
              child: Image.asset(
                imagePath,
                width: 64,
                height: 64,
                // show original asset colors (no tint)
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildSocialIconFromAsset(String imagePath, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Color(0xFFE8E8E8),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  static Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // ignore: avoid_print
      print('Could not launch $url');
    }
  }
}
