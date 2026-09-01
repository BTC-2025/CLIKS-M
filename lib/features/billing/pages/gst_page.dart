import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../widgets/verify_invoice_dialog.dart';
import '../widgets/dispatch_bill_dialog.dart';

class GstPage extends ConsumerStatefulWidget {
  const GstPage({super.key});

  @override
  ConsumerState<GstPage> createState() => _GstPageState();
}

class _GstPageState extends ConsumerState<GstPage> {
  int _activeTab = 0; // 0: GSTR-1, 1: GSTR-2, 2: GSTR-3B, 3: GSTR-9, 4: e-Invoice, 5: e-Way Logistics

  final List<String> _tabs = [
    'GSTR-1 (Sales)',
    'GSTR-2 (Purchase)',
    'GSTR-3B (Liability)',
    'GSTR-9 (Annual)',
    'e-Invoice',
    'e-Way Logistics',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.fileText,
    LucideIcons.refreshCw,
    LucideIcons.checkCircle2,
    LucideIcons.award,
    LucideIcons.fileDigit,
    LucideIcons.truck,
  ];

  Color _getTabColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFD63384); // Pink/Sales
      case 1: return const Color(0xFF2563EB); // Blue/Purchase
      case 2: return const Color(0xFF7C3AED); // Purple/Liability
      case 3: return const Color(0xFFF59E0B); // Orange/Annual
      case 4: return const Color(0xFF6366F1); // Indigo/e-Invoice
      case 5: return const Color(0xFF10B981); // Teal/Logistics
      default: return AppColors.primaryGreen;
    }
  }

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

            // GSTIN Configuration Banner
            _buildGstinBanner(isMobile).animate().fadeIn(duration: 400.ms, delay: 50.ms),
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
              child: const Icon(LucideIcons.percent, color: Color(0xFFD63384), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'GST & Tax Compliance',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Prepare returns, authenticate IRN e-Invoices, dispatch e-Way Bills, and reconcile purchase ITC.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.generateEWayBill);
          },
          icon: const Icon(LucideIcons.filePlus, size: 16),
          label: const Text('Generate e-Way Bill'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD63384),
            side: const BorderSide(color: Color(0xFFF8D7DA)),
            backgroundColor: const Color(0xFFFFF3CD).withValues(alpha: 0.2),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.generateEInvoice);
          },
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Generate e-Invoice'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD63384),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildGstinBanner(bool isMobile) {
    final textWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Government GSTIN Registered',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0D6EFD)),
        ),
        const SizedBox(height: 4),
        Text(
          'Legal Name: Business Registration Pending | Type: Pending',
          style: TextStyle(fontSize: 12, color: Colors.blueGrey.shade700),
        ),
      ],
    );

    final rightWidget = Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        const Text(
          'GSTIN NOT CONFIGURED',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0D6EFD)),
        ),
        const SizedBox(height: 4),
        Text(
          'Place of Supply Code: -- (Location Unspecified)',
          style: TextStyle(fontSize: 11, color: Colors.blueGrey.shade600),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F0FE).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD6E4FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(color: Color(0xFFD6E4FF), shape: BoxShape.circle),
            child: const Icon(LucideIcons.landmark, color: Color(0xFF0D6EFD), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      textWidget,
                      const SizedBox(height: 12),
                      rightWidget,
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: textWidget),
                      const SizedBox(width: 16),
                      rightWidget,
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards(bool isMobile) {
    final cards = [
      _buildStatCard(
        title: 'TOTAL OUTPUT GST COLLECTED',
        value: '₹0',
        icon: LucideIcons.trendingUp,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: 'ELIGIBLE ITC (CLAIMED GSTR-2B)',
        value: '₹0',
        icon: LucideIcons.trendingDown,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
      ),
      _buildStatCard(
        title: 'NET GST PAYABLE LIABILITY',
        value: '₹0',
        icon: LucideIcons.alertTriangle,
        iconColor: const Color(0xFFDC3545),
        bgColor: const Color(0xFFFFF5F5),
      ),
      _buildStatCard(
        title: 'CUMULATIVE TAXABLE SALES',
        value: '₹0',
        icon: LucideIcons.fileText,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
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
          final color = _getTabColor(index);
          
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
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
                    const SizedBox(width: 8),
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

  Widget _buildMainContent(bool isMobile) {
    Widget content;
    String title = "";
    Widget? actionButton;
    List<String> headers = [];
    String emptyMessage = "";
    IconData emptyIcon = LucideIcons.percent;

    switch (_activeTab) {
      case 0: // GSTR-1
        title = "GSTR-1 Sales Return filings";
        headers = ['INVOICE NO', 'TYPE', 'PLACE OF SUPPLY', 'TAXABLE VALUE', 'CGST/SGST', 'IGST', 'TOTAL GST', 'STATUS', 'ACTIONS'];
        emptyMessage = "No recorded GST transactions.";
        break;
      case 1: // GSTR-2
        title = "GSTR-2B Purchase ITC Reconciliations";
        actionButton = _buildTableActionButton("Verify Vendor Invoice", const Color(0xFF2563EB), () {
          showDialog(
            context: context,
            builder: (context) => const VerifyInvoiceDialog(),
          );
        });
        headers = ['VENDOR GSTIN', 'VENDOR NAME', 'INVOICE WORTH', 'CALCULATED CGST/SGST', 'ELIGIBLE ITC', 'STATUS', 'ACTIONS'];
        emptyMessage = "No purchase reconciliations found.";
        emptyIcon = LucideIcons.refreshCw;
        break;
      case 2: // GSTR-3B
        return _buildAggregatingContent("Aggregating return summaries... If the service is temporarily unavailable, please verify connection.");
      case 3: // GSTR-9
        return _buildAggregatingContent("Compiling annual GSTR-9 consolidated return data... If the service is temporarily unavailable, please verify backend connectivity.");
      case 4: // e-Invoice
        title = "Government IRN e-Invoice Authentication";
        headers = ['IRN NO', 'INVOICE REF', 'CLIENT', 'AUTH DATE', 'QR CODE', 'STATUS', 'ACTIONS'];
        emptyMessage = "No e-invoices generated.";
        emptyIcon = LucideIcons.fileText;
        break;
      case 5: // e-Way Logistics
        title = "Government e-Way Bills Transport tracking";
        actionButton = _buildTableActionButton("Dispatch New Bill", const Color(0xFF2563EB), () {
          showDialog(
            context: context,
            builder: (context) => const DispatchBillDialog(),
          );
        });
        headers = ['e-Way Bill No', 'Carrier Name', 'Vehicle Registration No', 'Distance (Kms)', 'Source - Destination', 'Status', 'Actions'];
        emptyMessage = "No active transport bills.";
        emptyIcon = LucideIcons.truck;
        break;
      default:
        title = "GST Data";
        headers = [];
        emptyMessage = "No data available.";
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
              ),
              if (actionButton != null && !isMobile) actionButton,
            ],
          ),
          if (actionButton != null && isMobile) ...[
            const SizedBox(height: 12),
            actionButton,
          ],
          const SizedBox(height: 20),
          _buildSearchRow(isMobile),
          const SizedBox(height: 20),
          _buildDynamicTable(isMobile, headers, emptyMessage, emptyIcon),
        ],
      ),
    );
  }

  Widget _buildTableActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildAggregatingContent(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppColors.secondaryText),
        ),
      ),
    );
  }

  Widget _buildDynamicTable(bool isMobile, List<String> headers, String emptyMessage, IconData emptyIcon) {
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
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
              ),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(
                  h.toUpperCase(),
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                ),
              )).toList(),
            ),
            TableRow(
              children: List.generate(headers.length, (idx) {
                if (idx == (headers.length / 2).floor()) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(emptyMessage, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
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

  Widget _buildSearchRow(bool isMobile) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          SizedBox(width: 10),
          Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search records...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTableOrList(bool isMobile) {
    // This is replaced by _buildDynamicTable in _buildMainContent
    return const SizedBox.shrink();
  }
}
