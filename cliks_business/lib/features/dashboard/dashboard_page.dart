import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/navigation/navigation_provider.dart';
import 'widgets/configure_quick_actions_dialog.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 850;
    final paddingVal = isMobile ? 16.0 : 28.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 24, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section (Books Console + Search Bar + Customise)
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // 2. Live Stat Cards (6 Live metrics matching image 1)
            _buildLiveStatCards(screenWidth).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // 3. Quick Action Center Section
            _buildQuickActionCenter(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 28),

            // 4. Main Body: Modules & Management Suite (Left) + Fund Segregation / Bills Banner (Right)
            if (isMobile) ...[
              _buildModulesSuite(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
              const SizedBox(height: 24),
              _buildFundSegregationCard(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 250.ms),
              const SizedBox(height: 24),
              _buildPersonalizedBillsBanner(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 300.ms),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildModulesSuite(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildFundSegregationCard(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 250.ms),
                        const SizedBox(height: 24),
                        _buildPersonalizedBillsBanner(context, isMobile).animate().fadeIn(duration: 500.ms, delay: 300.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            SizedBox(height: isMobile ? 110 : 36),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Header Section
  // ---------------------------------------------------------------------------
  Widget _buildHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Books Console',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF064E3B),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monitor your personal finance & operational intelligence suite.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile) ...[
              SizedBox(
                width: 260,
                height: 40,
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Find modules, assets...',
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                    prefixIcon: Icon(LucideIcons.search, size: 16, color: Colors.grey.shade400),
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF064E3B)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ConfigureQuickActionsDialog(),
                  );
                },
                icon: const Icon(LucideIcons.settings, size: 16),
                label: const Text('Customise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF064E3B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Find modules, assets...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      prefixIcon: Icon(LucideIcons.search, size: 16, color: Colors.grey.shade400),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF064E3B)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ConfigureQuickActionsDialog(),
                  );
                },
                icon: const Icon(LucideIcons.settings, size: 16),
                label: const Text('Customise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF064E3B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Live Stat Cards Grid (6 Stat Cards)
  // ---------------------------------------------------------------------------
  Widget _buildLiveStatCards(double screenWidth) {
    final isCompact = screenWidth < 500;
    final c1 = _LiveStatCard(
      icon: LucideIcons.arrowUpRight,
      iconColor: const Color(0xFF059669),
      iconBgColor: const Color(0xFFECFDF5),
      title: 'Total Income',
      value: '₹0',
      isCompact: isCompact,
      onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
    );
    final c2 = _LiveStatCard(
      icon: LucideIcons.arrowDownLeft,
      iconColor: const Color(0xFFEF4444),
      iconBgColor: const Color(0xFFFEF2F2),
      title: 'Total Expenses',
      value: '₹0',
      isCompact: isCompact,
      onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.expenses),
    );
    final c3 = _LiveStatCard(
      icon: LucideIcons.wallet,
      iconColor: const Color(0xFF059669),
      iconBgColor: const Color(0xFFECFDF5),
      title: 'Net Balance',
      value: '₹0',
      isCompact: isCompact,
      onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
    );
    final c4 = _LiveStatCard(
      icon: LucideIcons.piggyBank,
      iconColor: const Color(0xFF3B82F6),
      iconBgColor: const Color(0xFFEFF6FF),
      title: 'Active Investments',
      value: '₹0',
      isCompact: isCompact,
      onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.fintech),
    );
    final c5 = _LiveStatCard(
      icon: LucideIcons.users,
      iconColor: const Color(0xFFF97316),
      iconBgColor: const Color(0xFFFFF7ED),
      title: 'Active People',
      value: '1 Contacts',
      isCompact: isCompact,
      onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.people),
    );
    final c6 = _LiveStatCard(
      icon: LucideIcons.layers,
      iconColor: const Color(0xFF0D9488),
      iconBgColor: const Color(0xFFF0FDFA),
      title: 'Active Segregations',
      value: '0 Records',
      isCompact: isCompact,
      onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.segregation),
    );

    // Desktop view (>= 1000px): 4 columns in Row 1, 2 cards in Row 2 with empty slots
    if (screenWidth >= 1000) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: c1),
              const SizedBox(width: 16),
              Expanded(child: c2),
              const SizedBox(width: 16),
              Expanded(child: c3),
              const SizedBox(width: 16),
              Expanded(child: c4),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: c5),
              const SizedBox(width: 16),
              Expanded(child: c6),
              const SizedBox(width: 16),
              const Expanded(child: SizedBox()),
              const SizedBox(width: 16),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    }

    // Tablet or Mobile (< 1000px): 2 columns grid
    final spacing = isCompact ? 10.0 : 14.0;
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: c1),
            SizedBox(width: spacing),
            Expanded(child: c2),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(child: c3),
            SizedBox(width: spacing),
            Expanded(child: c4),
          ],
        ),
        SizedBox(height: spacing),
        Row(
          children: [
            Expanded(child: c5),
            SizedBox(width: spacing),
            Expanded(child: c6),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Quick Action Center Section
  // ---------------------------------------------------------------------------
  Widget _buildQuickActionCenter(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Action Center',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _ActionPillTile(
              label: 'Stock Management',
              icon: LucideIcons.layoutGrid,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.stock),
            ),
            _ActionPillTile(
              label: 'People Hub',
              icon: LucideIcons.users,
              iconBgColor: const Color(0xFFEFF6FF),
              iconColor: const Color(0xFF3B82F6),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.people),
            ),
            _ActionPillTile(
              label: 'Expenses',
              icon: LucideIcons.fileText,
              iconBgColor: const Color(0xFFFEF2F2),
              iconColor: const Color(0xFFEF4444),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.expenses),
            ),
            _ActionPillTile(
              label: 'Budgets & Planning',
              icon: LucideIcons.pieChart,
              iconBgColor: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFD97706),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
            ),
            _ActionPillTile(
              label: 'Split & Collect',
              icon: LucideIcons.wallet,
              iconBgColor: const Color(0xFFF0FDFA),
              iconColor: const Color(0xFF0D9488),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.splitCollect),
            ),
            _ActionPillTile(
              label: 'Segregation',
              icon: LucideIcons.layers,
              iconBgColor: const Color(0xFFF5F3FF),
              iconColor: const Color(0xFF8B5CF6),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.segregation),
            ),
          ],
        ),
        const SizedBox(height: 14),
        CustomPaint(
          painter: const _DashedRRectPainter(
            color: Color(0xFFCBD5E1),
            strokeWidth: 1.2,
            dash: 4.0,
            gap: 3.5,
            radius: 20.0,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => const ConfigureQuickActionsDialog(),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.plus, size: 14, color: Colors.grey.shade700),
                    const SizedBox(width: 6),
                    Text(
                      'Manage Shortcuts',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Modules & Management Suite Card
  // ---------------------------------------------------------------------------
  Widget _buildModulesSuite(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB).withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Modules & Management Suite',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 20),
          _ModuleSuiteRow(
            icon: LucideIcons.box,
            title: 'Inventory & Stocks',
            subtitle: 'Real-time overview of products, stock alerts, and individual restock thresholds.',
            onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.stock),
          ),
          const SizedBox(height: 14),
          _ModuleSuiteRow(
            icon: LucideIcons.users,
            title: 'People Hub',
            subtitle: 'Operational base for handling contacts, payables, receivables, and transactions.',
            onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.people),
          ),
          const SizedBox(height: 14),
          _ModuleSuiteRow(
            icon: LucideIcons.trendingUp,
            title: 'Finance',
            subtitle: 'Track personal income, fixed costs, and daily expenses with automatic balance calculation.',
            onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Fund Segregation Card
  // ---------------------------------------------------------------------------
  Widget _buildFundSegregationCard(BuildContext context, bool isMobile) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB).withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
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
              const Expanded(
                child: Text(
                  'Fund Segregation',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.segregation),
                borderRadius: BorderRadius.circular(6),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  child: Text(
                    'Manage',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF064E3B),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.wallet, color: Color(0xFF6366F1), size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE WALLETS',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '0 Established',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.plus, color: Color(0xFF059669), size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TARGET SAVED',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '₹0',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Personalized Bills & Splits Dark Green Banner Card
  // ---------------------------------------------------------------------------
  Widget _buildPersonalizedBillsBanner(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF033B26),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF033B26).withValues(alpha: 0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Positioned(
              right: -25,
              top: -25,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withValues(alpha: 0.12),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(isMobile ? 18 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Personalized Bills & Splits',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage complex bill cost splits among groups, monitor personal accounting logs, and reconcile joint statements.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.85),
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.splitCollect),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF033B26),
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              'View Joint Expenses',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(LucideIcons.arrowRight, size: 16),
                        ],
                      ),
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

