import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../widgets/calculator/beta_calculator.dart';

class PurchaseDetailsPage extends ConsumerStatefulWidget {
  const PurchaseDetailsPage({super.key});

  @override
  ConsumerState<PurchaseDetailsPage> createState() => _PurchaseDetailsPageState();
}

class _PurchaseDetailsPageState extends ConsumerState<PurchaseDetailsPage> {
  bool _isSyncing = false;
  String _selectedShopFilter = 'All Shops';
  double _pointsBalance = 140184.0;

  // Active integrations list
  final List<Map<String, dynamic>> _integrations = [];

  // Connected purchases list matching Screenshot 5
  final List<Map<String, dynamic>> _purchases = [
    {
      'id': 'POS-696314',
      'type': 'CONNECTED SHOP',
      'date': '13 Aug 2026',
      'merchant': 'ravinew2004',
      'amount': 141600.0,
      'status': 'PAID',
      'gst': 0.0,
      'pointsEarned': 1416,
      'items': [
        {'name': 'Commercial POS Terminal Hardware', 'qty': 2, 'rate': 45000.0, 'total': 90000.0},
        {'name': 'Thermal Barcode & Slip Printer Hub', 'qty': 2, 'rate': 18000.0, 'total': 36000.0},
        {'name': 'Retail Inventory Scanner Pro', 'qty': 3, 'rate': 5200.0, 'total': 15600.0},
      ],
    },
  ];

