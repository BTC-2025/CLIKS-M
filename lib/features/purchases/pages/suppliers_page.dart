import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';

class SuppliersPage extends ConsumerStatefulWidget {
  const SuppliersPage({super.key});

  @override
  ConsumerState<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends ConsumerState<SuppliersPage> {
  int _activeTab = 0; // 0: Master Base, 1: Ledger, 2: Aging

  final List<String> _tabs = [
    'Suppliers Master Base',
    'Running Ledger Statements',
    'Payables Aging & Reminders',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.users,
    LucideIcons.fileText,
    LucideIcons.alertTriangle,
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
            _buildStatGrid(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // Tabs bar
            _buildTabsBar(isMobile).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 24),

            // Main Data content
            _buildMainContent(isMobile, screenWidth).animate().fadeIn(duration: 500.ms, delay: 200.ms),
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
              child: const Icon(LucideIcons.users, color: Color(0xFFD63384), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Suppliers Master Suite',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage vendor demographics, credit limits, purchase ledgers, and outward payables aging summaries.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionBtn(
          label: 'Bulk Import (CSV)',
          icon: LucideIcons.uploadCloud,
          color: AppColors.darkText,
          onPressed: () {},
        ),
        _buildActionBtn(
          label: 'Register New Supplier',
          icon: LucideIcons.plus,
          color: Colors.white,
          bgColor: const Color(0xFFD63384),
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.registerSupplier),
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

  Widget _buildActionBtn({required String label, required IconData icon, required Color color, Color? bgColor, required VoidCallback onPressed}) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor ?? Colors.white,
        foregroundColor: color,
        elevation: 0,
        side: bgColor == null ? const BorderSide(color: AppColors.border) : BorderSide.none,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildStatGrid(bool isMobile) {
    final cards = [
      _buildStatCard(
        title: 'OUTSTANDING PAYABLES',
        value: '₹0',
        icon: LucideIcons.trendingUp,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: 'ADVANCE SUPPLIER OUTFLOWS',
        value: '₹0',
        icon: LucideIcons.checkCircle,
        iconColor: const Color(0xFF10B981),
        bgColor: const Color(0xFFE6F4EA),
      ),
      _buildStatCard(
        title: 'TOTAL PROCURED VALUE',
        value: '₹0',
        icon: LucideIcons.layers,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: 'REGISTERED SUPPLIERS',
        value: '0',
        icon: LucideIcons.users,
        iconColor: const Color(0xFF7C3AED),
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
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards.map((c) => SizedBox(width: (constraints.maxWidth - 48) / 4, child: c)).toList(),
        );
      },
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color iconColor, required Color bgColor}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
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
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsBar(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          final color = index == 0 ? const Color(0xFFD63384) : (index == 1 ? const Color(0xFF2563EB) : const Color(0xFF7C3AED));
          
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => setState(() => _activeTab = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isSelected ? color : AppColors.border),
                  boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabIcons[index],
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.secondaryText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, double screenWidth) {
    switch (_activeTab) {
      case 0: return _buildMasterBaseView(isMobile);
      case 1: return _buildLedgerView(isMobile);
      case 2: return _buildAgingView(isMobile, screenWidth);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildMasterBaseView(bool isMobile) {
    final searchField = Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: const Row(
        children: [
          Icon(LucideIcons.search, size: 18, color: AppColors.secondaryText),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search suppliers, company or contact person...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );

    final filterDropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('All', style: TextStyle(fontSize: 13, color: AppColors.darkText)),
          SizedBox(width: 8),
          Icon(LucideIcons.chevronDown, size: 14),
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          isMobile
              ? Column(
                  children: [
                    searchField,
                    const SizedBox(height: 12),
                    Align(alignment: Alignment.centerRight, child: filterDropdown),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: searchField),
                    const SizedBox(width: 12),
                    filterDropdown,
                  ],
                ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: const BoxConstraints(minWidth: 1000),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
                    ),
                    children: [
                      'SUPPLIER DETAILS', 'DEMOGRAPHICS', 'GST & HSN', 'CREDIT LIMITS', 'RUNNING PAYABLE', 'STATUS', 'ACTIONS'
                    ].map((h) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(h, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                    )).toList(),
                  ),
                  TableRow(
                    children: List.generate(7, (idx) => const SizedBox(height: 100)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerView(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isMobile)
          Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            padding: const EdgeInsets.all(20),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Select Supplier', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Spacer(),
              ],
            ),
          ),
        if (!isMobile) const SizedBox(width: 24),
        Expanded(
          child: Container(
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.fileText, size: 48, color: AppColors.border.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  const Text(
                    'Select a supplier from the left sidebar to view their full statement ledger.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgingView(bool isMobile, double screenWidth) {
    final agingBuckets = [
      {'label': '0-30 Days Overdue Bucket', 'value': '₹85,000', 'color': const Color(0xFFFFF1F2), 'textColor': const Color(0xFFE11D48)},
      {'label': '31-60 Days Overdue Bucket', 'value': '₹35,000', 'color': const Color(0xFFFFFBEB), 'textColor': const Color(0xFFD97706)},
      {'label': '61-90+ Days Overdue Bucket', 'value': '₹0', 'color': const Color(0xFFF0FDF4), 'textColor': const Color(0xFF059669)},
    ];

    final mainColumn = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Outstanding Payables Aging Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ...agingBuckets.map((b) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: b['color'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        b['label'] as String, 
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          color: b['textColor'] as Color,
                          fontSize: isMobile ? 12 : 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      b['value'] as String, 
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16, 
                        fontWeight: FontWeight.w900, 
                        color: b['textColor'] as Color,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: const Text('Supplier Procurement Shares', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
      ],
    );

    final sidebar = Container(
      width: isMobile ? double.infinity : 300,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(24),
      child: const Text('Payment Follow-up Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );

    if (isMobile) {
      return Column(
        children: [
          mainColumn,
          const SizedBox(height: 24),
          sidebar,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: mainColumn),
        const SizedBox(width: 24),
        sidebar,
      ],
    );
  }
}
