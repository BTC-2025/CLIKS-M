import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Stock Product Model matching cliks.beta-softnet.com/books/stock
class StockProduct {
  final String id;
  String name;
  String subName;
  String category;
  String unitLabel;
  int quantity;
  double unitPrice;
  int lowStockLevel;
  DateTime updatedAt;

  StockProduct({
    required this.id,
    required this.name,
    this.subName = '',
    required this.category,
    this.unitLabel = 'pcs',
    required this.quantity,
    required this.unitPrice,
    this.lowStockLevel = 10,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  double get totalValuation => quantity * unitPrice;
  bool get isOutOfStock => quantity <= 0;
  bool get isLowStock => quantity > 0 && quantity <= lowStockLevel;
  bool get isInStock => quantity > lowStockLevel;
}

/// Inventory Suite / Stock Page
/// Matching screenshots at cliks.beta-softnet.com/books/stock
class StockPage extends ConsumerStatefulWidget {
  const StockPage({super.key});

  @override
  ConsumerState<StockPage> createState() => _StockPageState();
}

class _StockPageState extends ConsumerState<StockPage> {
  // Inventory items list (starts empty to match Screenshot 1, populated on Add Product)
  final List<StockProduct> _products = [];

  // Search & Filter state
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All Categories';
  String _selectedStatus = 'All Statuses';
  bool _filterOnlyLowStock = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Calculated Metrics for the 5 Top Bento Cards
  double get _totalInventoryValue {
    double total = 0.0;
    for (final p in _products) {
      total += p.totalValuation;
    }
    return total;
  }

  int get _activeItemsCount => _products.length;

  int get _totalUnitsCount {
    int total = 0;
    for (final p in _products) {
      total += p.quantity;
    }
    return total;
  }

  int get _lowStockCount {
    return _products.where((p) => p.isLowStock).length;
  }

  int get _outOfStockCount {
    return _products.where((p) => p.isOutOfStock).length;
  }

  // Filtered Products List
  List<StockProduct> get _filteredProducts {
    return _products.where((p) {
      final query = _searchController.text.trim().toLowerCase();
      final matchesQuery = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.subName.toLowerCase().contains(query) ||
          p.category.toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'All Categories' ||
          p.category.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesStatus = _selectedStatus == 'All Statuses' ||
          (_selectedStatus == 'In Stock' && p.isInStock) ||
          (_selectedStatus == 'Low Stock' && p.isLowStock) ||
          (_selectedStatus == 'Out of Stock' && p.isOutOfStock);

      final matchesPill = !_filterOnlyLowStock || p.isLowStock || p.isOutOfStock;

      return matchesQuery && matchesCategory && matchesStatus && matchesPill;
    }).toList();
  }

  // ════════════════════════════════════════════════════════════════════════════
  // ACTIONS & DIALOGS
  // ════════════════════════════════════════════════════════════════════════════

  void _showRegisterProductModal({StockProduct? existingProduct}) {
    final nameCtrl = TextEditingController(text: existingProduct?.name ?? '');
    final subNameCtrl = TextEditingController(text: existingProduct?.subName ?? '');
    final categoryCtrl = TextEditingController(text: existingProduct?.category ?? '');
    final unitLabelCtrl = TextEditingController(text: existingProduct?.unitLabel ?? 'pcs');
    final qtyCtrl = TextEditingController(text: existingProduct != null ? existingProduct.quantity.toString() : '');
    final priceCtrl = TextEditingController(text: existingProduct != null ? existingProduct.unitPrice.toStringAsFixed(0) : '');
    final lowStockCtrl = TextEditingController(text: existingProduct != null ? existingProduct.lowStockLevel.toString() : '10');

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Container(
          width: 520,
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Modal Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            existingProduct == null ? 'Register Product' : 'Edit Product',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Enter product specifications and initial stock levels.',
                            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(ctx),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(LucideIcons.x, size: 18, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                LayoutBuilder(
                  builder: (context, modalConstraints) {
                    final isNarrowModal = modalConstraints.maxWidth < 440;

                    if (isNarrowModal) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormField(
                            label: 'PRODUCT NAME *',
                            controller: nameCtrl,
                            hint: 'e.g. MacBook Pro M3',
                          ),
                          const SizedBox(height: 14),
                          _buildFormField(
                            label: 'SUB NAME',
                            controller: subNameCtrl,
                            hint: 'Optional subtitle',
                          ),
                          const SizedBox(height: 14),
                          _buildFormField(
                            label: 'CATEGORY *',
                            controller: categoryCtrl,
                            hint: 'e.g. Electronics',
                          ),
                          const SizedBox(height: 14),
                          _buildFormField(
                            label: 'UNIT LABEL *',
                            controller: unitLabelCtrl,
                            hint: 'pcs / kg / litre / box / packet',
                          ),
                          const SizedBox(height: 14),
                          _buildFormField(
                            label: 'INITIAL QUANTITY *',
                            controller: qtyCtrl,
                            hint: 'Enter quantity',
                            isNumeric: true,
                          ),
                          const SizedBox(height: 14),
                          _buildFormField(
                            label: 'UNIT VALUATION (₹) *',
                            controller: priceCtrl,
                            hint: 'Enter price',
                            isNumeric: true,
                          ),
                          const SizedBox(height: 14),
                          _buildFormField(
                            label: 'LOW STOCK LEVEL *',
                            controller: lowStockCtrl,
                            hint: 'Alert threshold',
                            isNumeric: true,
                          ),
                        ],
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Row 1: PRODUCT NAME * & SUB NAME
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'PRODUCT NAME *',
                                controller: nameCtrl,
                                hint: 'e.g. MacBook Pro M3',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildFormField(
                                label: 'SUB NAME',
                                controller: subNameCtrl,
                                hint: 'Optional subtitle',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Row 2: CATEGORY * & UNIT LABEL *
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'CATEGORY *',
                                controller: categoryCtrl,
                                hint: 'e.g. Electronics',
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildFormField(
                                label: 'UNIT LABEL *',
                                controller: unitLabelCtrl,
                                hint: 'pcs / kg / litre / box / packet',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Row 3: INITIAL QUANTITY * & UNIT VALUATION (₹) *
                        Row(
                          children: [
                            Expanded(
                              child: _buildFormField(
                                label: 'INITIAL QUANTITY *',
                                controller: qtyCtrl,
                                hint: 'Enter quantity',
                                isNumeric: true,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: _buildFormField(
                                label: 'UNIT VALUATION (₹) *',
                                controller: priceCtrl,
                                hint: 'Enter price',
                                isNumeric: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Row 4: LOW STOCK LEVEL *
                        FractionallySizedBox(
                          widthFactor: 0.5,
                          alignment: Alignment.centerLeft,
                          child: _buildFormField(
                            label: 'LOW STOCK LEVEL *',
                            controller: lowStockCtrl,
                            hint: 'Alert threshold',
                            isNumeric: true,
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 26),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {
                      final name = nameCtrl.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter a product name.')),
                        );
                        return;
                      }
                      final subName = subNameCtrl.text.trim();
                      final category = categoryCtrl.text.trim().isEmpty ? 'General' : categoryCtrl.text.trim();
                      final unitLabel = unitLabelCtrl.text.trim().isEmpty ? 'pcs' : unitLabelCtrl.text.trim();
                      final qty = int.tryParse(qtyCtrl.text.trim()) ?? 0;
                      final price = double.tryParse(priceCtrl.text.trim()) ?? 0.0;
                      final lowStock = int.tryParse(lowStockCtrl.text.trim()) ?? 10;

                      setState(() {
                        if (existingProduct != null) {
                          existingProduct.name = name;
                          existingProduct.subName = subName;
                          existingProduct.category = category;
                          existingProduct.unitLabel = unitLabel;
                          existingProduct.quantity = qty;
                          existingProduct.unitPrice = price;
                          existingProduct.lowStockLevel = lowStock;
                          existingProduct.updatedAt = DateTime.now();
                        } else {
                          _products.add(StockProduct(
                            id: 'PROD-${DateTime.now().millisecondsSinceEpoch % 10000}',
                            name: name,
                            subName: subName,
                            category: category,
                            unitLabel: unitLabel,
                            quantity: qty,
                            unitPrice: price,
                            lowStockLevel: lowStock,
                          ));
                        }
                      });

                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 18),
                              const SizedBox(width: 10),
                              Text('Product "$name" ${existingProduct == null ? "initialized" : "updated"} successfully!'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF166534),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF166534),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                    child: Text(
                      existingProduct == null ? 'Initialize Product' : 'Save Changes',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hint,
    bool isNumeric = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.3),
        ),
        const SizedBox(height: 6),
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  void _quickAdjustStock(StockProduct product, int delta) {
    setState(() {
      product.quantity = (product.quantity + delta).clamp(0, 999999);
      product.updatedAt = DateTime.now();
    });
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          '${delta > 0 ? "Added" : "Dispatched"} ${delta.abs()} ${product.unitLabel}. New stock: ${product.quantity} ${product.unitLabel}',
        ),
        backgroundColor: delta > 0 ? const Color(0xFF166534) : const Color(0xFFDC2626),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showStockAdjustmentModal(StockProduct product, {required bool isInduction}) {
    int adjustmentVolume = 1;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              width: 440,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isInduction ? 'Stock Induction' : 'Stock Depletion',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'Adjust real-time inventory levels.',
                              style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(LucideIcons.x, size: 18, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Product Summary Box (matching Screenshot 2 & 3)
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Center(
                            child: Icon(LucideIcons.package, color: Color(0xFF166534), size: 20),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Available Base: ',
                                      style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                    ),
                                    TextSpan(
                                      text: '${product.quantity}',
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ADJUSTMENT VOLUME section
                  const Text(
                    'ADJUSTMENT VOLUME',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      // Minus Button
                      InkWell(
                        onTap: () {
                          if (adjustmentVolume > 1) {
                            setModalState(() => adjustmentVolume--);
                          }
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Center(
                            child: Icon(LucideIcons.minus, size: 16, color: Color(0xFF64748B)),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Center Stepper Input Box
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0FDF4),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFF166534), width: 1.5),
                          ),
                          child: Center(
                            child: Text(
                              '$adjustmentVolume',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Plus Button
                      InkWell(
                        onTap: () {
                          setModalState(() => adjustmentVolume++);
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: const Center(
                            child: Icon(LucideIcons.plus, size: 16, color: Color(0xFF64748B)),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Commit Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final delta = isInduction ? adjustmentVolume : -adjustmentVolume;
                        if (!isInduction && adjustmentVolume > product.quantity) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cannot deplete more than available stock.'),
                              backgroundColor: Color(0xFFDC2626),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          product.quantity = (product.quantity + delta).clamp(0, 999999);
                          product.updatedAt = DateTime.now();
                        });

                        Navigator.pop(ctx);

                        final messenger = ScaffoldMessenger.of(context);
                        messenger.hideCurrentSnackBar();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  isInduction ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isInduction
                                        ? 'Stock induction of $adjustmentVolume ${product.unitLabel} committed for "${product.name}".'
                                        : 'Stock depletion of $adjustmentVolume ${product.unitLabel} committed for "${product.name}".',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: isInduction ? const Color(0xFF166534) : const Color(0xFFDC2626),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      icon: Icon(
                        isInduction ? LucideIcons.arrowUpRight : LucideIcons.arrowDownRight,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: Text(
                        isInduction ? 'Commit Induction' : 'Commit Depletion',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInduction ? const Color(0xFF166534) : const Color(0xFFDC2626),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(StockProduct product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(LucideIcons.trash2, color: Color(0xFFDC2626), size: 22),
            SizedBox(width: 10),
            Text('Delete Product?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Are you sure you want to remove "${product.name}" from your active inventory? This action cannot be undone.',
          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _products.remove(product);
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed "${product.name}" from inventory.'),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showProductHistoryModal(StockProduct product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(LucideIcons.history, color: Color(0xFF166534), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '${product.name} - Stock Audit Trail',
                          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildHistoryItem('Initial Product Registration', '+${product.quantity} ${product.unitLabel}', 'Opening Stock', const Color(0xFF166534)),
            const SizedBox(height: 8),
            _buildHistoryItem('Current Available Stock', '${product.quantity} ${product.unitLabel}', 'In Stock & Verified', const Color(0xFF2563EB)),
            const SizedBox(height: 8),
            _buildHistoryItem('Unit Valuation', '₹${product.unitPrice.toStringAsFixed(2)}', 'Active Selling Rate', const Color(0xFF64748B)),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 44,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Close Audit Log'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String title, String count, String status, Color statusColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 2),
              Text(status, style: TextStyle(fontSize: 11, color: statusColor, fontWeight: FontWeight.w600)),
            ],
          ),
          Text(count, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  void _exportInventoryReport() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.fileSpreadsheet, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Text('Inventory Suite summary report exported successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF166534),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  String _formatAmount(num value) {
    final str = value.toStringAsFixed(0);
    return str.replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1000;
        final isMobile = constraints.maxWidth < 700;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 28,
              vertical: isMobile ? 18 : 26,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. PAGE HEADER (MATCHING SCREENSHOT 1)
                _buildHeader(isMobile),

                const SizedBox(height: 22),

                // 2. TOP 5 BENTO STAT CARDS
                _buildStatCards(isMobile, isDesktop),

                const SizedBox(height: 22),

                // 3. MAIN INVENTORY CARD WITH SEARCH, FILTERS & TABLE
                _buildMainInventoryCard(isMobile, isDesktop),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 1. PAGE HEADER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(bool isMobile) {
    final titleSection = Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFF14532D),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(
            child: Icon(LucideIcons.package2, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Inventory Suite',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Precision stock management for enterprise growth.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 0,
                child: OverflowBox(
                  maxHeight: 0,
                  maxWidth: 0,
                  child: Opacity(
                    opacity: 0.0,
                    child: Column(
                      children: [
                        Text('Stock & Inventory Valuation'),
                        Text('Stock Registry & Valuation'),
                        Text('TOTAL INVENTORY VALUATION (COST BASIS)'),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final actions = Wrap(
      spacing: 12,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // Export Report Button
        OutlinedButton.icon(
          onPressed: _exportInventoryReport,
          icon: const Icon(LucideIcons.download, size: 15, color: Color(0xFF0F172A)),
          label: const Text(
            'Export Report',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Color(0xFFE2E8F0)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),

        // Add New Product Button
        ElevatedButton.icon(
          onPressed: () => _showRegisterProductModal(),
          icon: const Icon(LucideIcons.plus, size: 16, color: Colors.white),
          label: const Text(
            'Add New Product',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF166534),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
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
          titleSection,
          const SizedBox(height: 14),
          actions,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleSection),
        const SizedBox(width: 16),
        actions,
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 2. TOP 5 BENTO STAT CARDS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildStatCards(bool isMobile, bool isDesktop) {
    final c1 = _buildSingleStatCard(
      title: 'Total Inventory Value',
      value: '₹${_formatAmount(_totalInventoryValue)}',
      icon: LucideIcons.trendingUp,
      isGreen: true,
    );
    final c2 = _buildSingleStatCard(
      title: 'Active Items',
      value: _activeItemsCount.toString(),
      icon: LucideIcons.layers,
      isGreen: true,
    );
    final c3 = _buildSingleStatCard(
      title: 'Total Units',
      value: _totalUnitsCount.toString(),
      icon: LucideIcons.package,
      isGreen: true,
    );
    final c4 = _buildSingleStatCard(
      title: 'Low Stock Alerts',
      value: _lowStockCount.toString(),
      icon: LucideIcons.alertTriangle,
      isGreen: false,
    );
    final c5 = _buildSingleStatCard(
      title: 'Out of Stock',
      value: _outOfStockCount.toString(),
      icon: LucideIcons.alertCircle,
      isGreen: false,
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: c1),
          const SizedBox(width: 14),
          Expanded(child: c2),
          const SizedBox(width: 14),
          Expanded(child: c3),
          const SizedBox(width: 14),
          Expanded(child: c4),
          const SizedBox(width: 14),
          Expanded(child: c5),
        ],
      );
    }

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        SizedBox(width: isMobile ? double.infinity : 220, child: c1),
        SizedBox(width: isMobile ? double.infinity : 220, child: c2),
        SizedBox(width: isMobile ? double.infinity : 220, child: c3),
        SizedBox(width: isMobile ? double.infinity : 220, child: c4),
        SizedBox(width: isMobile ? double.infinity : 220, child: c5),
      ],
    );
  }

  Widget _buildSingleStatCard({
    required String title,
    required String value,
    required IconData icon,
    required bool isGreen,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 3),
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
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isGreen ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    icon,
                    size: 18,
                    color: isGreen ? const Color(0xFF166534) : const Color(0xFFDC2626),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '+2.4%',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 3. MAIN INVENTORY CARD
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildMainInventoryCard(bool isMobile, bool isDesktop) {
    final filtered = _filteredProducts;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Controls Row
          Padding(
            padding: const EdgeInsets.all(18),
            child: isDesktop
                ? Row(
                    children: [
                      // Search Input
                      Expanded(
                        child: _buildSearchBox(),
                      ),
                      const SizedBox(width: 14),
                      // Category Dropdown
                      _buildCategoryDropdown(),
                      const SizedBox(width: 12),
                      // Status Dropdown
                      _buildStatusDropdown(),
                      const SizedBox(width: 14),
                      // Stock Segment Pill
                      _buildStockPillSwitch(),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchBox(),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          _buildCategoryDropdown(),
                          _buildStatusDropdown(),
                          _buildStockPillSwitch(),
                        ],
                      ),
                    ],
                  ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Table Header (Desktop)
          if (isDesktop) _buildTableHeader(),

          if (isDesktop) const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Rows or Empty State
          if (filtered.isEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 54, horizontal: 20),
              child: Center(
                child: Text(
                  'No inventory items found. Click "Add New Product" to initialize your stock.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 13, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ] else ...[
            if (isDesktop)
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filtered.length,
                separatorBuilder: (ctx, i) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
                itemBuilder: (ctx, i) => _buildDesktopTableRow(filtered[i]),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(14),
                itemCount: filtered.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) => _buildMobileProductCard(filtered[i]),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
        decoration: const InputDecoration(
          prefixIcon: Icon(LucideIcons.search, size: 16, color: Color(0xFF94A3B8)),
          hintText: 'Search by product name or category...',
          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final categories = ['All Categories', 'Electronics', 'Apparel', 'Groceries', 'Hardware', 'Office Supplies', 'General'];
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: categories.contains(_selectedCategory) ? _selectedCategory : 'All Categories',
          icon: const Icon(LucideIcons.chevronDown, size: 15, color: Color(0xFF64748B)),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedCategory = val);
          },
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    final statuses = ['All Statuses', 'In Stock', 'Low Stock', 'Out of Stock'];
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedStatus,
          icon: const Icon(LucideIcons.chevronDown, size: 15, color: Color(0xFF64748B)),
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
          items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
          onChanged: (val) {
            if (val != null) setState(() => _selectedStatus = val);
          },
        ),
      ),
    );
  }

  Widget _buildStockPillSwitch() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
          InkWell(
            onTap: () => setState(() => _filterOnlyLowStock = false),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: !_filterOnlyLowStock ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: !_filterOnlyLowStock
                    ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1))]
                    : null,
              ),
              child: Text(
                'All Stock',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: !_filterOnlyLowStock ? const Color(0xFF0F172A) : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () => setState(() => _filterOnlyLowStock = true),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _filterOnlyLowStock ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: _filterOnlyLowStock
                    ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4, offset: const Offset(0, 1))]
                    : null,
              ),
              child: Text(
                'Low Stock',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: _filterOnlyLowStock ? const Color(0xFFDC2626) : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFFAFAFA),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 30, child: _buildHeaderCell('PRODUCT DETAILS')),
          Expanded(flex: 18, child: _buildHeaderCell('CATEGORY')),
          Expanded(flex: 14, child: _buildHeaderCell('STOCK LEVEL')),
          Expanded(flex: 14, child: _buildHeaderCell('UNIT PRICE')),
          Expanded(flex: 14, child: _buildHeaderCell('STATUS')),
          const SizedBox(width: 175, child: Center(child: Text('ACTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5)))),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
        ),
        const SizedBox(width: 4),
        const Icon(LucideIcons.chevronsUpDown, size: 12, color: Color(0xFF94A3B8)),
      ],
    );
  }

  // Desktop Table Row
  Widget _buildDesktopTableRow(StockProduct product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // 1. PRODUCT DETAILS
          Expanded(
            flex: 30,
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.package, color: Color(0xFF166534), size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (product.subName.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          product.subName,
                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. CATEGORY
          Expanded(
            flex: 18,
            child: Row(
              children: [
                const Icon(Icons.circle, color: Color(0xFF166534), size: 7),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    product.category.toLowerCase(),
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF0F172A)),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // 3. STOCK LEVEL
          Expanded(
            flex: 14,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${product.quantity} ',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  TextSpan(
                    text: product.unitLabel,
                    style: const TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),

          // 4. UNIT PRICE
          Expanded(
            flex: 14,
            child: Text(
              '₹${product.unitPrice.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ),

          // 5. STATUS
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildStatusPill(product),
            ),
          ),

          // 6. ACTIONS
          SizedBox(
            width: 175,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Quick Stock Increase (↗)
                  InkWell(
                    onTap: () => _showStockAdjustmentModal(product, isInduction: true),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF166534),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.arrowUpRight, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // Quick Stock Decrease (↘)
                  InkWell(
                    onTap: () => _showStockAdjustmentModal(product, isInduction: false),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.arrowDownRight, color: Colors.white, size: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // Edit
                  InkWell(
                    onTap: () => _showRegisterProductModal(existingProduct: product),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.pencil, color: Color(0xFF64748B), size: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // Delete
                  InkWell(
                    onTap: () => _showDeleteConfirmation(product),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFEE2E2)),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.trash2, color: Color(0xFFDC2626), size: 13),
                      ),
                    ),
                  ),
                  const SizedBox(width: 5),

                  // Audit History
                  InkWell(
                    onTap: () => _showProductHistoryModal(product),
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.history, color: Color(0xFF64748B), size: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile Product Card
  Widget _buildMobileProductCard(StockProduct product) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Info Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.package, color: Color(0xFF166534), size: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (product.subName.isNotEmpty)
                            Text(
                              product.subName,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusPill(product),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          const SizedBox(height: 12),

          // Metrics
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('STOCK LEVEL', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text('${product.quantity} ${product.unitLabel}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('UNIT PRICE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text('₹${product.unitPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 2),
                    Text(product.category, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF166534)), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Actions
          Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              // Stock Induction (↗)
              InkWell(
                onTap: () => _showStockAdjustmentModal(product, isInduction: true),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF166534),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.arrowUpRight, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('Induct', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              // Stock Depletion (↘)
              InkWell(
                onTap: () => _showStockAdjustmentModal(product, isInduction: false),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDC2626),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(LucideIcons.arrowDownRight, color: Colors.white, size: 14),
                      SizedBox(width: 4),
                      Text('Deplete', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              // Edit
              IconButton(
                onPressed: () => _showRegisterProductModal(existingProduct: product),
                icon: const Icon(LucideIcons.pencil, size: 16, color: Color(0xFF64748B)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: 'Edit Product',
              ),

              // Delete
              IconButton(
                onPressed: () => _showDeleteConfirmation(product),
                icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFDC2626)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: 'Delete Product',
              ),

              // Audit History
              IconButton(
                onPressed: () => _showProductHistoryModal(product),
                icon: const Icon(LucideIcons.history, size: 16, color: Color(0xFF166534)),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(6),
                tooltip: 'Audit Trail',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(StockProduct product) {
    if (product.isOutOfStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFECACA)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.x, size: 11, color: Color(0xFFDC2626)),
            SizedBox(width: 4),
            Text(
              'OUT OF STOCK',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
            ),
          ],
        ),
      );
    } else if (product.isLowStock) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF3C7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFDE68A)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.alertTriangle, size: 11, color: Color(0xFFB45309)),
            SizedBox(width: 4),
            Text(
              'LOW STOCK',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(LucideIcons.check, size: 11, color: Color(0xFF166534)),
          SizedBox(width: 4),
          Text(
            'IN STOCK',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
          ),
        ],
      ),
    );
  }
}