  void _handleSyncData() async {
    setState(() => _isSyncing = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isSyncing = false;
      _pointsBalance += 50.0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.checkCircle, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Commerce data & loyalty points synced successfully!'),
          ],
        ),
        backgroundColor: const Color(0xFF166534),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPointsRulesDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(LucideIcons.fileText, color: Color(0xFF2563EB), size: 22),
            SizedBox(width: 10),
            Text('Points Rules & Ratio', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRuleRow('Base Earning Rate', '₹100 Spent = 1 Loyalty Point (1% cashback value)'),
              const SizedBox(height: 12),
              _buildRuleRow('Redemption Ratio', '10 Points = ₹1.00 Value across all connected stores'),
              const SizedBox(height: 12),
              _buildRuleRow('Current Balance', '${_pointsBalance.toStringAsFixed(0)} Points (≈ ₹${(_pointsBalance / 10).toStringAsFixed(2)})'),
              const SizedBox(height: 12),
              _buildRuleRow('Auto-Crediting', 'Points are credited instantly upon POS bill settlement'),
              const SizedBox(height: 12),
              _buildRuleRow('Expiry Period', 'Points remain active for 24 months from transaction date'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static Widget _buildRuleRow(String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          const SizedBox(height: 3),
          Text(desc, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  void _showPointsCalculatorDialog() {
    final amountController = TextEditingController(text: '10000');
    double calcPoints = 100;
    double calcValue = 10;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(LucideIcons.calculator, color: Color(0xFF166534), size: 22),
              SizedBox(width: 10),
              Text('Points & Value Calculator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter purchase spending amount to estimate points:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 12),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  labelText: 'Spending Amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (val) {
                  final amt = double.tryParse(val) ?? 0;
                  setModalState(() {
                    calcPoints = amt / 100;
                    calcValue = calcPoints / 10;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Points Earned', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                        Text('+${calcPoints.toStringAsFixed(0)} pts', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                      ],
                    ),
                    Container(height: 30, width: 1, color: const Color(0xFFBBF7D0)),
                    Column(
                      children: [
                        const Text('Cashback Value', style: TextStyle(fontSize: 11, color: Color(0xFF166534))),
                        Text('₹${calcValue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Close', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                _showBetaCalculatorSheet();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Open Beta Calculator'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBetaCalculatorSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.calculator, color: Color(0xFF166534), size: 20),
                    SizedBox(width: 8),
                    Text('Cliks Financial Calculator', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            const Expanded(child: BetaCalculator()),
          ],
        ),
      ),
    );
  }

  void _showLinkStoreDialog() {
    final nameController = TextEditingController();
    final posIdController = TextEditingController(text: 'POS-${DateTime.now().millisecondsSinceEpoch % 900000 + 100000}');
    String selectedPlatform = 'Cliks Smart POS';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: Row(
            children: const [
              Icon(LucideIcons.externalLink, color: Color(0xFF166534), size: 22),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Link External Store / POS',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Connect your retail merchant counter or online storefront:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                const SizedBox(height: 14),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Store / Merchant Name',
                    hintText: 'e.g. Downtown Flagship Store',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: posIdController,
                  decoration: InputDecoration(
                    labelText: 'POS Terminal Identifier',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedPlatform,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Platform Type',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Cliks Smart POS', child: Text('Cliks Smart POS', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'Shopify Storefront', child: Text('Shopify Storefront', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'WooCommerce API', child: Text('WooCommerce API', overflow: TextOverflow.ellipsis)),
                    DropdownMenuItem(value: 'Pine Labs / Custom POS', child: Text('Pine Labs / Custom POS', overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => selectedPlatform = val);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim().isEmpty ? 'Merchant Store' : nameController.text.trim();
                final posId = posIdController.text.trim();
                setState(() {
                  _integrations.add({
                    'name': name,
                    'posId': posId,
                    'platform': selectedPlatform,
                    'status': 'Connected',
                    'date': 'Today',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Connected $name successfully!'),
                    backgroundColor: const Color(0xFF166534),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Link Store'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSelectShopDialog() {
    final options = ['All Shops', 'POS-696314 (Merchant: ravinew2004)', ..._integrations.map((e) => '${e['posId']} (${e['name']})')];
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Select Connected Shop', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options
              .map(
                (opt) => ListTile(
                  title: Text(opt, style: const TextStyle(fontSize: 14)),
                  leading: const Icon(LucideIcons.store, color: Color(0xFF166534), size: 18),
                  selected: _selectedShopFilter == opt,
                  onTap: () {
                    setState(() => _selectedShopFilter = opt);
                    Navigator.pop(ctx);
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  void _showViewItemsModal(Map<String, dynamic> purchase) {
    final List<Map<String, dynamic>> items = purchase['items'] ?? [];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          purchase['id'] ?? 'POS Order',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFECFDF5),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFA7F3D0)),
                          ),
                          child: Text(
                            purchase['status'] ?? 'PAID',
                            style: const TextStyle(color: Color(0xFF047857), fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${purchase['date']} • Merchant: ${purchase['merchant']}',
                      style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text('Purchased Items Breakdown', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final it = items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(LucideIcons.package, size: 18, color: Color(0xFF475569)),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(it['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                              const SizedBox(height: 2),
                              Text('Qty: ${it['qty']} × ₹${(it['rate'] as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        Text(
                          '₹${(it['total'] as num).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('GST (Taxes)', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                Text('₹${(purchase['gst'] as num).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Points Earned', style: TextStyle(fontSize: 13, color: Color(0xFF7C3AED), fontWeight: FontWeight.bold)),
                Text('+${purchase['pointsEarned']} pts', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF7C3AED))),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount Paid', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text('₹${(purchase['amount'] as num).toStringAsFixed(2)}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Purchase Receipt exported successfully!'), backgroundColor: Color(0xFF166534)),
                  );
                },
                icon: const Icon(LucideIcons.download, size: 16),
                label: const Text('Export Purchase Receipt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isDesktop = screenWidth >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : (isDesktop ? 28 : 20),
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ════════════════════════════════════════════════════════════════════
            // 1. PAGE HEADER (MATCHING SCREENSHOT 5)
            // ════════════════════════════════════════════════════════════════════
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              spacing: 12,
              runSpacing: 12,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: isMobile ? screenWidth - 32 : 600),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Purchase Details',
                        style: TextStyle(
                          fontSize: isMobile ? 22 : 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Connected commerce tracking, customer loyalty rewards & supplier purchase workflow.',
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _isSyncing ? null : _handleSyncData,
                  icon: _isSyncing
                      ? const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF166534)),
                        )
                      : const Icon(LucideIcons.refreshCw, size: 15, color: Color(0xFF166534)),
                  label: Text(
                    _isSyncing ? 'Syncing...' : 'Sync Data',
                    style: const TextStyle(
                      color: Color(0xFF166534),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF166534), width: 1.2),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ════════════════════════════════════════════════════════════════════
            // 2. ROW 1: ACTIVE INTEGRATIONS & LOYALTY OVERVIEW (MATCHING SCREENSHOT 5)
            // ════════════════════════════════════════════════════════════════════
            if (isMobile) ...[
              _buildActiveIntegrationsCard(),
              const SizedBox(height: 16),
              _buildLoyaltyRewardsCard(),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildActiveIntegrationsCard()),
                  const SizedBox(width: 20),
                  Expanded(flex: 6, child: _buildLoyaltyRewardsCard()),
                ],
              ),
            ],

            const SizedBox(height: 32),

            // ════════════════════════════════════════════════════════════════════
            // 3. ROW 2: CUSTOMER PURCHASE HISTORY (MATCHING SCREENSHOT 5)
            // ════════════════════════════════════════════════════════════════════
            if (isMobile) ...[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(LucideIcons.history, color: Color(0xFF166534), size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Customer Purchase History',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _showLinkStoreDialog,
                    icon: const Icon(LucideIcons.externalLink, size: 14, color: Colors.white),
                    label: const Text(
                      'LINK EXTERNAL STORE',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF166534),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(LucideIcons.history, color: Color(0xFF166534), size: 20),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Customer Purchase History',
                            style: TextStyle(
                              fontSize: isDesktop ? 22 : 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _showLinkStoreDialog,
                    icon: const Icon(LucideIcons.externalLink, size: 14, color: Colors.white),
                    label: const Text(
                      'LINK EXTERNAL STORE',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF166534),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Card: Connected Shops & Purchases
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
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
                  // Sub-header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(LucideIcons.history, size: 18, color: Color(0xFF166534)),
                              SizedBox(width: 8),
                              Text(
                                'Connected Shops & Purchases',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                            ],
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: _showSelectShopDialog,
                          icon: const Icon(LucideIcons.externalLink, size: 13, color: Color(0xFF475569)),
                          label: Text(
                            _selectedShopFilter,
                            style: const TextStyle(fontSize: 12, color: Color(0xFF475569), fontWeight: FontWeight.w600),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFCBD5E1)),
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),

                  // Purchase Cards List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: _purchases.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _purchases[index];
                      return _buildPurchaseItemCard(item, isMobile);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // ACTIVE INTEGRATIONS CARD WIDGET
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildActiveIntegrationsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          Padding(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.store, color: Color(0xFF166534), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Active Integrations',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Text(
                    '${_integrations.length} Connected',
                    style: const TextStyle(
                      color: Color(0xFF047857),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0), style: BorderStyle.solid),
            ),
            child: _integrations.isEmpty
                ? const Center(
                    child: Text(
                      'No active business connection requests.',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  )
                : Column(
                    children: _integrations
                        .map(
                          (it) => ListTile(
                            leading: const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A)),
                            title: Text(it['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('${it['platform']} • ${it['posId']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFECFDF5),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text('Live', style: TextStyle(color: Color(0xFF059669), fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // LOYALTY & REWARDS OVERVIEW CARD WIDGET
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildLoyaltyRewardsCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
          Padding(
            padding: const EdgeInsets.all(18),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.star, color: Color(0xFF166534), size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Loyalty & Rewards Overview',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: _showPointsRulesDialog,
                  icon: const Icon(LucideIcons.fileText, size: 13, color: Color(0xFF2563EB)),
                  label: const Text(
                    'Points Rules & Ratio',
                    style: TextStyle(color: Color(0xFF2563EB), fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF93C5FD)),
                    backgroundColor: const Color(0xFFEFF6FF),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // Available Balance Green Capsule
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AVAILABLE BALANCE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              '${_pointsBalance.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} ',
                              style: const TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF064E3B),
                              ),
                            ),
                            const Text(
                              'pts',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF047857),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '≈ ₹${(_pointsBalance / 10).toStringAsFixed(2)} Cashback Value',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Icon(
                    LucideIcons.star,
                    color: Color(0xFF059669),
                    size: 26,
                  ),
                ),
              ],
            ),
          ),

          // Bottom Points Ratio bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                const Text(
                  'Points Ratio: ₹100 Spent = 1 Point  |  10 Points = ₹1.00 Value',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475569),
                  ),
                ),
                InkWell(
                  onTap: _showPointsCalculatorDialog,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Calculator',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(LucideIcons.chevronRight, size: 14, color: Color(0xFF2563EB)),
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

  // ════════════════════════════════════════════════════════════════════════════
  // PURCHASE ITEM CARD WIDGET (MATCHING SCREENSHOT 5)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildPurchaseItemCard(Map<String, dynamic> item, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFECFDF5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.receipt, color: Color(0xFF059669), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                item['id'] ?? '',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFF059669)),
                                ),
                                child: Text(
                                  item['type'] ?? '',
                                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${item['date']} • Merchant: ${item['merchant']}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runAlignment: WrapAlignment.spaceBetween,
                  spacing: 12,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('GST ₹${(item['gst'] as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                        Text('POINTS EARNED +${item['pointsEarned']} pts', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${(item['amount'] as num).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFF166534),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                item['status'] ?? 'PAID',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        OutlinedButton(
                          onPressed: () => _showViewItemsModal(item),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF93C5FD)),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            minimumSize: Size.zero,
                          ),
                          child: const Text('View Items >', style: TextStyle(fontSize: 11, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.receipt, color: Color(0xFF059669), size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            item['id'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0F172A)),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: const Color(0xFF059669)),
                            ),
                            child: Text(
                              item['type'] ?? '',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${item['date']} • Merchant: ${item['merchant']}',
                        style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GST ₹${(item['gst'] as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      const SizedBox(height: 2),
                      Text('POINTS EARNED +${item['pointsEarned']} pts', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF7C3AED))),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '₹${(item['amount'] as num).toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF166534),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  item['status'] ?? 'PAID',
                                  style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          OutlinedButton(
                            onPressed: () => _showViewItemsModal(item),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF93C5FD)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('View Items >', style: TextStyle(fontSize: 12, color: Color(0xFF2563EB), fontWeight: FontWeight.bold)),
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
}
