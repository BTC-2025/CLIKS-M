import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _selectedTierIndex = 1; // 0: BASIC PLAN, 1: FIN-PRO (AUDITOR), 2: BETA CLUB

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final paddingVal = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Page Header (Title + Subtitle + Annual Billing Badge)
            _buildPageHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // 2. Active Plan Royal Blue Banner
            _buildActivePlanBanner(isMobile).animate().fadeIn(duration: 450.ms, delay: 50.ms),
            const SizedBox(height: 24),

            // 3. Tier Filter Pills Bar
            _buildTierFilterBar(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // 4. Tier Content View
            _buildActiveTierView(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 36),

            // 5. Billing & Statement History Section
            _buildBillingHistorySection(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Page Header
  // ---------------------------------------------------------------------------
  Widget _buildPageHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F5132),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.creditCard, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription & Billing',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Manage your active workspace tier, features access, and transaction statements.',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Annual Billing Cycle',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF059669),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'ACTIVE',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F5132),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.creditCard, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subscription & Billing',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Manage your active workspace tier, features access, and transaction statements.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: Row(
            children: [
              Text(
                'Annual Billing Cycle',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green.shade800),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF059669),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'ACTIVE',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Active Plan Royal Blue Banner
  // ---------------------------------------------------------------------------
  Widget _buildActivePlanBanner(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2563EB).withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'ACTIVE PLAN: ',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing: 0.5),
                      ),
                      TextSpan(
                        text: 'FIN-PRO Standard',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your workspace is configured with comprehensive auditor pipelines under the FIN-PRO Standard tier.',
                  style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85), height: 1.3),
                ),
              ],
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('NEXT RENEWAL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.7), letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      const Text('01 May, 2027', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                  Container(height: 30, width: 1, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 16)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('RENEWAL AMOUNT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white.withValues(alpha: 0.7), letterSpacing: 0.5)),
                      const SizedBox(height: 4),
                      const Text('₹4,999 + GST', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Tier Filter Pills Bar
  // ---------------------------------------------------------------------------
  Widget _buildTierFilterBar(bool isMobile) {
    final tiers = [
      {'icon': LucideIcons.shieldCheck, 'label': 'BASIC PLAN'},
      {'icon': LucideIcons.shieldCheck, 'label': 'FIN-PRO (AUDITOR)'},
      {'icon': LucideIcons.crown, 'label': 'BETA CLUB'},
    ];

    return Center(
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(tiers.length, (index) {
              final isSelected = _selectedTierIndex == index;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: InkWell(
                  onTap: () => setState(() => _selectedTierIndex = index),
                  borderRadius: BorderRadius.circular(26),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Row(
                      children: [
                        Icon(
                          tiers[index]['icon'] as IconData,
                          size: 15,
                          color: isSelected ? Colors.white : Colors.grey.shade700,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          tiers[index]['label'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.grey.shade800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Tier Content View Router
  // ---------------------------------------------------------------------------
  Widget _buildActiveTierView(bool isMobile) {
    switch (_selectedTierIndex) {
      case 0:
        return _buildBasicPlanView(isMobile);
      case 1:
        return _buildFinProAuditorView(isMobile);
      case 2:
        return _buildBetaClubView(isMobile);
      default:
        return _buildFinProAuditorView(isMobile);
    }
  }

  // ---------------------------------------------------------------------------
  // Tier View 1: BASIC PLAN (Screenshots 3 & 4)
  // ---------------------------------------------------------------------------
  Widget _buildBasicPlanView(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Basic Plan Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 20),

        Center(
          child: Container(
            width: isMobile ? double.infinity : 400,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.shieldCheck, color: Color(0xFF059669), size: 22),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Basic Plan',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                const SizedBox(height: 4),
                Text(
                  'Simple, ad-free experience to get you started.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 20),

                Row(
                  children: [
                    Text(
                      '₹499',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Save ₹250',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '₹249',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.darkText),
                    ),
                    Text(
                      ' / year',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '(Equivalent to ₹21 per month)',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF0F5132),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Color(0xFF0F5132), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Upgrade Plan', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 24),
                Divider(color: Colors.grey.shade200),
                const SizedBox(height: 16),

                Text(
                  "WHAT'S INCLUDED",
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5),
                ),
                const SizedBox(height: 12),
                _buildIncludedFeatureRow('No Ads'),
                _buildIncludedFeatureRow('Validity: Up to 12 Days'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tier View 2: FIN-PRO (AUDITOR) (Screenshots 1 & 2)
  // ---------------------------------------------------------------------------
  Widget _buildFinProAuditorView(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upgrade Workspace Tier',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 20),

        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth > 950
                ? (constraints.maxWidth - 32) / 3
                : constraints.maxWidth > 600
                    ? (constraints.maxWidth - 16) / 2
                    : constraints.maxWidth;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                // Card 1: FIN-PRO Standard (Active Card)
                _buildPricingCard(
                  width: cardWidth,
                  title: 'FIN-PRO Standard',
                  description: 'Perfect for independent practitioners and small firms.',
                  icon: LucideIcons.shieldCheck,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF2563EB),
                  badgeLabel: 'ESSENTIAL',
                  isHighlightedBorder: true,
                  oldPrice: '₹6,999',
                  saveLabel: 'Save ₹2,000',
                  price: '₹4,999',
                  monthPrice: '(Equivalent to ₹417 per month)',
                  buttonText: 'Currently Active Plan',
                  isSolidButton: true,
                  features: const [
                    'Manage up to 25 Active Client Ledgers',
                    'Standard Multi-Client GST/ITR Reporting',
                    'Direct Auditing & Daybook Verification Logs',
                    'Automated Exporting to CSV/Excel formats',
                    'Priority Email Support',
                  ],
                ),

                // Card 2: FIN-PRO Premium
                _buildPricingCard(
                  width: cardWidth,
                  title: 'FIN-PRO Premium',
                  description: 'Designed for high-growth firms and collaborative auditing teams.',
                  icon: LucideIcons.zap,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF2563EB),
                  oldPrice: '₹14,999',
                  saveLabel: 'Save ₹5,000',
                  price: '₹9,999',
                  monthPrice: '(Equivalent to ₹833 per month)',
                  buttonText: 'Upgrade Plan',
                  isOutlineButton: true,
                  features: const [
                    'Manage up to 100 Active Client Ledgers',
                    'Custom White-Labeled Client Report Generation',
                    'Multi-User Staff Logins (up to 5 members)',
                    'Automated Client Payment & Reminder Rules',
                    'Live Chat Support & Direct API Sandbox Access',
                  ],
                ),

                // Card 3: FIN-PRO Enterprise
                _buildPricingCard(
                  width: cardWidth,
                  title: 'FIN-PRO Enterprise',
                  description: 'Complete control and white-labeling for national firms.',
                  icon: LucideIcons.crown,
                  iconBgColor: const Color(0xFFEFF6FF),
                  iconColor: const Color(0xFF2563EB),
                  oldPrice: '₹29,999',
                  saveLabel: 'Save ₹10,000',
                  price: '₹19,999',
                  monthPrice: '(Equivalent to ₹1,667 per month)',
                  buttonText: 'Upgrade Plan',
                  isOutlineButton: true,
                  features: const [
                    'Manage Unlimited Active Client Ledgers',
                    'Fully Branded Dedicated Client Portal System',
                    'Uncapped Staff Logins with Advanced Permissions',
                    'Dedicated Account Executive & API/ERP Sync',
                    'Priority 24/7/365 Direct VIP Phone Support',
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Tier View 3: BETA CLUB (Screenshots)
  // ---------------------------------------------------------------------------
  int _betaSubIndex = 0; // 0: Investor Club, 1: Products & Ideas

  Widget _buildBetaClubView(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sub-Tab Pill Bar: Investor Club & Products & Ideas
        Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () => setState(() => _betaSubIndex = 0),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: _betaSubIndex == 0 ? const Color(0xFF7C3AED) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withValues(alpha: _betaSubIndex == 0 ? 0.3 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.crown, size: 16, color: _betaSubIndex == 0 ? Colors.white : const Color(0xFF7C3AED)),
                        const SizedBox(width: 8),
                        Text(
                          'Investor Club',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _betaSubIndex == 0 ? Colors.white : AppColors.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                InkWell(
                  onTap: () => setState(() => _betaSubIndex = 1),
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    decoration: BoxDecoration(
                      color: _betaSubIndex == 1 ? const Color(0xFFD946EF) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFD946EF).withValues(alpha: _betaSubIndex == 1 ? 0.3 : 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Icon(LucideIcons.zap, size: 16, color: _betaSubIndex == 1 ? Colors.white : const Color(0xFFD946EF)),
                        const SizedBox(width: 8),
                        Text(
                          'Products & Ideas',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: _betaSubIndex == 1 ? Colors.white : AppColors.darkText,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 28),
        const Text(
          'Upgrade Workspace Tier',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 20),

        if (_betaSubIndex == 0) _buildInvestorClubCards(isMobile) else _buildProductsIdeasCards(isMobile),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Beta Club: Investor Club Cards (Purple Theme)
  // ---------------------------------------------------------------------------
  Widget _buildInvestorClubCards(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 950
            ? (constraints.maxWidth - 32) / 3
            : constraints.maxWidth > 600
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Beta Angel
            _buildPricingCard(
              width: cardWidth,
              title: 'Beta Angel',
              description: 'Access curated startup directories and begin early-stage venture backing.',
              icon: LucideIcons.shieldCheck,
              iconBgColor: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF7C3AED),
              oldPrice: '₹7,999',
              saveLabel: 'Save ₹3,000',
              price: '₹4,999',
              monthPrice: '(Equivalent to ₹417 per month)',
              buttonText: 'Upgrade Plan',
              isCustomColorButton: true,
              buttonColor: const Color(0xFF7C3AED),
              features: const [
                'Access to curated startup and deal directories',
                'Filter pitches by industry, funding goal, and equity share',
                'Direct contact channels with verified founders (up to 15/mo)',
                'Access to standard investor mastermind forums',
                'Real-time notifications for newly listed ventures',
              ],
            ),

            // Beta Venture Partner
            _buildPricingCard(
              width: cardWidth,
              title: 'Beta Venture Partner',
              description: 'Designed for professional angels, syndicate participants, and active investors.',
              icon: LucideIcons.zap,
              iconBgColor: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF7C3AED),
              oldPrice: '₹14,999',
              saveLabel: 'Save ₹5,000',
              price: '₹9,999',
              monthPrice: '(Equivalent to ₹833 per month)',
              buttonText: 'Upgrade Plan',
              isCustomColorButton: true,
              buttonColor: const Color(0xFF7C3AED),
              features: const [
                'All features of Beta Angel tier',
                'Direct contact details for unlimited startup listings',
                'Interactive deal rooms & shared pitch folders',
                'Monthly co-investment circulars & VC partner access',
                '1-on-1 deal flow consultations with steering team',
              ],
            ),

            // Beta Syndicate Lead
            _buildPricingCard(
              width: cardWidth,
              title: 'Beta Syndicate Lead',
              description: 'Ultimate sovereign tier for syndicates, institutional offices, and active VC networks.',
              icon: LucideIcons.crown,
              iconBgColor: const Color(0xFFF3E8FF),
              iconColor: const Color(0xFF7C3AED),
              oldPrice: '₹39,999',
              saveLabel: 'Save ₹15,000',
              price: '₹24,999',
              monthPrice: '(Equivalent to ₹2,083 per month)',
              buttonText: 'Upgrade Plan',
              isCustomColorButton: true,
              buttonColor: const Color(0xFF7C3AED),
              features: const [
                'All features of Beta Venture Partner tier',
                'Direct syndicate matching & co-investment structures',
                'VIP reserved seat at the Annual Founder\'s & Investor Gala',
                'Priority invitations to physical Family Office roundtables',
                'Dedicated investment analyst assistance & custom market research',
              ],
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Beta Club: Products & Ideas Cards (Magenta Pink Theme)
  // ---------------------------------------------------------------------------
  Widget _buildProductsIdeasCards(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 950
            ? (constraints.maxWidth - 32) / 3
            : constraints.maxWidth > 600
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Beta Innovator
            _buildPricingCard(
              width: cardWidth,
              title: 'Beta Innovator',
              description: 'Early access for founders seeking foundational product testing & community reach.',
              icon: LucideIcons.shieldCheck,
              iconBgColor: const Color(0xFFFCE7F3),
              iconColor: const Color(0xFFD946EF),
              oldPrice: '₹2,999',
              saveLabel: 'Save ₹1,000',
              price: '₹1,999',
              monthPrice: '(Equivalent to ₹167 per month)',
              buttonText: 'Upgrade Plan',
              isCustomColorButton: true,
              buttonColor: const Color(0xFFD946EF),
              features: const [
                'Early access to new platform updates & beta tools',
                'Standard community mastermind forum access',
                'List 1 active roadmap/pitch in the Deal Marketplace',
                '10% direct discount on partner integration modules',
                'Standard investor-ready pitch templates & checklists',
              ],
            ),

            // Beta Founder Premium
            _buildPricingCard(
              width: cardWidth,
              title: 'Beta Founder Premium',
              description: 'High-impact visibility, top placement, and verified badge for active venture teams.',
              icon: LucideIcons.zap,
              iconBgColor: const Color(0xFFFCE7F3),
              iconColor: const Color(0xFFD946EF),
              oldPrice: '₹7,999',
              saveLabel: 'Save ₹3,000',
              price: '₹4,999',
              monthPrice: '(Equivalent to ₹417 per month)',
              buttonText: 'Upgrade Plan',
              isCustomColorButton: true,
              buttonColor: const Color(0xFFD946EF),
              features: const [
                'All features of Beta Innovator tier',
                'List up to 3 active roadmaps/pitches in the Marketplace',
                'Top search placement inside the investor directory',
                'Verified checkmark badge after deck review',
                'Direct feedback channel to product steering team',
                '20% lifetime discount on partner integrations',
              ],
            ),

            // Beta Founding Partner
            _buildPricingCard(
              width: cardWidth,
              title: 'Beta Founding Partner',
              description: 'Sovereign founder tier with steering seat, lifetime fee freeze, and VIP gala entry.',
              icon: LucideIcons.crown,
              iconBgColor: const Color(0xFFFCE7F3),
              iconColor: const Color(0xFFD946EF),
              oldPrice: '₹24,999',
              saveLabel: 'Save ₹10,000',
              price: '₹14,999',
              monthPrice: '(Equivalent to ₹1,250 per month)',
              buttonText: 'Upgrade Plan',
              isCustomColorButton: true,
              buttonColor: const Color(0xFFD946EF),
              features: const [
                'All features of Beta Founder Premium tier',
                'Unlimited active roadmaps/pitches in the Marketplace',
                'Featured homepage and dashboard spotlight placement',
                'VIP reserved seat at the Annual Founder\'s Gala',
                'Direct voting seat on feature steering committee',
                'Private Pitch-to-VC roundtable access pipelines',
                'Lifetime subscription fee freeze guarantee',
              ],
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // Pricing Card Helper Widget
  // ---------------------------------------------------------------------------
  Widget _buildPricingCard({
    required double width,
    required String title,
    required String description,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    String? badgeLabel,
    bool isHighlightedBorder = false,
    required String oldPrice,
    required String saveLabel,
    required String price,
    required String monthPrice,
    required String buttonText,
    bool isSolidButton = false,
    bool isOutlineButton = false,
    bool isCustomColorButton = false,
    Color? buttonColor,
    required List<String> features,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isHighlightedBorder ? Border.all(color: const Color(0xFF1E3A8A), width: 2) : Border.all(color: Colors.transparent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (badgeLabel != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E3A8A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    badgeLabel,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.3),
          ),
          const SizedBox(height: 20),

          Row(
            children: [
              Text(
                oldPrice,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade400,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  saveLabel,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                price,
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppColors.darkText),
              ),
              const Text(
                ' / year',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            monthPrice,
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: isSolidButton
                ? ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(buttonText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  )
                : OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: buttonColor ?? const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: buttonColor ?? const Color(0xFF2563EB), width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: Text(buttonText, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
          ),

          const SizedBox(height: 24),
          Divider(color: Colors.grey.shade200),
          const SizedBox(height: 16),

          Text(
            "WHAT'S INCLUDED",
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          ...features.map((f) => _buildIncludedFeatureRow(f)),
        ],
      ),
    );
  }

  Widget _buildIncludedFeatureRow(String featureText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.check, size: 14, color: Color(0xFF2563EB)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              featureText,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Billing & Statement History Section (Screenshots 1 & 4)
  // ---------------------------------------------------------------------------
  Widget _buildBillingHistorySection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(LucideIcons.history, color: Color(0xFF059669), size: 20),
              SizedBox(width: 8),
              Text(
                'Billing & Statement History',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Scrollable Statement Table
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800,
              child: Column(
                children: [
                  // Table Header
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        _buildTableHeaderCell('INVOICE ID', flex: 2),
                        _buildTableHeaderCell('BILLING DATE', flex: 2),
                        _buildTableHeaderCell('TIER DETAILS', flex: 2),
                        _buildTableHeaderCell('PAYMENT MODE', flex: 2),
                        _buildTableHeaderCell('STATUS', flex: 2),
                        _buildTableHeaderCell('AMOUNT PAID', flex: 2, alignRight: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Data Row 1
                  _buildStatementRow(
                    invoiceId: 'INV-2026-041',
                    date: '2026-05-01',
                    tier: 'Growth Plan',
                    mode: 'UPI (Razorpay)',
                    status: 'Paid',
                    amount: '₹6,999',
                  ),

                  Divider(height: 1, color: Colors.grey.shade200),

                  // Data Row 2
                  _buildStatementRow(
                    invoiceId: 'INV-2026-029',
                    date: '2025-05-01',
                    tier: 'Growth Plan',
                    mode: 'Bank Transfer',
                    status: 'Paid',
                    amount: '₹6,999',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, {int flex = 1, bool alignRight = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: Colors.grey.shade500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatementRow({
    required String invoiceId,
    required String date,
    required String tier,
    required String mode,
    required String status,
    required String amount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              invoiceId,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F5132)),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              tier,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mode,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
            ),
          ),
        ],
      ),
    );
  }
}
