import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';

class WarehousePage extends ConsumerStatefulWidget {
  const WarehousePage({super.key});

  @override
  ConsumerState<WarehousePage> createState() => _WarehousePageState();
}

class _WarehousePageState extends ConsumerState<WarehousePage> {
  int _activeTab = 0; // 0: Registered Godowns & Locations, 1: Warehouse Stock Registry, 2: Goods Inward Historical logs, 3: Inter-Warehouse Transfers

  final List<String> _tabs = [
    'Registered Godowns & Locations',
    'Warehouse Stock Registry',
    'Goods Inward Historical logs',
    'Inter-Warehouse Transfers',
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
              child: const Icon(LucideIcons.warehouse, color: Color(0xFFD63384), size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Warehouse, Godowns & Logistics',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage multiple physical godowns, branch storage facilities, inter-warehouse transfers, rack zones, and inward receipts.',
          style: TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.goodsInwardReceipt),
          icon: const Icon(LucideIcons.fileInput, size: 14),
          label: const Text('Goods Inward Receiving', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD63384),
            side: const BorderSide(color: Color(0xFFF8D7DA)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.registerWarehouse),
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('Register Warehouse', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
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
        title: 'Active',
        subtitle: 'ACTIVE GODOWN FACILITIES',
        value: '0',
        icon: LucideIcons.home,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: 'MULTI-WAREHOUSE WORTH',
        subtitle: 'STOCK VALUE TOTAL',
        value: '₹0',
        icon: LucideIcons.dollarSign,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
      ),
      _buildStatCard(
        title: 'Unsent',
        subtitle: 'PENDING SHIPMENTS',
        value: '0',
        icon: LucideIcons.truck,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: 'Records',
        subtitle: 'INWARD RECEIPTS AUDITED',
        value: '0',
        icon: LucideIcons.fileText,
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
    required String subtitle,
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
                    style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: iconColor),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 7.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: iconColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
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
              selectedColor: const Color(0xFF0D6EFD).withValues(alpha: 0.12),
              backgroundColor: Colors.white,
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF0D6EFD) : AppColors.secondaryText,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: isSelected ? const Color(0xFF0D6EFD) : AppColors.border),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          if (_activeTab == 0) _buildLocationsView(isMobile),
          if (_activeTab == 1) _buildStockRegistryView(isMobile),
          if (_activeTab == 2) _buildInwardAuditView(isMobile),
          if (_activeTab == 3) _buildInterTransferView(isMobile),
        ],
      ),
    );
  }

  Widget _buildLocationsView(bool isMobile) {
    final headers = ['FACILITY NAME', 'CODE', 'TYPE', 'CITY / STATE', 'CAPACITY', 'MANAGER', 'STATUS'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Registered Godowns & Facility Locations', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5B2E))),
        const SizedBox(height: 24),
        _buildTable(headers, isMobile, 'No godowns registered yet.'),
      ],
    );
  }

  Widget _buildStockRegistryView(bool isMobile) {
    final headers = ['WAREHOUSE FACILITY', 'PRODUCT DESCRIPTION', 'STORAGE ZONE', 'CURRENT STOCK', 'DAMAGED QTY', 'IN TRANSIT', 'SOURCING VALUATION'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Warehouse Stock Registry', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5B2E))),
        const SizedBox(height: 24),
        _buildTable(headers, isMobile, 'No recorded inventory in facilities.'),
      ],
    );
  }

  Widget _buildInwardAuditView(bool isMobile) {
    final headers = ['INWARD ID', 'PURCHASE BILL REF', 'PRODUCT DESCRIPTION', 'RECEIVED QTY', 'RECEIVED BY', 'DATE RECEIVED', 'DESTINATION WAREHOUSE'];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Goods Inwards Audit Trail', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5B2E))),
        const SizedBox(height: 24),
        _buildTable(headers, isMobile, 'No inward receipts audited.'),
      ],
    );
  }

  Widget _buildInterTransferView(bool isMobile) {
    final headers = ['TRANSFER ID', 'FROM FACILITY', 'TO FACILITY', 'PRODUCT DESCRIPTION', 'TRANSFER QTY', 'LOGISTICS CARRIER / TRACK ID', 'STATUS', 'LAND SHIPMENT'];
    
    final headerAction = ElevatedButton.icon(
      onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.interWarehouseTransfer),
      icon: const Icon(LucideIcons.plus, size: 14),
      label: const Text('Inter-Warehouse Transfer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0F5B2E),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Branch Dispatch & Inter-Transfers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5B2E))),
              const SizedBox(height: 12),
              headerAction,
            ],
          )
        else
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Branch Dispatch & Inter-Transfers', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F5B2E))),
              headerAction,
            ],
          ),
        const SizedBox(height: 24),
        _buildTable(headers, isMobile, 'No branch transfers recorded.'),
      ],
    );
  }

  Widget _buildTable(List<String> headers, bool isMobile, String emptyMsg) {
    if (isMobile) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.box, size: 40, color: AppColors.secondaryText.withValues(alpha: 0.4)),
            const SizedBox(height: 10),
            Text(emptyMsg, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: const BoxConstraints(minWidth: 1000),
        child: Table(
          children: [
            TableRow(
              decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5))),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Text(h, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
              )).toList(),
            ),
            TableRow(
              children: List.generate(headers.length, (idx) {
                if (idx == 0) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60),
                    child: Text(emptyMsg, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
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
