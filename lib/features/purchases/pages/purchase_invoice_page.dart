import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../widgets/purchase_stat_card.dart';

class PurchaseInvoicePage extends ConsumerStatefulWidget {
  const PurchaseInvoicePage({super.key});

  @override
  ConsumerState<PurchaseInvoicePage> createState() => _PurchaseInvoicePageState();
}

class _PurchaseInvoicePageState extends ConsumerState<PurchaseInvoicePage> {
  int _activeTab = 0; // 0: PO, 1: Bills, 2: Returns

  final List<String> _tabs = [
    'Purchase Orders (PO)',
    'Purchase Bills & Invoices',
    'Returns (Debit Notes)',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.shoppingCart,
    LucideIcons.fileText,
    LucideIcons.undo2,
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
                color: const Color(0xFFD63384).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.shoppingBag, color: Color(0xFFD63384), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Purchases Hub',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage vendor procurement cycles, GST input tax credits, multi-warehouse receiving, and purchase returns.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildActionBtn(
          label: 'New PO',
          icon: LucideIcons.plus,
          color: const Color(0xFFD63384),
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.newPO),
        ),
        _buildActionBtn(
          label: 'New Purchase Bill',
          icon: LucideIcons.plus,
          color: const Color(0xFF0D6EFD),
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.newPurchaseBill),
        ),
        _buildActionBtn(
          label: 'Purchase Return',
          icon: LucideIcons.plus,
          color: const Color(0xFF7C3AED),
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.purchaseReturn),
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

  Widget _buildActionBtn({required String label, required IconData icon, required Color color, required VoidCallback onPressed}) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: color),
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color.withValues(alpha: 0.3)),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _buildStatGrid(bool isMobile) {
    final cards = [
      const PurchaseStatCard(
        title: 'OUTWARD PROCUREMENT (AT COST)',
        value: '₹0',
        icon: LucideIcons.trendingUp,
        iconColor: Color(0xFFD63384),
        trendIcon: LucideIcons.arrowUpRight,
      ),
      const PurchaseStatCard(
        title: 'ACTIVE PO CYCLES',
        value: '0',
        icon: LucideIcons.shoppingCart,
        iconColor: Color(0xFF0D6EFD),
      ),
      const PurchaseStatCard(
        title: 'CLAIMABLE INPUT TAX CREDIT (ITC)',
        value: '₹0',
        icon: LucideIcons.percent,
        iconColor: Color(0xFF7C3AED),
      ),
      const PurchaseStatCard(
        title: 'REFUND ADJUSTMENTS',
        value: '₹0',
        icon: LucideIcons.refreshCcw,
        iconColor: Color(0xFF10B981),
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

  Widget _buildTabsBar(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          final color = index == 2 ? const Color(0xFF7C3AED) : AppColors.darkText;
          
          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => setState(() => _activeTab = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? (index == 2 ? color : Colors.white) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isSelected ? (index == 2 ? color : AppColors.border) : AppColors.border),
                  boxShadow: isSelected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabIcons[index],
                      size: 16,
                      color: isSelected ? (index == 2 ? Colors.white : AppColors.darkText) : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelected ? (index == 2 ? Colors.white : AppColors.darkText) : AppColors.secondaryText,
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

  Widget _buildMainContent(bool isMobile) {
    String title = "";
    List<String> headers = [];
    String emptyMessage = "";
    IconData emptyIcon = LucideIcons.archive;

    switch (_activeTab) {
      case 0:
        title = "Purchase Orders Tracking";
        headers = ['PO ID', 'DATE', 'SUPPLIER', 'TOTAL VALUE', 'DUE DATE', 'STATUS', 'ACTIONS'];
        emptyMessage = "No active purchase orders found.";
        break;
      case 1:
        title = "Purchase Bills Register";
        headers = ['BILL ID', 'VENDOR', 'INVOICE REF', 'BILL AMOUNT', 'TAX', 'PAYMENT', 'STATUS'];
        emptyMessage = "No purchase bills recorded.";
        break;
      case 2:
        title = "Purchase Returns & Debit Notes";
        headers = ['RETURN ID', 'REF BILL', 'SUPPLIER', 'REASON', 'ITEMS RETURNED', 'REFUND VALUE'];
        emptyMessage = "No active replacement claims found in system database.";
        emptyIcon = LucideIcons.undo2;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
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
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
          ),
          const SizedBox(height: 32),
          _buildTableOrList(isMobile, headers, emptyMessage, emptyIcon),
        ],
      ),
    );
  }

  Widget _buildTableOrList(bool isMobile, List<String> headers, String emptyMessage, IconData emptyIcon) {
    if (isMobile) {
      return Container(
        height: 160,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: 40, color: AppColors.secondaryText.withValues(alpha: 0.4)),
            const SizedBox(height: 12),
            Text(
              emptyMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
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
                  h.toUpperCase(),
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
