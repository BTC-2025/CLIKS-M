import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../../../widgets/app_ui_kit.dart';

class ProductsPage extends ConsumerStatefulWidget {
  const ProductsPage({super.key});

  @override
  ConsumerState<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends ConsumerState<ProductsPage> {
  int _activeTab = 0; // 0: Products & Services List, 1: Movement History, 2: Advanced Profit

  final List<String> _tabs = [
    'Products & Services List',
    'Movement History & Logs',
    'Advanced Profit & Expiry',
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
              child: const Icon(LucideIcons.box, color: Color(0xFFD63384), size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Products & Inventory Suite',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage product specifications, service offerings, batch expiries, warehouses, and valuations.',
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
            AppSnackbar.show(
              context,
              "Opening CSV bulk import sheet. Please choose product template file.",
              type: SnackType.info,
            );
          },
          icon: const Icon(LucideIcons.uploadCloud, size: 14),
          label: const Text('Bulk Import (CSV)', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkText,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.registerProduct),
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('Add Product / Service', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD63384),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        title: 'STOCK VALUATION (COST)',
        value: '₹0',
        icon: LucideIcons.trendingUp,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: 'LOW STOCK SKU ALERTS',
        value: '0',
        icon: LucideIcons.alertTriangle,
        iconColor: const Color(0xFFDC3545),
        bgColor: const Color(0xFFFFF5F5),
      ),
      _buildStatCard(
        title: 'TOTAL CATALOG SKUS',
        value: '0',
        icon: LucideIcons.layers,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: 'TOTAL PHYSICAL UNITS',
        value: '0',
        icon: LucideIcons.box,
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(_tabs[index]),
              selected: isSelected,
              onSelected: (val) {
                if (val) setState(() => _activeTab = index);
              },
              selectedColor: const Color(0xFFD63384).withValues(alpha: 0.12),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFFD63384) : AppColors.secondaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isSelected ? const Color(0xFFD63384) : AppColors.border),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    if (_activeTab == 1) {
      return _buildMovementHistory(isMobile);
    }
    if (_activeTab == 2) {
      return _buildAdvancedProfit(isMobile);
    }

    return Container(
      padding: const EdgeInsets.all(16),
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
          // Filter Bar Row
          _buildFilterRow(isMobile),
          const SizedBox(height: 20),

          // Table list
          _buildTableOrList(isMobile),
        ],
      ),
    );
  }

  Widget _buildMovementHistory(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Movement & Stock Audits',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F5B2E)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Full ledger recording additions, sales deductions, and opening inductions.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              constraints: const BoxConstraints(minWidth: 800),
              child: Table(
                columnWidths: const {
                  0: FlexColumnWidth(1),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(1.5),
                  3: FlexColumnWidth(1.5),
                  4: FlexColumnWidth(1.5),
                  5: FlexColumnWidth(1),
                },
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppColors.border)),
                    ),
                    children: ['TIMESTAMP', 'PRODUCT NAME', 'MOVEMENT TYPE', 'REF / REASON', 'WAREHOUSE LOCATION', 'QUANTITY SHIFTED'].map((h) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                      child: Text(h, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                    )).toList(),
                  ),
                  _buildMovementRow('2026-05-01', 'iPhone 15 (128GB, Black)', 'IN (PURCHASE)', 'Bill #PUR-901', 'Main Godown', '+ 25 Units', Colors.green),
                  _buildMovementRow('2026-05-03', 'iPhone 15 (128GB, Black)', 'OUT (SALES)', 'Invoice #INV-201', 'Main Godown', '- 5 Units', Colors.red),
                  _buildMovementRow('2026-05-04', 'Ergonomic Mesh Office Chair', 'OUT (SALES)', 'Invoice #INV-244', 'Shop Front', '- 15 Units', Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _buildMovementRow(String date, String name, String type, String ref, String location, String qty, Color qtyColor) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      children: [
        _tableCell(date),
        _tableCell(name, isBold: true),
        _tableCell(type, color: type.contains('IN') ? Colors.green : Colors.red),
        _tableCell(ref),
        _tableCell(location),
        _tableCell(qty, color: qtyColor, isBold: true),
      ],
    );
  }

  Widget _tableCell(String text, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          color: color ?? AppColors.darkText,
        ),
      ),
    );
  }

  Widget _buildAdvancedProfit(bool isMobile) {
    return Column(
      children: [
        if (!isMobile)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: _buildAdvancedMainLeft()),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: _buildAdvancedMainRight()),
            ],
          )
        else ...[
          _buildAdvancedMainLeft(),
          const SizedBox(height: 24),
          _buildAdvancedMainRight(),
        ],
      ],
    );
  }

  Widget _buildAdvancedMainLeft() {
    return Column(
      children: [
        _buildInfoCard(
          title: 'Batch Expiry & Dead Stock Trackers',
          icon: LucideIcons.alertCircle,
          iconColor: Colors.red,
          content: const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text('No active product expiries logged.', style: TextStyle(color: AppColors.secondaryText)),
            ),
          ),
        ),
        const SizedBox(height: 24),
        _buildInfoCard(
          title: 'Product-wise Profitability Margins',
          icon: LucideIcons.trendingUp,
          iconColor: Colors.green,
          content: const SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildAdvancedMainRight() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0F5B2E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Stock Valuation Summary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 32),
              _buildValuationRow('Asset Valuation (At Cost):', '₹0'),
              const SizedBox(height: 16),
              _buildValuationRow('Potential Revenue (At Sale):', '₹0'),
              const Divider(height: 48, color: Colors.white24),
              _buildValuationRow('Unrealized Profit Pool:', '₹0', isLarge: true),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildInfoCard(
          title: 'Fast Moving Products',
          icon: LucideIcons.zap,
          iconColor: Colors.green,
          content: const SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildValuationRow(String label, String value, {bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: isLarge ? 14 : 12)),
        Text(value, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: isLarge ? 20 : 16)),
      ],
    );
  }

  Widget _buildInfoCard({required String title, required IconData icon, required Color iconColor, required Widget content}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 12),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 16),
          content,
        ],
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
                hintText: 'Search by name, SKU or barcode...',
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
        _buildDropdown('All Stock Status'),
        const SizedBox(width: 6),
        _buildDropdown('All Categories'),
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
        const SizedBox(width: 12),
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

  Widget _buildTableOrList(bool isMobile) {
    final headers = [
      'PRODUCT DETAILS',
      'CLASSIFICATION',
      'STOCK LEVEL',
      'PRICE',
      'GST & HSN',
      'STATUS',
      'STOCK ACTIONS',
    ];

    if (isMobile) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.box, size: 40, color: AppColors.secondaryText.withValues(alpha: 0.4)),
            const SizedBox(height: 10),
            const Text(
              'No products matched.',
              style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
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
          columnWidths: const {
            0: FlexColumnWidth(1.8),
            1: FlexColumnWidth(1.2),
            2: FlexColumnWidth(1.2),
            3: FlexColumnWidth(1.2),
            4: FlexColumnWidth(1.2),
            5: FlexColumnWidth(1.0),
            6: FlexColumnWidth(1.2),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
              ),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                child: Text(
                  h,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                ),
              )).toList(),
            ),
            TableRow(
              children: List.generate(headers.length, (idx) {
                if (idx == 0) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Text('No cataloged products found.', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
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
