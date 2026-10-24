import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/navigation/navigation_provider.dart';

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
    final paddingVal = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Section (Books Console + Search Bar)
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 20),

            // 2. Quick Action Center Section (Right after search bar)
            _buildQuickActionCenter(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // 3. Live Stat Cards Row
            _buildLiveStatCards(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 28),

            // 4. Main Body: Modules & Management Suite (Left) + Fund Segregation / Bills Banner (Right)
            if (isMobile) ...[
              _buildModulesSuite(context).animate().fadeIn(duration: 500.ms, delay: 200.ms),
              const SizedBox(height: 24),
              _buildFundSegregationCard(context).animate().fadeIn(duration: 500.ms, delay: 250.ms),
              const SizedBox(height: 24),
              _buildPersonalizedBillsBanner(context).animate().fadeIn(duration: 500.ms, delay: 300.ms),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: _buildModulesSuite(context).animate().fadeIn(duration: 500.ms, delay: 200.ms),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        _buildFundSegregationCard(context).animate().fadeIn(duration: 500.ms, delay: 250.ms),
                        const SizedBox(height: 24),
                        _buildPersonalizedBillsBanner(context).animate().fadeIn(duration: 500.ms, delay: 300.ms),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
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
                      color: AppColors.darkText,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Monitor your personal finance & operational intelligence suite.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryText.withValues(alpha: 0.9),
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
                      borderSide: BorderSide(color: Colors.grey.shade200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF0F5132)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.sliders, size: 16),
                label: const Text('Customise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFF0F5132)),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.sliders, size: 16),
                label: const Text('Customise', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
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
  // 2. Top 3 Live Stat Cards Row
  // ---------------------------------------------------------------------------
  Widget _buildLiveStatCards(bool isMobile) {
    const c1 = _LiveStatCard(
      width: double.infinity,
      icon: LucideIcons.box,
      title: 'Asset Inventory Value',
      value: '₹0',
    );
    const c2 = _LiveStatCard(
      width: double.infinity,
      icon: LucideIcons.wallet,
      title: 'Segregated Funds Total',
      value: '₹0',
    );
    const c3 = _LiveStatCard(
      width: double.infinity,
      icon: LucideIcons.split,
      title: 'Split Shared Costs',
      value: '₹0',
    );

    if (isMobile) {
      return const Column(
        children: [
          Row(
            children: [
              Expanded(child: c1),
              SizedBox(width: 12),
              Expanded(child: c2),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: c3),
              SizedBox(width: 12),
              Expanded(child: SizedBox()),
            ],
          ),
        ],
      );
    }

    return const Row(
      children: [
        Expanded(child: c1),
        SizedBox(width: 16),
        Expanded(child: c2),
        SizedBox(width: 16),
        Expanded(child: c3),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Quick Action Center
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
              label: 'Inventory & Assets',
              icon: LucideIcons.box,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.stock),
            ),
            _ActionPillTile(
              label: 'People Hub',
              icon: LucideIcons.users,
              iconBgColor: const Color(0xFFEEF2FF),
              iconColor: const Color(0xFF4F46E5),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.people),
            ),
            _ActionPillTile(
              label: 'Add Expense',
              icon: LucideIcons.trendingUp,
              iconBgColor: const Color(0xFFFEF2F2),
              iconColor: const Color(0xFFDC2626),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.recordExpense),
            ),
            _ActionPillTile(
              label: 'Budgets & Limits',
              icon: LucideIcons.activity,
              iconBgColor: const Color(0xFFFDF2F8),
              iconColor: const Color(0xFFDB2777),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
            ),
            _ActionPillTile(
              label: 'Split Costs',
              icon: LucideIcons.split,
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFD97706),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.splitCollect),
            ),
            _ActionPillTile(
              label: 'Fund Segregation',
              icon: LucideIcons.target,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF10B981),
              onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.segregation),
            ),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.plus, size: 14, color: Colors.grey.shade700),
                const SizedBox(width: 6),
                Text(
                  'Manage Shortcuts',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Modules & Management Suite Card
  // ---------------------------------------------------------------------------
  Widget _buildModulesSuite(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
  Widget _buildFundSegregationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Fund Segregation',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              InkWell(
                onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.segregation),
                child: const Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F5132),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.wallet, color: Color(0xFF6366F1), size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ACTIVE WALLETS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 2),
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
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.plus, color: Color(0xFF059669), size: 20),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TARGET SAVED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 2),
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
  Widget _buildPersonalizedBillsBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          const Text(
            'Manage complex bill cost splits among groups, monitor personal accounting logs, and reconcile joint statements.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.white70,
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Joint Expenses',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
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
    );
  }
}

// -----------------------------------------------------------------------------
// Live Stat Card Component
// -----------------------------------------------------------------------------
class _LiveStatCard extends StatelessWidget {
  final double width;
  final IconData icon;
  final String title;
  final String value;

  const _LiveStatCard({
    required this.width,
    required this.icon,
    required this.title,
    required this.value,
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
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: const Color(0xFF059669), size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Live',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF059669),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
          ),
        ],
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
          ],
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF059669), size: 22),
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
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFECFDF5),
                shape: BoxShape.circle,
              ),
              child: const Icon(LucideIcons.arrowRight, color: Color(0xFF059669), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