// -----------------------------------------------------------------------------
// Live Stat Card Component
// -----------------------------------------------------------------------------
class _LiveStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String value;
  final bool isCompact;
  final VoidCallback? onTap;

  const _LiveStatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.value,
    this.isCompact = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final paddingAmount = isCompact ? 14.0 : 20.0;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(paddingAmount),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB).withValues(alpha: 0.6)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: isCompact ? 34 : 38,
                    height: isCompact ? 34 : 38,
                    decoration: BoxDecoration(
                      color: iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(icon, color: iconColor, size: isCompact ? 18 : 20),
                    ),
                  ),
                  const Text(
                    'Live',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isCompact ? 12 : 18),
              SizedBox(
                width: double.infinity,
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: isCompact ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Quick Action Pill Tile Component
// -----------------------------------------------------------------------------
class _ActionPillTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionPillTile({
    required this.label,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(icon, color: iconColor, size: 16),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Module Suite Row Component
// -----------------------------------------------------------------------------
class _ModuleSuiteRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ModuleSuiteRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F4F6)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Icon(icon, color: const Color(0xFF059669), size: 22),
              ),
            ),
            const SizedBox(width: 14),
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
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFFD1FAE5),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(LucideIcons.arrowRight, color: Color(0xFF059669), size: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Dashed Rounded Rectangle Painter for "+ Manage Shortcuts"
// -----------------------------------------------------------------------------
class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double dash;
  final double gap;
  final double radius;

  const _DashedRRectPainter({
    required this.color,
    this.strokeWidth = 1.2,
    this.dash = 4.0,
    this.gap = 3.5,
    this.radius = 20.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = (distance + dash > metric.length)
            ? metric.length - distance
            : dash;
        final extractPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(extractPath, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dash != dash ||
        oldDelegate.gap != gap ||
        oldDelegate.radius != radius;
  }
}
