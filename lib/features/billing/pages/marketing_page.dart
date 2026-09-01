import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/compose_email_campaign_dialog.dart';

class MarketingPage extends StatefulWidget {
  const MarketingPage({super.key});

  @override
  State<MarketingPage> createState() => _MarketingPageState();
}

class _MarketingPageState extends State<MarketingPage> {
  int _activeTab = 2; // Default to Trigger Automations (Tab 2) as in screenshots 1 & 2

  final List<String> _tabs = [
    'All Campaigns',
    'Message Templates',
    'Trigger Automations',
    'Audience & Loyalty',
    'Advanced ROI Reports',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.megaphone,
    LucideIcons.fileText,
    LucideIcons.zap,
    LucideIcons.users,
    LucideIcons.barChart,
  ];

  final List<Color> _tabColors = [
    Colors.pink.shade600,
    Colors.blue.shade600,
    Colors.green.shade600,
    Colors.purple.shade600,
    Colors.indigo.shade600,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
            const SizedBox(height: 24),

            // Stat Cards Row
            _buildStatCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // Tabs bar
            _buildTabsBar(isMobile).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 24),

            // Main Data content
            _buildMainContent(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE289F2).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.megaphone, color: Color(0xFF137333), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Email Campaigns & Engagement',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Draft and automate high-conversion Email newsletters, promotional codes, and automated follow-ups.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const ComposeEmailCampaignDialog(),
            );
          },
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Create Email Campaign', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF137333),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          const SizedBox(height: 16),
          actionsWidget,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleWidget),
        const SizedBox(width: 16),
        actionsWidget,
      ],
    );
  }

  Widget _buildStatCards(bool isMobile) {
    final cards = [
      _buildStatCard(
        title: 'TOTAL REACH',
        value: '0',
        icon: LucideIcons.users,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
      ),
      _buildStatCard(
        title: 'AVG. ROI',
        value: '0%',
        icon: LucideIcons.trendingUp,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
      ),
      _buildStatCard(
        title: 'ACTIVE AUTOMATIONS',
        value: '4', // We have 4 automations
        icon: LucideIcons.clock,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: 'CONV. RATE',
        value: '12.4%',
        icon: LucideIcons.percent,
        iconColor: const Color(0xFF8A2BE2),
        bgColor: const Color(0xFFF3E5F5),
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: SizedBox(width: double.infinity, child: c),
        )).toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: cards.map((c) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: c,
            ),
          )).toList(),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsBar(bool isMobile) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: List.generate(_tabs.length, (index) {
            final isSelected = _activeTab == index;
            final iconColor = _tabColors[index];

            return GestureDetector(
              onTap: () => setState(() => _activeTab = index),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected ? const Color(0xFF137333) : Colors.transparent,
                      width: 2.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _tabIcons[index],
                      size: 14,
                      color: isSelected ? const Color(0xFF137333) : iconColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF137333) : AppColors.secondaryText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    switch (_activeTab) {
      case 0:
        return _buildCampaignsTab(isMobile);
      case 1:
        return _buildTemplatesTab(isMobile);
      case 2:
        return _buildAutomationsTab(isMobile);
      case 3:
        return _buildAudienceTab(isMobile);
      case 4:
        return _buildRoiTab(isMobile);
      default:
        return const SizedBox.shrink();
    }
  }

  // --- TAB 0: ALL CAMPAIGNS ---
  Widget _buildCampaignsTab(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFilterRow(isMobile),
          const SizedBox(height: 40),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.megaphone, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  const Text(
                    'No Campaigns Found',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Create a new Email campaign to get started with bulk customer promotions.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.secondaryText, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 1: MESSAGE TEMPLATES ---
  Widget _buildTemplatesTab(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Saved Message Templates',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 20),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.fileText, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.4)),
                  const SizedBox(height: 16),
                  const Text(
                    'No Templates Saved',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Save template structures during campaign creation to reuse them later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, color: AppColors.secondaryText, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- TAB 2: TRIGGER AUTOMATIONS ---
  Widget _buildAutomationsTab(bool isMobile) {
    final List<Map<String, dynamic>> automations = [
      {
        'title': 'Birthday Wish',
        'subtitle': 'Trigger: customer_birthday • Channel: Email • Timing: Instant (09:00 AM)',
        'sent': 45,
        'conv': 12,
        'active': true,
      },
      {
        'title': 'Anniversary Wish',
        'subtitle': 'Trigger: customer_anniversary • Channel: Email • Timing: Instant (10:00 AM)',
        'sent': 12,
        'conv': 3,
        'active': true,
      },
      {
        'title': 'Payment Follow-up',
        'subtitle': 'Trigger: invoice_due • Channel: Email • Timing: 2 Days after due date',
        'sent': 340,
        'conv': 288,
        'active': true,
      },
      {
        'title': 'Abandoned Cart',
        'subtitle': 'Trigger: cart_abandoned • Channel: Email • Timing: 4 Hours after abandonment',
        'sent': 0,
        'conv': 0,
        'active': false,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Marketing & Engagement Automations',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942)),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Configure automated messages triggered by key customer life-cycle events.',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(LucideIcons.plus, size: 14),
                        label: const Text('Configure New Trigger', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF137333),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Marketing & Engagement Automations',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Configure automated messages triggered by key customer life-cycle events.',
                            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(LucideIcons.plus, size: 14),
                      label: const Text('Configure New Trigger', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF137333),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: automations.length,
            itemBuilder: (context, index) {
              final aut = automations[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: aut['active'] ? Colors.green.shade50 : Colors.blueGrey.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  LucideIcons.zap, 
                                  color: aut['active'] ? Colors.green.shade700 : Colors.blueGrey.shade600, 
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  aut['title'],
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: aut['active'] ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  aut['active'] ? 'Active' : 'Paused',
                                  style: TextStyle(
                                    fontSize: 10, 
                                    fontWeight: FontWeight.bold, 
                                    color: aut['active'] ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            aut['subtitle'],
                            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                          ),
                          const SizedBox(height: 10),
                          const Divider(height: 1, color: AppColors.border),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Sent: ${aut['sent']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                              Text('Conversions: ${aut['conv']}', style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: aut['active'] ? Colors.green.shade50 : Colors.blueGrey.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              LucideIcons.zap, 
                              color: aut['active'] ? Colors.green.shade700 : Colors.blueGrey.shade600, 
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  aut['title'],
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  aut['subtitle'],
                                  style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Sent: ${aut['sent']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                              Text('Conversions: ${aut['conv']}', style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: aut['active'] ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              aut['active'] ? 'Active' : 'Paused',
                              style: TextStyle(
                                fontSize: 11, 
                                fontWeight: FontWeight.bold, 
                                color: aut['active'] ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  // --- TAB 3: AUDIENCE & LOYALTY ---
  Widget _buildAudienceTab(bool isMobile) {
    final List<Map<String, dynamic>> segments = [
      {
        'title': 'VIP Customers',
        'subtitle': 'Customers with life-time purchase value > ₹25,000',
        'lcv': 'Avg Lifecycle Value: ₹34,500',
        'buyers': 124,
      },
      {
        'title': 'Active Retail Buyers',
        'subtitle': 'Purchased in the last 30 days',
        'lcv': 'Avg Lifecycle Value: ₹4,200',
        'buyers': 840,
      },
      {
        'title': 'Inactive Lapsed Buyers',
        'subtitle': 'No purchases in the last 90+ days',
        'lcv': 'Avg Lifecycle Value: ₹1,800',
        'buyers': 180,
      },
      {
        'title': 'Wholesale Partners',
        'subtitle': 'Subscribed as verified business purchasers',
        'lcv': 'Avg Lifecycle Value: ₹1,12,000',
        'buyers': 56,
      },
    ];

    final leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Segments',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942)),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: segments.length,
          itemBuilder: (context, index) {
            final seg = segments[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seg['title'],
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          seg['subtitle'],
                          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          seg['lcv'],
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF137333)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${seg['buyers']} Buyers',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );

    final rightColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(LucideIcons.gift, color: Colors.purple.shade600, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Loyalty & Referral Configuration',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Point Redemption Rules Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.award, color: Colors.amber.shade700, size: 18),
                  const SizedBox(width: 8),
                  const Text('Point Redemption Rules', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Earn 1 point for every ₹100 spent. Each point is worth ₹1 at subsequent billings.',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Min Redemption Points', style: TextStyle(fontSize: 9, color: AppColors.secondaryText)),
                          SizedBox(height: 4),
                          Text('100 Points', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Max Points Per Bill', style: TextStyle(fontSize: 9, color: AppColors.secondaryText)),
                          SizedBox(height: 4),
                          Text('500 Points', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Referral Bonus Programs Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(LucideIcons.share2, color: Colors.blue.shade600, size: 18),
                  const SizedBox(width: 8),
                  const Text('Referral Bonus Programs', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Reward current customers when they refer new buyers using custom referral codes.',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.4),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Referrer Reward', style: TextStyle(fontSize: 9, color: AppColors.secondaryText)),
                          SizedBox(height: 4),
                          Text('₹100 Store Credit', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF137333))),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(8)),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Referred Buyer Reward', style: TextStyle(fontSize: 9, color: AppColors.secondaryText)),
                          SizedBox(height: 4),
                          Text('Flat 10% OFF coupon', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF137333))),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        children: [
          leftColumn,
          const SizedBox(height: 32),
          rightColumn,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 11, child: leftColumn),
        const SizedBox(width: 32),
        Expanded(flex: 9, child: rightColumn),
      ],
    );
  }

  // --- TAB 4: ADVANCED ROI REPORTS ---
  Widget _buildRoiTab(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title Block
        Row(
          children: [
            Icon(LucideIcons.barChart3, color: Colors.indigo.shade600, size: 20),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Email Category Campaign ROI Analysis',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // ROI Card Grid
        _buildRoiCards(isMobile),
        const SizedBox(height: 32),

        // Table Title
        const Text(
          'Campaign Performance Comparison',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 16),

        // Table comparative Stats
        _buildPerformanceTable(isMobile),
      ],
    );
  }

  Widget _buildRoiCards(bool isMobile) {
    final cards = [
      _buildRoiCard(
        title: 'Bulk Marketing Emails',
        openRate: '38% Open',
        revenue: '₹1,84,500',
        roi: 'Estimated ROI: 284%',
        themeColor: Colors.green.shade600,
        bgColor: Colors.green.shade50,
      ),
      _buildRoiCard(
        title: 'Transactional Emails',
        openRate: '82% Open',
        revenue: '₹94,200',
        roi: 'Estimated ROI: 162%',
        themeColor: Colors.blue.shade600,
        bgColor: Colors.blue.shade50,
      ),
      _buildRoiCard(
        title: 'Trigger & Auto-Flows',
        openRate: '74% Open',
        revenue: '₹42,800',
        roi: 'Estimated ROI: 118%',
        themeColor: Colors.orange.shade700,
        bgColor: Colors.orange.shade50,
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: c,
        )).toList(),
      );
    }

    return Row(
      children: cards.map((c) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: c,
        ),
      )).toList(),
    );
  }

  Widget _buildRoiCard({
    required String title,
    required String openRate,
    required String revenue,
    required String roi,
    required Color themeColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                child: Text(openRate, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: themeColor)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(revenue, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText)),
          const Text('Total Revenue Generated', style: TextStyle(fontSize: 10, color: AppColors.secondaryText)),
          const SizedBox(height: 16),
          Text(roi, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: themeColor)),
        ],
      ),
    );
  }

  Widget _buildPerformanceTable(bool isMobile) {
    final headers = ['Campaign Name', 'Total Reach', 'Clicks Rate', 'Estimated Revenue', 'Conversion %'];
    final List<List<String>> rows = [
      ['Summer Clearance Sale', '25,000', '14.5%', '₹1,24,000', '4.8%'],
      ['Welcome Onboarding Flow', '12,400', '38.2%', '₹42,800', '12.5%'],
      ['Monthly Newsletter (June)', '18,000', '8.9%', '₹18,500', '2.1%'],
    ];

    final colWidths = {
      0: const FixedColumnWidth(180),
      1: const FixedColumnWidth(110),
      2: const FixedColumnWidth(110),
      3: const FixedColumnWidth(150),
      4: const FixedColumnWidth(110),
    };

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          width: 660,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: colWidths,
            children: [
              TableRow(
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
                ),
                children: headers.map((h) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  child: Text(
                    h.toUpperCase(),
                    style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                )).toList(),
              ),
              ...rows.map((row) => TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                children: row.map((cell) {
                  final isRevenue = cell.startsWith('₹');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                    child: Text(
                      cell,
                      style: TextStyle(
                        fontSize: 12, 
                        fontWeight: isRevenue ? FontWeight.bold : FontWeight.normal,
                        color: isRevenue ? const Color(0xFF137333) : AppColors.darkText,
                      ),
                    ),
                  );
                }).toList(),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterRow(bool isMobile) {
    final searchField = Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          SizedBox(width: 8),
          Icon(LucideIcons.search, size: 14, color: AppColors.secondaryText),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                hintText: 'Search campaigns by name, coupon code or target audience...',
                hintStyle: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ],
      ),
    );

    final filters = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Filter Status:', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
        const SizedBox(width: 6),
        _buildDropdown('All Status'),
      ],
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: 10),
          Align(alignment: Alignment.centerRight, child: filters),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: searchField),
        const SizedBox(width: 16),
        filters,
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
          const SizedBox(width: 6),
          const Icon(LucideIcons.chevronDown, size: 12, color: AppColors.secondaryText),
        ],
      ),
    );
  }
}
