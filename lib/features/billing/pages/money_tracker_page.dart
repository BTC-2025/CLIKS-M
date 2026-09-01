import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class MoneyTrackerPage extends StatefulWidget {
  const MoneyTrackerPage({super.key});

  @override
  State<MoneyTrackerPage> createState() => _MoneyTrackerPageState();
}

class _MoneyTrackerPageState extends State<MoneyTrackerPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 20, isMobile ? 16 : 24, isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF6366F1).withValues(alpha: 0.3), width: 1.5),
                  ),
                  child: const Icon(
                    LucideIcons.compass,
                    color: Color(0xFF6366F1),
                    size: 28,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Money Tracker',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track customized budgets, travel expenses, photos, timelines, and locations.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.secondaryText.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Recent Trackers Section Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(LucideIcons.clock, color: Color(0xFF6366F1), size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Recent Trackers',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                        ],
                      ),
                      if (!isMobile)
                        SizedBox(
                          width: 320,
                          height: 38,
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Search by name, place, category, date...',
                              hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                              prefixIcon: Icon(LucideIcons.search, size: 16, color: Colors.grey.shade400),
                              contentPadding: const EdgeInsets.symmetric(vertical: 8),
                              filled: true,
                              fillColor: const Color(0xFFF9FAFB),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade200),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: Color(0xFF6366F1)),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (isMobile) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 38,
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(fontSize: 13),
                        decoration: InputDecoration(
                          hintText: 'Search by name, place, category, date...',
                          hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                          prefixIcon: Icon(LucideIcons.search, size: 16, color: Colors.grey.shade400),
                          contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          filled: true,
                          fillColor: const Color(0xFFF9FAFB),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Color(0xFF6366F1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFB),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200, width: 1.2),
                    ),
                    child: Center(
                      child: Text(
                        'No active trackers. Select a category below to start tracking!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Section Header: Choose Category to Track
            const Row(
              children: [
                Icon(LucideIcons.plus, color: Color(0xFF6366F1), size: 22),
                SizedBox(width: 8),
                Text(
                  'Choose Category to Track',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 4 Category Cards Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = constraints.maxWidth > 1100
                    ? (constraints.maxWidth - 48) / 4
                    : constraints.maxWidth > 700
                        ? (constraints.maxWidth - 16) / 2
                        : constraints.maxWidth;

                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _CategoryCard(
                      width: cardWidth,
                      icon: LucideIcons.plane,
                      iconBgColor: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF4F46E5),
                      title: 'Trips',
                      badgeText: '0 tracked previously',
                      description: 'Track expenses, locations, photos and memories during your travels.',
                      buttonColor: const Color(0xFF4F46E5),
                      onTap: () {},
                    ),
                    _CategoryCard(
                      width: cardWidth,
                      icon: LucideIcons.landmark,
                      iconBgColor: const Color(0xFFFFF7ED),
                      iconColor: const Color(0xFFD97706),
                      title: 'God Worship / Pilgrimage',
                      badgeText: '0 tracked previously',
                      description: 'Manage darshan times, offerings, donations, food, and stays.',
                      buttonColor: const Color(0xFFD97706),
                      onTap: () {},
                    ),
                    _CategoryCard(
                      width: cardWidth,
                      icon: LucideIcons.briefcase,
                      iconBgColor: const Color(0xFFEFF6FF),
                      iconColor: const Color(0xFF1D4ED8),
                      title: 'Work / Business Travel',
                      badgeText: '0 tracked previously',
                      description: 'Log meetings, hotels, taxi rides, meals, and generate expense reports.',
                      buttonColor: const Color(0xFF1D4ED8),
                      onTap: () {},
                    ),
                    _CategoryCard(
                      width: cardWidth,
                      icon: LucideIcons.partyPopper,
                      iconBgColor: const Color(0xFFFDF2F8),
                      iconColor: const Color(0xFFDB2777),
                      title: 'Events',
                      badgeText: '0 tracked previously',
                      description: 'Budget ticket costs, food, shopping, guest lists, and event photo books.',
                      buttonColor: const Color(0xFFDB2777),
                      onTap: () {},
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String badgeText;
  final String description;
  final Color buttonColor;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.width,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.badgeText,
    required this.description,
    required this.buttonColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 40,
            child: Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Start Tracking',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(LucideIcons.chevronRight, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
