import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  int _totalWalletPoints = 1450;
  int _streakDays = 5;
  bool _claimedToday = false;
  final List<int> _dailyRewards = [50, 50, 100, 50, 50, 50, 250];
  final int _currentDayIndex = 4; // Day 5 active

  void _claimDailyBonus() {
    if (_claimedToday) return;
    final bonus = _dailyRewards[_currentDayIndex];
    setState(() {
      _claimedToday = true;
      _totalWalletPoints += bonus;
      _streakDays += 1;
    });

    AppSnackbar.show(
      context,
      "🎉 Daily Bonus of +$bonus Points Claimed! Streak: $_streakDays Days 🔥",
      type: SnackType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),
            const SizedBox(height: 24),

            // Active Plan Banner Card
            _buildActivePlanBanner(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 100.ms),
            const SizedBox(height: 24),

            // Daily Login Streak Section
            _buildDailyStreakSection(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 32),

            // Section Header
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Exclusive Offers & Boosters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.clock, size: 14, color: AppColors.secondaryText),
                    SizedBox(width: 6),
                    Text(
                      'Updated Hourly',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
            const SizedBox(height: 24),

            // Booster Cards Grid/List
            _buildOffersGrid(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 300.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.hoverBackground,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(LucideIcons.gift, color: AppColors.primaryGreen, size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Rewards & Offers',
                style: TextStyle(fontSize: isMobile ? 20 : 28, fontWeight: FontWeight.bold, color: AppColors.darkText),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              const Text(
                'Unlock special platform deals, discounts, and daily streak points.',
                style: TextStyle(fontSize: 14, color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivePlanBanner(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 20 : 32),
      decoration: BoxDecoration(
        color: const Color(0xFF0F4421), // Dark forest green
        borderRadius: BorderRadius.circular(24),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildBannerLeftSection(),
                const SizedBox(height: 24),
                _buildPointsCard(context, isMobile),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 6, child: _buildBannerLeftSection()),
                const SizedBox(width: 40),
                Expanded(flex: 4, child: _buildPointsCard(context, isMobile)),
              ],
            ),
    );
  }

  Widget _buildBannerLeftSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(LucideIcons.checkCircle, color: Colors.white, size: 12),
              SizedBox(width: 6),
              Text(
                'ACTIVE REWARDS PLAN',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Grow Your Business, Collect Premium Perks',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          'Log in daily, complete milestones, and transact consistently to stack loyalty points and unlock deep discounts across your workspace subscriptions.',
          style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildPointsCard(BuildContext context, bool isMobile) {
    final double rupeeVals = _totalWalletPoints / 100.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF083318), // Deeper green
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.yellow, shape: BoxShape.circle),
                child: const Icon(LucideIcons.coins, color: Color(0xFF083318), size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'TOTAL WALLET POINTS',
                style: TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _totalWalletPoints.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},'),
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
          Text(
            '≈ ₹${rupeeVals.toStringAsFixed(2)} Value',
            style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.yellow.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.yellow.withValues(alpha: 0.3)),
            ),
            child: const Text(
              'Gold Elite 👑',
              style: TextStyle(color: AppColors.yellow, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                AppSnackbar.show(
                  context,
                  "Success: converted $_totalWalletPoints reward points to wallet balance.",
                  type: SnackType.success,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.yellow,
                foregroundColor: const Color(0xFF083318),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text(
                'Convert to Wallet',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyStreakSection(bool isMobile) {
    final todayBonus = _dailyRewards[_currentDayIndex];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFCD34D), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.amber.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(LucideIcons.flame, color: Color(0xFFD97706), size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: const Text(
                                  'Daily Login Streak Rewards',
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF78350F)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF59E0B),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '🔥 $_streakDays Day Streak',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Log in daily to maintain your streak & claim extra points toward rewards!',
                            style: TextStyle(fontSize: 12, color: Color(0xFF92400E)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 7-Day Reward Tracker Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = (constraints.maxWidth - (6 * (isMobile ? 6 : 10))) / 7;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(7, (index) {
                  final dayNum = index + 1;
                  final rewardPts = _dailyRewards[index];
                  final isDone = index < _currentDayIndex || (index == _currentDayIndex && _claimedToday);
                  final isCurrent = index == _currentDayIndex && !_claimedToday;
                  final isBonusDay = index == 6;

                  return Container(
                    width: itemWidth,
                    padding: EdgeInsets.symmetric(vertical: isMobile ? 8 : 12, horizontal: 2),
                    decoration: BoxDecoration(
                      color: isDone
                          ? const Color(0xFFD1FAE5)
                          : isCurrent
                              ? const Color(0xFFFEF3C7)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFF10B981)
                            : isCurrent
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFFE5E7EB),
                        width: isCurrent ? 2.0 : 1.0,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Day $dayNum',
                          style: TextStyle(
                            fontSize: isMobile ? 9 : 11,
                            fontWeight: FontWeight.bold,
                            color: isDone
                                ? const Color(0xFF047857)
                                : isCurrent
                                    ? const Color(0xFFB45309)
                                    : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Icon(
                          isDone
                              ? LucideIcons.checkCircle2
                              : isBonusDay
                                  ? LucideIcons.crown
                                  : LucideIcons.gift,
                          size: isMobile ? 14 : 18,
                          color: isDone
                              ? const Color(0xFF10B981)
                              : isCurrent
                                  ? const Color(0xFFF59E0B)
                                  : const Color(0xFF9CA3AF),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '+$rewardPts',
                          style: TextStyle(
                            fontSize: isMobile ? 9 : 12,
                            fontWeight: FontWeight.bold,
                            color: isDone
                                ? const Color(0xFF065F46)
                                : isCurrent
                                    ? const Color(0xFFD97706)
                                    : const Color(0xFF4B5563),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: 20),

          // Claim Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _claimedToday ? null : _claimDailyBonus,
              icon: Icon(
                _claimedToday ? LucideIcons.checkCircle : LucideIcons.sparkles,
                size: 18,
              ),
              label: Text(
                _claimedToday ? "✓ Daily Bonus Claimed Today (+${todayBonus} Pts)" : "Claim Today's Bonus (+${todayBonus} Points)",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _claimedToday ? const Color(0xFF059669) : const Color(0xFFD97706),
                foregroundColor: Colors.white,
                disabledBackgroundColor: const Color(0xFF059669),
                disabledForegroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: _claimedToday ? 0 : 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersGrid(BuildContext context, bool isMobile) {
    final offers = [
      {
        'title': 'Starter Wallet Load Reward',
        'badge': '2% OFF PRO',
        'desc': 'Load ₹5,000 or more into your Cliks Wallet and claim a 2% flat discount on your next monthly or annual Cliks Pro subscription.',
        'color': AppColors.success,
      },
      {
        'title': 'Silver Wallet Load Reward',
        'badge': '3.5% OFF PRO',
        'desc': 'Load ₹10,000 or more into your Cliks Wallet and claim a 3.5% flat discount on your next monthly or annual Cliks Pro subscription.',
        'color': AppColors.blue,
      },
      {
        'title': 'Gold Wallet Load Reward',
        'badge': '5% OFF PRO',
        'desc': 'Load ₹25,000 or more into your Cliks Wallet and claim a 5% flat discount on your next monthly or annual Cliks Pro subscription.',
        'color': AppColors.yellow,
      },
      {
        'title': 'Platinum Wallet Load Reward',
        'badge': '8% OFF PRO',
        'desc': 'Load ₹50,000 or more into your Cliks Wallet and claim a 8% flat discount on your next monthly or annual Cliks Pro subscription.',
        'color': AppColors.purpleAccent,
      },
    ];

    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: offers.map((o) {
        return SizedBox(
          width: isMobile ? double.infinity : 340,
          child: _buildOfferCard(context, o),
        );
      }).toList(),
    );
  }

  Widget _buildOfferCard(BuildContext context, Map<String, dynamic> offer) {
    final Color badgeColor = offer['color'] as Color;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(LucideIcons.wallet, color: badgeColor, size: 18),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  offer['badge'] as String,
                  style: TextStyle(color: badgeColor, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            offer['title'] as String,
            style: const TextStyle(color: AppColors.darkText, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            offer['desc'] as String,
            style: const TextStyle(color: AppColors.secondaryText, fontSize: 12, height: 1.4),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              AppSnackbar.show(
                context,
                "Loading wallet integration gateway... Please wait.",
                type: SnackType.info,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Load Wallet Now',
                  style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 12),
                ),
                const SizedBox(width: 6),
                Icon(LucideIcons.arrowRight, color: badgeColor, size: 14),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
