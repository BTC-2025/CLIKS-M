import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  final String _selectedCategory = 'All Categories';
  final String _selectedStatus = 'All Statuses';
  int _selectedFilterPill = 0; // 0: All Stock, 1: Low Stock
  String _searchQuery = '';

  // Sample Product Model State
  final List<Map<String, dynamic>> _products = [
    {
      'name': 's1 book',
      'sub': 'lista',
      'category': 'books',
      'stock': 28,
      'unitLabel': 'pcs',
      'price': 100,
      'status': 'IN STOCK',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final paddingVal = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Title + Subtitle + Action Buttons)
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // 2. 5 Stat Cards Row
            _buildStatCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 80.ms),
            const SizedBox(height: 28),

            // 3. Search & Filter Controls Bar
            _buildSearchAndFilters(isMobile).animate().fadeIn(duration: 450.ms, delay: 120.ms),
            const SizedBox(height: 20),

            // 4. Inventory Data Table
            _buildInventoryTable(isMobile).animate().fadeIn(duration: 500.ms, delay: 160.ms),
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
                child: const Icon(LucideIcons.package, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inventory Suite',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Precision stock management for enterprise growth.',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.download, size: 14),
                  label: const Text('Export Report', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF0F5132),
                    side: const BorderSide(color: Color(0xFF0F5132), width: 1.2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openRegisterProductModal(isMobile),
                  icon: const Icon(LucideIcons.plus, size: 16),
                  label: const Text('Add New Product', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5132),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.package, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inventory Suite',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                SizedBox(height: 4),
                Text(
                  'Precision stock management for enterprise growth.',
                  style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.download, size: 15),
              label: const Text('Export Report', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0F5132),
                side: const BorderSide(color: Color(0xFF0F5132), width: 1.2),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _openRegisterProductModal(isMobile),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Add New Product', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. 5 Stat Cards Row
  // ---------------------------------------------------------------------------
  Widget _buildStatCards(bool isMobile) {
    final stats = [
      {
        'title': 'Total Inventory Value',
        'value': '₹2,800',
        'badge': '+2.4%',
        'icon': LucideIcons.trendingUp,
        'iconBg': const Color(0xFFECFDF5),
        'iconColor': const Color(0xFF059669),
      },
      {
        'title': 'Active Items',
        'value': '1',
        'badge': '+2.4%',
        'icon': LucideIcons.layers,
        'iconBg': const Color(0xFFECFDF5),
        'iconColor': const Color(0xFF059669),
      },
      {
        'title': 'Total Units',
        'value': '28',
        'badge': '+2.4%',
        'icon': LucideIcons.box,
        'iconBg': const Color(0xFFECFDF5),
        'iconColor': const Color(0xFF059669),
      },
      {
        'title': 'Low Stock Alerts',
        'value': '0',
        'badge': '+2.4%',
        'icon': LucideIcons.triangleAlert,
        'iconBg': const Color(0xFFFEF2F2),
        'iconColor': const Color(0xFFEF4444),
      },
      {
        'title': 'Out of Stock',
        'value': '0',
        'badge': '+2.4%',
        'icon': LucideIcons.ban,
        'iconBg': const Color(0xFFFEF2F2),
        'iconColor': const Color(0xFFEF4444),
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 1100
            ? (constraints.maxWidth - 48) / 5
            : constraints.maxWidth > 700
                ? (constraints.maxWidth - 24) / 3
                : (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats.map((st) {
            return Container(
              width: cardWidth,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
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
                          color: st['iconBg'] as Color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(st['icon'] as IconData, size: 18, color: st['iconColor'] as Color),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          st['badge'] as String,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    st['title'] as String,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey.shade500),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      st['value'] as String,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.darkText),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Search & Filter Controls Bar
  // ---------------------------------------------------------------------------
  Widget _buildSearchAndFilters(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          if (isMobile) ...[
            // Mobile Stacked Search & Filters
            TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Search by product name or category...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                prefixIcon: const Icon(LucideIcons.search, size: 16, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFFAFAFB),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildDropdown('All Categories', ['All Categories', 'books', 'electronics']),
                  const SizedBox(width: 8),
                  _buildDropdown('All Statuses', ['All Statuses', 'IN STOCK', 'LOW STOCK']),
                  const SizedBox(width: 8),
                  _buildFilterPill(0, 'All Stock'),
                  const SizedBox(width: 4),
                  _buildFilterPill(1, 'Low Stock'),
                ],
              ),
            ),
          ] else ...[
            // Desktop Side-by-Side Bar
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search by product name or category...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      prefixIcon: const Icon(LucideIcons.search, size: 18, color: Colors.grey),
                      filled: true,
                      fillColor: const Color(0xFFFAFAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildDropdown('All Categories', ['All Categories', 'books', 'electronics']),
                const SizedBox(width: 8),
                _buildDropdown('All Statuses', ['All Statuses', 'IN STOCK', 'LOW STOCK']),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      _buildFilterPill(0, 'All Stock'),
                      _buildFilterPill(1, 'Low Stock'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(label) ? label : items.first,
          isDense: true,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800),
          icon: const Icon(LucideIcons.chevronDown, size: 14, color: Colors.grey),
          onChanged: (val) {},
          items: items.map((it) => DropdownMenuItem(value: it, child: Text(it))).toList(),
        ),
      ),
    );
  }

  Widget _buildFilterPill(int index, String label) {
    final isSelected = _selectedFilterPill == index;
    return InkWell(
      onTap: () => setState(() => _selectedFilterPill = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? AppColors.darkText : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Inventory Data Table
  // ---------------------------------------------------------------------------
  Widget _buildInventoryTable(bool isMobile) {
    return Container(
      width: double.infinity,
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
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 950,
          child: Column(
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    _buildTableHeaderCell('PRODUCT DETAILS', flex: 3),
                    _buildTableHeaderCell('CATEGORY', flex: 2),
                    _buildTableHeaderCell('STOCK LEVEL', flex: 2),
                    _buildTableHeaderCell('UNIT PRICE', flex: 2),
                    _buildTableHeaderCell('STATUS', flex: 2),
                    _buildTableHeaderCell('ACTIONS', flex: 4, alignRight: true),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // Product Items List
              ..._products.map((p) => _buildProductRow(p, isMobile)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableHeaderCell(String text, {int flex = 1, bool alignRight = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildProductRow(Map<String, dynamic> p, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // PRODUCT DETAILS
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(LucideIcons.box, color: Color(0xFF059669), size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(p['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(p['sub'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // CATEGORY
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(color: Color(0xFF059669), shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Expanded(child: Text(p['category'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText), overflow: TextOverflow.ellipsis)),
              ],
            ),
          ),

          // STOCK LEVEL
          Expanded(
            flex: 2,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${p['stock']} ', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.darkText)),
                  TextSpan(text: p['unitLabel'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                ],
              ),
            ),
          ),

          // UNIT PRICE
          Expanded(
            flex: 2,
            child: Text('₹${p['price']}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.darkText)),
          ),

          // STATUS
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.checkCircle2, size: 12, color: Color(0xFF059669)),
                  const SizedBox(width: 4),
                  Text(p['status'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF059669))),
                ],
              ),
            ),
          ),

          // ACTIONS
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Stock Induction (Green ↗)
                InkWell(
                  onTap: () => _openStockInductionModal(p, isMobile),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: const Color(0xFF0F5132), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(LucideIcons.arrowUpRight, color: Colors.white, size: 13),
                  ),
                ),
                const SizedBox(width: 6),

                // Stock Depletion (Red ↘)
                InkWell(
                  onTap: () => _openStockDepletionModal(p, isMobile),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(color: const Color(0xFFDC2626), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(LucideIcons.arrowDownRight, color: Colors.white, size: 13),
                  ),
                ),
                const SizedBox(width: 6),

                // Edit Icon Badge
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                    child: const Icon(LucideIcons.pencil, size: 13, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 6),

                // Delete Icon Badge
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
                    child: const Icon(LucideIcons.trash2, size: 13, color: Colors.redAccent),
                  ),
                ),
                const SizedBox(width: 6),

                // History Icon Badge
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(6)),
                    child: const Icon(LucideIcons.history, size: 13, color: Colors.blueAccent),
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
  // Modals & Bottom Sheets Router Helper
  // ---------------------------------------------------------------------------
  void _showModalPanel(Widget child, bool isMobile) {
    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.75, // Anchored in the bottom half of the mobile viewport
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: child,
            ),
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            backgroundColor: Colors.white,
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24),
              child: child,
            ),
          );
        },
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Modal 1: Register Product ("Add New Product") (Screenshot 2 & flutter_06)
  // ---------------------------------------------------------------------------
  void _openRegisterProductModal(bool isMobile) {
    final nameCtrl = TextEditingController();
    final subCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    final unitLabelCtrl = TextEditingController();
    final qtyCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final alertCtrl = TextEditingController();

    _showModalPanel(
      StatefulBuilder(
        builder: (context, setStateModal) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Register Product', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                          SizedBox(height: 2),
                          Text('Enter product specifications and initial stock levels.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                if (isMobile) ...[
                  _buildInputField('PRODUCT NAME *', 'e.g. MacBook Pro M3', nameCtrl),
                  const SizedBox(height: 12),
                  _buildInputField('SUB NAME', 'Optional subtitle', subCtrl),
                  const SizedBox(height: 12),
                  _buildInputField('CATEGORY *', 'e.g. Electronics', catCtrl),
                  const SizedBox(height: 12),
                  _buildInputField('UNIT LABEL *', 'pcs / kg / litre / box / packet', unitLabelCtrl),
                  const SizedBox(height: 12),
                  _buildInputField('INITIAL QUANTITY *', 'Enter quantity', qtyCtrl),
                  const SizedBox(height: 12),
                  _buildInputField('UNIT VALUATION (₹) *', 'Enter price', priceCtrl),
                  const SizedBox(height: 12),
                  _buildInputField('LOW STOCK LEVEL *', 'Alert threshold', alertCtrl),
                ] else ...[
                  Row(
                    children: [
                      Expanded(child: _buildInputField('PRODUCT NAME *', 'e.g. MacBook Pro M3', nameCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInputField('SUB NAME', 'Optional subtitle', subCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInputField('CATEGORY *', 'e.g. Electronics', catCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInputField('UNIT LABEL *', 'pcs / kg / litre / box / packet', unitLabelCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildInputField('INITIAL QUANTITY *', 'Enter quantity', qtyCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildInputField('UNIT VALUATION (₹) *', 'Enter price', priceCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputField('LOW STOCK LEVEL *', 'Alert threshold', alertCtrl),
                ],

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameCtrl.text.isNotEmpty) {
                        setState(() {
                          _products.add({
                            'name': nameCtrl.text,
                            'sub': subCtrl.text.isEmpty ? 'item' : subCtrl.text,
                            'category': catCtrl.text.isEmpty ? 'general' : catCtrl.text,
                            'stock': int.tryParse(qtyCtrl.text) ?? 1,
                            'unitLabel': unitLabelCtrl.text.isEmpty ? 'pcs' : unitLabelCtrl.text,
                            'price': int.tryParse(priceCtrl.text) ?? 100,
                            'status': 'IN STOCK',
                          });
                        });
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5132),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Initialize Product', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isMobile,
    );
  }

  // ---------------------------------------------------------------------------
  // Modal 2: Stock Induction (Green ↗) (Screenshot 3)
  // ---------------------------------------------------------------------------
  void _openStockInductionModal(Map<String, dynamic> product, bool isMobile) {
    int volume = 1;

    _showModalPanel(
      StatefulBuilder(
        builder: (context, setStateModal) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stock Induction', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                          SizedBox(height: 2),
                          Text('Adjust real-time inventory levels.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Item Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(LucideIcons.box, color: Color(0xFF059669), size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text('Available Base: ${product['stock']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Text('ADJUSTMENT VOLUME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5)),
                const SizedBox(height: 10),

                // Volume Stepper
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (volume > 1) setStateModal(() => volume--);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                        child: const Text('–', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          border: Border.all(color: const Color(0xFF059669), width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$volume',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setStateModal(() => volume++),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                        child: const Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        product['stock'] = (product['stock'] as int) + volume;
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(LucideIcons.arrowUpRight, size: 16),
                    label: const Text('Commit Induction', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5132),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isMobile,
    );
  }

  // ---------------------------------------------------------------------------
  // Modal 3: Stock Depletion (Red ↘) (Screenshot 4)
  // ---------------------------------------------------------------------------
  void _openStockDepletionModal(Map<String, dynamic> product, bool isMobile) {
    int volume = 1;

    _showModalPanel(
      StatefulBuilder(
        builder: (context, setStateModal) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Stock Depletion', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                          SizedBox(height: 2),
                          Text('Adjust real-time inventory levels.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle),
                        child: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Item Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: const Color(0xFFECFDF5), borderRadius: BorderRadius.circular(12)),
                        child: const Icon(LucideIcons.box, color: Color(0xFF059669), size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(product['name'] as String, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText), overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text('Available Base: ${product['stock']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
                Text('ADJUSTMENT VOLUME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5)),
                const SizedBox(height: 10),

                // Volume Stepper
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        if (volume > 1) setStateModal(() => volume--);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                        child: const Text('–', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          border: Border.all(color: const Color(0xFF059669), width: 1.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '$volume',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => setStateModal(() => volume++),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(10)),
                        child: const Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        final current = product['stock'] as int;
                        if (current >= volume) {
                          product['stock'] = current - volume;
                        }
                      });
                      Navigator.pop(context);
                    },
                    icon: const Icon(LucideIcons.arrowDownRight, size: 16),
                    label: const Text('Commit Depletion', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      isMobile,
    );
  }

  // Input Field Component Helper
  Widget _buildInputField(String label, String placeholder, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFFFAFAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }
}
