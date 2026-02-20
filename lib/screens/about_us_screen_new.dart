import 'package:flutter/material.dart';

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
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Rounded',
            ),
          ),
          const SizedBox(height: 16),

          // Welcome Text
          const Text(
            'We are thrilled to have you as part of our community of over 250 million parents who already trust us. With our collection of 23 educational apps and 2000+ education activities for preschoolers, we hope that TinyMinds will become a daily part of your child\'s education.',
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

          // Trust Points Grid (2 rows x 3 columns)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrustIcon(
                    imagePath: 'assets/icons/icons8-no-ads-96.png',
                    title: 'No Ads',
                    description: 'Safe content',
                  ),
                  _buildTrustIcon(
                    imagePath: 'assets/icons/icons8-verified-96.png',
                    title: 'Safe Content',
                    description: 'Verified games',
                  ),
                  _buildTrustIcon(
                    imagePath: 'assets/icons/icons8-kid-96.png',
                    title: 'Preschool Kids',
                    description: 'Age appropriate',
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTrustIcon(
                    imagePath: 'assets/icons/icons8-world-96.png',
                    title: 'Localization',
                    description: 'Global access',
                  ),
                  _buildTrustIcon(
                    imagePath: 'assets/icons/icons8-degree-96.png',
                    title: 'Learning',
                    description: 'Interactive games',
                  ),
                  _buildTrustIcon(
                    imagePath: 'assets/icons/icons8-gift-96.png',
                    title: 'Free Games',
                    description: 'No purchases',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Rate Us Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Enjoying our apps?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontFamily: 'Rounded',
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Color(0xFF4CAF50), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Rate Us',
                        style: TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
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

          // Social Media Icons - from assets
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIconFromAsset('assets/icons/icons8-instagram-48.png'),
              const SizedBox(width: 16),
              _buildSocialIconFromAsset('assets/icons/icons8-facebook-48.png'),
              const SizedBox(width: 16),
              _buildSocialIconFromAsset('assets/icons/icons8-x-48.png'),
              const SizedBox(width: 16),
              _buildSocialIconFromAsset('assets/icons/icons8-youtube-48.png'),
              const SizedBox(width: 16),
              _buildSocialIconFromAsset('assets/icons/icons8-tik-tok-48.png'),
              const SizedBox(width: 16),
              _buildSocialIconFromAsset('assets/icons/icons8-pinterest-48.png'),
            ],
          ),
          const SizedBox(height: 24),

          // Footer Links - Side by side
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/privacy');
                },
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
              const SizedBox(width: 32),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/terms');
                },
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
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: const BoxDecoration(
            color: Color(0xFF2563EB),
            shape: BoxShape.circle,
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontFamily: 'Rounded',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Rounded',
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIconFromAsset(String imagePath) {
    return Container(
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
    );
  }
}
