import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/navigation_provider.dart';

class ReturnsPage extends ConsumerStatefulWidget {
  const ReturnsPage({super.key});

  @override
  ConsumerState<ReturnsPage> createState() => _ReturnsPageState();
}

class _ReturnsPageState extends ConsumerState<ReturnsPage> {
  int _activeTab = 0; // 0: Sales Returns, 1: Purchase Returns, 2: Warranty & Replacement Claims

  final List<String> _tabs = [
    'Sales Returns (Customers)',
    'Purchase Returns (Suppliers)',
    'Warranty & Replacement Claims',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.fileText,
    LucideIcons.shoppingCart,
    LucideIcons.award,
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE289F2).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.undo, color: Color(0xFFD63384), size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Returns & Debit Notes',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage customer sales returns, defective supplier returns, replacements, credit notes, and damage segregation.',
          style: TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.newCustomerReturn);
          },
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('+ New Customer Return', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD63384),
            side: const BorderSide(color: Color(0xFFF8D7DA)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.newSupplierReturn);
          },
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('+ New Supplier Return', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF0D6EFD),
            side: const BorderSide(color: Color(0xFFD6E4FF)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          const SizedBox(height: 12),
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
        title: 'CUSTOMER REFUNDS (SALES)',
        value: '₹0',
        icon: LucideIcons.trendingDown,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: 'RECOVERED FROM SUPPLIERS',
        value: '₹0',
        icon: LucideIcons.refreshCcw,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: 'PENDING INSPECTIONS',
        value: '0',
        icon: LucideIcons.shieldAlert,
        iconColor: const Color(0xFFF2C94C),
        bgColor: const Color(0xFFFFF9E6),
      ),
      _buildStatCard(
        title: 'STOCK RECALCULATIONS',
        value: 'Active',
        icon: LucideIcons.lineChart,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
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
    final isMobileWidth = MediaQuery.of(context).size.width < 600;

    if (isMobileWidth) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.005), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
              child: Icon(icon, color: iconColor, size: 12),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

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
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          final Color activeColor = index == 2 ? const Color(0xFF7C3AED) : const Color(0xFFD63384);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              avatar: Icon(
                _tabIcons[index],
                size: 14,
                color: isSelected ? Colors.white : AppColors.secondaryText,
              ),
              label: Text(_tabs[index]),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _activeTab = index);
              },
              selectedColor: activeColor,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.secondaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isSelected ? activeColor : AppColors.border),
              ),
              showCheckmark: false,
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    String title = "";
    List<String> headers = [];
    String emptyMessage = "";
    IconData emptyIcon = LucideIcons.archive;
    Widget? infoBanner;

    switch (_activeTab) {
      case 0: // Sales Returns
        title = "Customer Sales Returns Log";
        headers = ['RETURN REF', 'ORIGINAL INV', 'CUSTOMER', 'ITEMS RETURNED', 'REFUND MODE', 'INSPECTION', 'STATUS'];
        emptyMessage = "No product returns registered.";
        break;
      case 1: // Purchase Returns
        title = "Supplier Defective Returns tracking";
        headers = ['DEBIT NOTE NO', 'VENDOR NAME', 'PURCHASE REF', 'RETURN VALUE', 'SETTLEMENT', 'LOGISTICS', 'STATUS'];
        emptyMessage = "No supplier returns recorded.";
        emptyIcon = LucideIcons.shoppingCart;
        break;
      case 2: // Warranty
        title = "Warranty & Replacements Tracking";
        headers = ['Warranty ID', 'Customer Name', 'Product Description', 'Exchange Qty', 'Action Status'];
        emptyMessage = "No active replacement claims found in system database.";
        emptyIcon = LucideIcons.wrench;
        infoBanner = Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF7ED),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFFFEDD5)),
          ),
          child: const Text(
            'When products are returned as defective under warranty, they are marked for replacement. Our inventory automatically tracks exchange replacement stock separately to prevent margin dilution.',
            style: TextStyle(fontSize: 13, color: Color(0xFF9A3412), height: 1.5),
          ),
        );
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _activeTab == 2 ? LucideIcons.wrench : LucideIcons.list,
                color: _activeTab == 2 ? const Color(0xFF10B981) : AppColors.darkText,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ?infoBanner,
          _buildTableOrList(isMobile, headers, emptyMessage, emptyIcon),
        ],
      ),
    );
  }

  Widget _buildTableOrList(bool isMobile, List<String> headers, String emptyMessage, IconData emptyIcon) {
    if (isMobile) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 40, color: AppColors.secondaryText.withValues(alpha: 0.4)),
            const SizedBox(height: 10),
            Text(
              emptyMessage,
              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: const BoxConstraints(minWidth: 900),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
              ),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Text(
                  h,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                ),
              )).toList(),
            ),
            TableRow(
              children: List.generate(headers.length, (idx) {
                if (idx == (headers.length / 2).floor()) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: Text(emptyMessage, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText))),
                  );
                }
                return const SizedBox();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
