import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/navigation/navigation_provider.dart';

class AccountingPage extends ConsumerStatefulWidget {
  const AccountingPage({super.key});

  @override
  ConsumerState<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends ConsumerState<AccountingPage> {
  // Budget Planner State
  double _monthlyBudgetLimit = 20000.0;
  double _monthlyExpenses = 0.0;

  // My Wallet State
  double _walletBalance = 0.0;

  // Financial Goals List
  final List<Map<String, dynamic>> _financialGoals = [];

  // Investment Portfolio Assets List
  final List<Map<String, dynamic>> _investments = [];

  // Bills & Reminders List
  final List<Map<String, dynamic>> _bills = [];

  // Additional Sources Lists & Search Controllers
  final List<Map<String, dynamic>> _additionalIncomes = [];
  final List<Map<String, dynamic>> _additionalExpenses = [];
  final TextEditingController _additionalIncomeSearch = TextEditingController();
  final TextEditingController _additionalExpenseSearch = TextEditingController();

  // Fixed Sources Lists & Search Controllers
  final List<Map<String, dynamic>> _fixedIncomes = [];
  final List<Map<String, dynamic>> _fixedExpenses = [];
  final TextEditingController _fixedIncomeSearch = TextEditingController();
  final TextEditingController _fixedExpenseSearch = TextEditingController();

  // Sorting directions
  bool _sortAscAdditionalIncome = true;
  bool _sortAscAdditionalExpense = true;
  bool _sortAscFixedIncome = true;
  bool _sortAscFixedExpense = true;

  @override
  void dispose() {
    _additionalIncomeSearch.dispose();
    _additionalExpenseSearch.dispose();
    _fixedIncomeSearch.dispose();
    _fixedExpenseSearch.dispose();
    super.dispose();
  }

  // Calculate dynamic totals
  double get _totalIncome {
    double sum = 0.0;
    for (final it in _additionalIncomes) {
      sum += (it['amount'] as num?)?.toDouble() ?? 0.0;
    }
    for (final it in _fixedIncomes) {
      sum += (it['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  double get _totalExpenses {
    double sum = _monthlyExpenses;
    for (final it in _additionalExpenses) {
      sum += (it['amount'] as num?)?.toDouble() ?? 0.0;
    }
    for (final it in _fixedExpenses) {
      sum += (it['amount'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  double get _monthlySavings => (_totalIncome - _totalExpenses).clamp(0.0, double.infinity);

  double get _investmentMarketValue {
    double sum = 0.0;
    for (final it in _investments) {
      sum += (it['marketValue'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  double get _investmentCostBasis {
    double sum = 0.0;
    for (final it in _investments) {
      sum += (it['costBasis'] as num?)?.toDouble() ?? 0.0;
    }
    return sum;
  }

  double get _netWorth => _walletBalance + _investmentMarketValue + _monthlySavings;

  // ════════════════════════════════════════════════════════════════════════════
  // DIALOGS & ACTIONS
  // ════════════════════════════════════════════════════════════════════════════

  void _showTaxDeductionsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(LucideIcons.shield, color: Color(0xFFDC2626), size: 22),
            SizedBox(width: 10),
            Text('Tax & Deductions Overview', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTaxMetric('Estimated Tax Due', '₹0.00', 'Due by July 31st', const Color(0xFFDC2626)),
              const SizedBox(height: 12),
              _buildTaxMetric('TDS / Advance Tax Paid', '₹0.00', 'Self-Assessment Tax', const Color(0xFF16A34A)),
              const SizedBox(height: 12),
              _buildTaxMetric('Section 80C (PPF/ELSS/EPF)', '₹1,50,000 Cap', 'EPF, PPF, ELSS, Life Insurance', const Color(0xFF2563EB)),
              const SizedBox(height: 12),
              _buildTaxMetric('Section 80D Health Insurance', '₹25,000 Cap', 'Self & Family Mediclaim', const Color(0xFF7C3AED)),
              const SizedBox(height: 14),
              const Text(
                'Advance tax quarterly installments: 15% (Jun 15), 45% (Sep 15), 75% (Dec 15), 100% (Mar 15).',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Tax Computation Summary exported.'),
                  backgroundColor: Color(0xFF166534),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF166534),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Export Tax Sheet'),
          ),
        ],
      ),
    );
  }

  static Widget _buildTaxMetric(String title, String val, String subtitle, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          Text(val, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
        ],
      ),
    );
  }

  void _showEditBudgetDialog() {
    final controller = TextEditingController(text: _monthlyBudgetLimit.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Row(
          children: [
            Icon(LucideIcons.pencil, color: Color(0xFF7C3AED), size: 20),
            SizedBox(width: 10),
            Text('Set Monthly Budget Limit', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Set your spending target limit for this month:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                prefixText: '₹ ',
                labelText: 'Monthly Budget Limit',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(controller.text.trim()) ?? _monthlyBudgetLimit;
              setState(() => _monthlyBudgetLimit = val);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Budget limit updated to ₹${_monthlyBudgetLimit.toStringAsFixed(2)}'),
                  backgroundColor: const Color(0xFF166534),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF166534),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Save Budget'),
          ),
        ],
      ),
    );
  }

  void _showAddWalletFundsDialog() {
    final controller = TextEditingController(text: '0');
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(LucideIcons.wallet, color: Color(0xFF7C3AED), size: 22),
              SizedBox(width: 10),
              Text('Add Funds to Wallet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Enter amount to add to your Cliks Digital Wallet:', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  prefixText: '₹ ',
                  labelText: 'Amount',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  ActionChip(
                    label: const Text('+ ₹1,000'),
                    onPressed: () {
                      final cur = double.tryParse(controller.text) ?? 0;
                      controller.text = (cur + 1000).toStringAsFixed(0);
                      setDialogState(() {});
                    },
                  ),
                  ActionChip(
                    label: const Text('+ ₹5,000'),
                    onPressed: () {
                      final cur = double.tryParse(controller.text) ?? 0;
                      controller.text = (cur + 5000).toStringAsFixed(0);
                      setDialogState(() {});
                    },
                  ),
                  ActionChip(
                    label: const Text('+ ₹10,000'),
                    onPressed: () {
                      final cur = double.tryParse(controller.text) ?? 0;
                      controller.text = (cur + 10000).toStringAsFixed(0);
                      setDialogState(() {});
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(controller.text.trim()) ?? 0;
                setState(() => _walletBalance += val);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Deposited ₹${val.toStringAsFixed(2)} to Wallet!'),
                    backgroundColor: const Color(0xFF166534),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7C3AED),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Deposit Funds'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddGoalDialog() {
    final titleController = TextEditingController();
    final targetController = TextEditingController();
    String category = 'Emergency Fund';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(LucideIcons.target, color: Color(0xFF7C3AED), size: 22),
              SizedBox(width: 10),
              Text('Create Financial Goal', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Goal Title',
                    hintText: 'e.g. 6-Month Emergency Cushion',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    labelText: 'Target Amount',
                    hintText: 'e.g. 150000',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Emergency Fund', child: Text('Emergency Fund')),
                    DropdownMenuItem(value: 'Investment Milestone', child: Text('Investment Milestone')),
                    DropdownMenuItem(value: 'Vehicle Purchase', child: Text('Vehicle Purchase')),
                    DropdownMenuItem(value: 'Home Renovation', child: Text('Home Renovation')),
                    DropdownMenuItem(value: 'Vacation / Travel', child: Text('Vacation / Travel')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => category = val);
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
                final title = titleController.text.trim().isEmpty ? 'Savings Goal' : titleController.text.trim();
                final target = double.tryParse(targetController.text.trim()) ?? 50000.0;
                setState(() {
                  _financialGoals.add({
                    'title': title,
                    'target': target,
                    'saved': 0.0,
                    'category': category,
                    'targetDate': 'Dec 2026',
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Goal "$title" created!'), backgroundColor: const Color(0xFF166534)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Create Goal'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddInvestmentDialog() {
    final assetNameController = TextEditingController();
    final costBasisController = TextEditingController();
    final marketValController = TextEditingController();
    final purchaseDateController = TextEditingController(text: '24/10/2026');
    String assetCategory = 'Stocks';

    final categories = [
      'Stocks',
      'Mutual Funds',
      'Fixed Deposit',
      'Crypto',
      'Gold',
      'Real Estate',
      'Bonds',
      'Other',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 440,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with circular close button (Screenshot 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Asset to Portfolio',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.x, size: 16, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ASSET NAME
                  const Text(
                    'ASSET NAME',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: assetNameController,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'e.g. HDFC Bank Ltd',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ASSET CATEGORY
                  const Text(
                    'ASSET CATEGORY',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: assetCategory,
                        isExpanded: true,
                        icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                        style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                        items: categories
                            .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => assetCategory = val);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // INVESTED AMOUNT & CURRENT VALUE
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'INVESTED AMOUNT',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: costBasisController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                                decoration: const InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CURRENT VALUE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              alignment: Alignment.centerLeft,
                              child: TextField(
                                controller: marketValController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                                decoration: const InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // PURCHASE DATE
                  const Text(
                    'PURCHASE DATE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        final formatted = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                        setModalState(() => purchaseDateController.text = formatted);
                      }
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              purchaseDateController.text.isEmpty ? 'dd/mm/yyyy' : purchaseDateController.text,
                              style: TextStyle(
                                fontSize: 13,
                                color: purchaseDateController.text.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Confirm Asset Addition Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = assetNameController.text.trim().isEmpty ? 'Portfolio Asset' : assetNameController.text.trim();
                        final cost = double.tryParse(costBasisController.text.trim()) ?? 10000.0;
                        final market = double.tryParse(marketValController.text.trim()) ?? cost;
                        setState(() {
                          _investments.add({
                            'name': name,
                            'class': assetCategory,
                            'costBasis': cost,
                            'marketValue': market,
                            'date': purchaseDateController.text,
                          });
                        });
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Added $name to Investment Portfolio!'), backgroundColor: const Color(0xFF4F46E5)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4F46E5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Confirm Asset Addition',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAddBillDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String category = 'Utilities / Electricity';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          title: const Row(
            children: [
              Icon(LucideIcons.bell, color: Color(0xFF166534), size: 22),
              SizedBox(width: 10),
              Text('Add Recurring Bill Reminder', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Biller Name / Description',
                    hintText: 'e.g. Electricity Board or Office Rent',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '₹ ',
                    labelText: 'Bill Amount',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Utilities / Electricity', child: Text('Utilities / Electricity')),
                    DropdownMenuItem(value: 'Internet & Telecom', child: Text('Internet & Telecom')),
                    DropdownMenuItem(value: 'Office Rent / Mortgage', child: Text('Office Rent / Mortgage')),
                    DropdownMenuItem(value: 'SaaS / Cloud Software', child: Text('SaaS / Cloud Software')),
                    DropdownMenuItem(value: 'Equipment Lease', child: Text('Equipment Lease')),
                  ],
                  onChanged: (val) {
                    if (val != null) setModalState(() => category = val);
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
                final title = titleController.text.trim().isEmpty ? 'Bill' : titleController.text.trim();
                final amt = double.tryParse(amountController.text.trim()) ?? 2500.0;
                setState(() {
                  _bills.add({
                    'title': title,
                    'amount': amt,
                    'category': category,
                    'dueDate': 'Due 1st of month',
                    'isPaid': false,
                  });
                });
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Bill reminder "$title" scheduled!'), backgroundColor: const Color(0xFF166534)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Save Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSourceDialog({required String title, required bool isIncome, required bool isFixed}) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    final amtController = TextEditingController();
    final dateController = TextEditingController(text: '24/10/2026');
    final timeController = TextEditingController(text: '12:00 PM');
    String category = 'Other';
    String associatedWallet = 'No Wallet';

    final categories = isIncome
        ? ['Other', 'Freelance', 'Salary', 'Dividends', 'Interest', 'Rental', 'Consulting']
        : ['Other', 'Office supplies', 'Utilities', 'Rent', 'Software', 'Marketing', 'Travel', 'Food'];

    final wallets = ['No Wallet', 'Main Wallet', 'Business Wallet', 'Savings Wallet'];

    final modalTitle = isIncome
        ? (isFixed ? 'Add Fixed Income' : 'Add Additional Income')
        : (isFixed ? 'Add Fixed Expense' : 'Add Additional Expense');
    final modalSubtitle = isIncome
        ? (isFixed ? 'Enter the details of your fixed income source below.' : 'Enter the details of your additional income source below.')
        : (isFixed ? 'Enter the details of your fixed expense below.' : 'Enter the details of your additional expense below.');
    final buttonLabel = isIncome ? 'Save Income' : 'Save Expense';
    final nameLabel = isIncome ? 'INCOME NAME' : 'EXPENSE NAME';
    final nameHint = isIncome ? 'e.g. Freelance project' : 'e.g. Office supplies';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            width: 460,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Circular Close Button (Screenshots 4 & 5)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              modalTitle,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              modalSubtitle,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(LucideIcons.x, size: 16, color: Color(0xFF64748B)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // NAME
                  Text(
                    nameLabel,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: nameController,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      decoration: InputDecoration(
                        hintText: nameHint,
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DESCRIPTION
                  const Text(
                    'DESCRIPTION',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: descController,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: 'Optional details...',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // DATE & TIME
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DATE',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (picked != null) {
                                  final formatted = '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
                                  setModalState(() => dateController.text = formatted);
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        dateController.text.isEmpty ? 'dd/mm/yyyy' : dateController.text,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: dateController.text.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    const Icon(LucideIcons.calendar, size: 16, color: Color(0xFF64748B)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'TIME',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                if (picked != null) {
                                  setModalState(() => timeController.text = picked.format(context));
                                }
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        timeController.text.isEmpty ? '-- : -- --' : timeController.text,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: timeController.text.isEmpty ? const Color(0xFF94A3B8) : const Color(0xFF0F172A),
                                        ),
                                      ),
                                    ),
                                    const Icon(LucideIcons.clock, size: 16, color: Color(0xFF64748B)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // CATEGORY & ASSOCIATED WALLET
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'CATEGORY',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: category,
                                  isExpanded: true,
                                  icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                                  items: categories
                                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => category = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'ASSOCIATED WALLET',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 42,
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: const Color(0xFFE2E8F0)),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: associatedWallet,
                                  isExpanded: true,
                                  icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
                                  style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A), fontWeight: FontWeight.w500),
                                  items: wallets
                                      .map((w) => DropdownMenuItem(value: w, child: Text(w)))
                                      .toList(),
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => associatedWallet = val);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // AMOUNT
                  const Text(
                    'AMOUNT (₹)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF475569),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    alignment: Alignment.centerLeft,
                    child: TextField(
                      controller: amtController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
                      decoration: const InputDecoration(
                        hintText: '0.00',
                        hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        final name = nameController.text.trim().isEmpty ? 'Entry' : nameController.text.trim();
                        final desc = descController.text.trim().isEmpty ? 'Optional details' : descController.text.trim();
                        final amt = double.tryParse(amtController.text.trim()) ?? 0.0;
                        final date = dateController.text.isEmpty ? '24/10/2026' : dateController.text;
                        final time = timeController.text.isEmpty ? '12:00 PM' : timeController.text;

                        final item = {
                          'name': name,
                          'description': desc,
                          'date': date,
                          'time': time,
                          'amount': amt,
                          'category': category,
                          'wallet': associatedWallet,
                          'schedule': isFixed ? 'Monthly' : 'One-time',
                        };

                        setState(() {
                          if (isFixed) {
                            if (isIncome) {
                              _fixedIncomes.add(item);
                            } else {
                              _fixedExpenses.add(item);
                              _monthlyExpenses += amt;
                            }
                          } else {
                            if (isIncome) {
                              _additionalIncomes.add(item);
                            } else {
                              _additionalExpenses.add(item);
                              _monthlyExpenses += amt;
                            }
                          }
                        });

                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved $name successfully!'), backgroundColor: const Color(0xFF166534)),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF166534),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonLabel,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _toggleSort({required bool isIncome, required bool isFixed, required String field}) {
    setState(() {
      if (!isFixed && isIncome) {
        _sortAscAdditionalIncome = !_sortAscAdditionalIncome;
        _sortList(_additionalIncomes, field, _sortAscAdditionalIncome);
      } else if (!isFixed && !isIncome) {
        _sortAscAdditionalExpense = !_sortAscAdditionalExpense;
        _sortList(_additionalExpenses, field, _sortAscAdditionalExpense);
      } else if (isFixed && isIncome) {
        _sortAscFixedIncome = !_sortAscFixedIncome;
        _sortList(_fixedIncomes, field, _sortAscFixedIncome);
      } else {
        _sortAscFixedExpense = !_sortAscFixedExpense;
        _sortList(_fixedExpenses, field, _sortAscFixedExpense);
      }
    });
  }

  void _sortList(List<Map<String, dynamic>> list, String field, bool asc) {
    list.sort((a, b) {
      final aVal = (a[field] ?? '').toString();
      final bVal = (b[field] ?? '').toString();
      return asc ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
    });
  }

  // ════════════════════════════════════════════════════════════════════════════
  // BUILD METHOD (FULL RESPONSIVE LAYOUT MATCHING SCREENSHOTS 1, 2, 3, 4)
  // ════════════════════════════════════════════════════════════════════════════

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
            // 1. HEADER (MATCHING SCREENSHOT 1)
            // ════════════════════════════════════════════════════════════════════
            if (isMobile) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF166534),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        '₹',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Finance',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.taxDeductions);
                    },
                    icon: const Icon(LucideIcons.shield, size: 14, color: Color(0xFFDC2626)),
                    label: const Text(
                      'Tax & Deductions',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
                      backgroundColor: const Color(0xFFFEF2F2),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Track your income, fixed costs, and daily spending in one place.',
                style: TextStyle(
                  fontSize: 12.5,
                  color: Color(0xFF64748B),
                ),
              ),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: const Color(0xFF166534),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text(
                        '₹',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Finance',
                          style: TextStyle(
                            fontSize: isDesktop ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF0F172A),
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Track your income, fixed costs, and daily spending in one place.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.taxDeductions);
                    },
                    icon: const Icon(LucideIcons.shield, size: 15, color: Color(0xFFDC2626)),
                    label: const Text(
                      'Tax & Deductions',
                      style: TextStyle(
                        color: Color(0xFFDC2626),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
                      backgroundColor: const Color(0xFFFEF2F2),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // ════════════════════════════════════════════════════════════════════
            // 2. BENTO STAT CARDS (TOTAL INCOME, TOTAL EXPENSES, SAVINGS, NET WORTH)
            // ════════════════════════════════════════════════════════════════════
            _buildTopBentoCards(isMobile, isDesktop),

            const SizedBox(height: 20),

            // ════════════════════════════════════════════════════════════════════
            // 3. ROW 2: INVESTMENT PORTFOLIO & ESTIMATED TAX DUE
            // ════════════════════════════════════════════════════════════════════
            if (isMobile) ...[
              _buildInvestmentPortfolioCard(),
              const SizedBox(height: 16),
              _buildEstimatedTaxCard(),
            ] else ...[
              Row(
                children: [
                  Expanded(child: _buildInvestmentPortfolioCard()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildEstimatedTaxCard()),
                ],
              ),
            ],

            const SizedBox(height: 20),

            // ════════════════════════════════════════════════════════════════════
            // 4. ROW 3: MY WALLET & BUDGET PLANNER
            // ════════════════════════════════════════════════════════════════════
            if (isMobile) ...[
              _buildMyWalletCard(),
              const SizedBox(height: 16),
              _buildBudgetPlannerCard(),
            ] else ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: _buildMyWalletCard()),
                  const SizedBox(width: 20),
                  Expanded(flex: 6, child: _buildBudgetPlannerCard()),
                ],
              ),
            ],

            const SizedBox(height: 24),

            // ════════════════════════════════════════════════════════════════════
            // 5. ROW 4: FINANCIAL GOALS (MATCHING SCREENSHOT 2)
            // ════════════════════════════════════════════════════════════════════
            _buildFinancialGoalsCard(),

            const SizedBox(height: 24),

            // ════════════════════════════════════════════════════════════════════
            // 6. ROW 5: INVESTMENT PORTFOLIO ASSET DETAILS (MATCHING SCREENSHOT 2)
            // ════════════════════════════════════════════════════════════════════
            _buildDetailedInvestmentPortfolioSection(),

            const SizedBox(height: 28),

            // ════════════════════════════════════════════════════════════════════
            // 7. ROW 6: ADDITIONAL SOURCE SECTION (MATCHING SCREENSHOT 3)
            // ════════════════════════════════════════════════════════════════════
            _buildAdditionalSourceSection(isMobile),

            const SizedBox(height: 28),

            // ════════════════════════════════════════════════════════════════════
            // 8. ROW 7: BILLS & REMINDERS (MATCHING SCREENSHOT 4)
            // ════════════════════════════════════════════════════════════════════
            _buildBillsAndRemindersCard(),

            const SizedBox(height: 28),

            // ════════════════════════════════════════════════════════════════════
            // 9. ROW 8: FIXED SOURCE SECTION (MATCHING SCREENSHOT 4)
            // ════════════════════════════════════════════════════════════════════
            _buildFixedSourceSection(isMobile),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // COMPONENT BUILDERS (PIXEL-PERFECT MATCHING USER SCREENSHOTS)
  // ════════════════════════════════════════════════════════════════════════════

  Widget _buildTopBentoCards(bool isMobile, bool isDesktop) {
    final incomeCard = _buildMetricCard(
      title: 'TOTAL INCOME',
      amount: '₹${_totalIncome.toStringAsFixed(0)}',
      color: const Color(0xFF047857),
      bgColor: const Color(0xFFECFDF5),
      borderColor: const Color(0xFFA7F3D0),
    );

    final expensesCard = _buildMetricCard(
      title: 'TOTAL EXPENSES',
      amount: '₹${_totalExpenses.toStringAsFixed(0)}',
      color: const Color(0xFFD97706),
      bgColor: const Color(0xFFFFFBEB),
      borderColor: const Color(0xFFFDE68A),
    );

    final savingsCard = _buildMetricCard(
      title: 'MONTHLY SAVINGS',
      amount: '₹${_monthlySavings.toStringAsFixed(0)}',
      color: const Color(0xFF7C3AED),
      bgColor: const Color(0xFFFAF5FF),
      borderColor: const Color(0xFFE9D5FF),
    );

    final netWorthCard = _buildMetricCard(
      title: 'NET WORTH',
      amount: '₹${_netWorth.toStringAsFixed(0)}',
      color: const Color(0xFF0F172A),
      bgColor: Colors.white,
      borderColor: const Color(0xFFE2E8F0),
    );

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: incomeCard),
          const SizedBox(width: 16),
          Expanded(child: expensesCard),
          const SizedBox(width: 16),
          Expanded(child: savingsCard),
          const SizedBox(width: 16),
          Expanded(child: netWorthCard),
        ],
      );
    }

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: incomeCard),
              const SizedBox(width: 12),
              Expanded(child: expensesCard),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: savingsCard),
              const SizedBox(width: 12),
              Expanded(child: netWorthCard),
            ],
          ),
        ],
      );
    }

    // Tablet: 2x2
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: incomeCard),
            const SizedBox(width: 16),
            Expanded(child: expensesCard),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: savingsCard),
            const SizedBox(width: 16),
            Expanded(child: netWorthCard),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String amount,
    required Color color,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: color.withValues(alpha: 0.85),
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestmentPortfolioCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'INVESTMENT PORTFOLIO',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: _showAddInvestmentDialog,
                child: const Icon(LucideIcons.arrowUpRight, color: Color(0xFF2563EB), size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '₹${_investmentMarketValue.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                child: Text(
                  '+% All-time',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Monthly P/L  +₹0',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatedTaxCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFEE2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'ESTIMATED TAX DUE',
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFDC2626),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  ref.read(navigationProvider.notifier).setRoute(AppRoute.taxDeductions);
                },
                child: const Icon(LucideIcons.shield, color: Color(0xFFDC2626), size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              '₹0',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0F172A),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Flexible(
                child: Text(
                  'Due by July 31st',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  'TDS Paid  ₹0',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMyWalletCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.wallet, color: Color(0xFF7C3AED), size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'My Wallet',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AVAILABLE BALANCE', style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '₹${_walletBalance.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: _showAddWalletFundsDialog,
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text('Add Funds', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C3AED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBudgetPlannerCard() {
    final double remaining = (_monthlyBudgetLimit - _monthlyExpenses).clamp(0.0, _monthlyBudgetLimit);
    final double usageRatio = _monthlyBudgetLimit > 0 ? (_monthlyExpenses / _monthlyBudgetLimit).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAF5FF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.target, color: Color(0xFF7C3AED), size: 18),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Budget Planner',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 3 Column Metrics
          Row(
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('MONTHLY BUDGET LIMIT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '₹${_monthlyBudgetLimit.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        InkWell(
                          onTap: _showEditBudgetDialog,
                          child: const Icon(LucideIcons.pencil, size: 14, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('EXPENSES', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '₹${_monthlyExpenses.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text('REMAINING', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    ),
                    const SizedBox(height: 4),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '₹${remaining.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Usage Progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Usage', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
              Text('${(usageRatio * 100).toStringAsFixed(0)}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: usageRatio,
              minHeight: 6,
              backgroundColor: const Color(0xFFF1F5F9),
              color: const Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialGoalsCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAF5FF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(LucideIcons.target, color: Color(0xFF7C3AED), size: 18),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Financial Goals',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Track your long-term milestones',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: _showAddGoalDialog,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAF5FF),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFE9D5FF)),
                    ),
                    child: const Icon(LucideIcons.plus, color: Color(0xFF7C3AED), size: 18),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            child: _financialGoals.isEmpty
                ? const Center(
                    child: Text(
                      'No goals defined. Start planning today!',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  )
                : Column(
                    children: _financialGoals
                        .map(
                          (g) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.checkCircle2, color: Color(0xFF7C3AED), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(g['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text('${g['category']} • Due: ${g['targetDate']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                Text(
                                  'Target: ₹${(g['target'] as num).toStringAsFixed(0)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                ),
                              ],
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

  Widget _buildDetailedInvestmentPortfolioSection() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 450;
                final titleSection = Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.pieChart, color: Color(0xFF4F46E5), size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Investment Portfolio',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Real-time asset allocation & performance',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                  ],
                );

                final addButton = ElevatedButton.icon(
                  onPressed: _showAddInvestmentDialog,
                  icon: const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                  label: const Text('Add Investment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleSection,
                      const SizedBox(height: 12),
                      addButton,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleSection),
                    const SizedBox(width: 8),
                    addButton,
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // 2 Metrics (Market Value & Cost Basis)
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('MARKET VALUE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Text(
                          '₹${_investmentMarketValue.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        const Text(' 0.00% (+₹0)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF16A34A))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('COST BASIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        const SizedBox(height: 6),
                        Text(
                          '₹${_investmentCostBasis.toStringAsFixed(0)}',
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        const SizedBox(height: 4),
                        const Text('Total Principal Invested', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Empty state or list
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: _investments.isEmpty
                ? const Center(
                    child: Text(
                      'Your portfolio is empty. Add your first asset!',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  )
                : Column(
                    children: _investments
                        .map(
                          (inv) => ListTile(
                            leading: const Icon(LucideIcons.coins, color: Color(0xFF4F46E5)),
                            title: Text(inv['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            subtitle: Text('${inv['class']} • Invested: ₹${(inv['costBasis'] as num).toStringAsFixed(0)}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                            trailing: Text(
                              '₹${(inv['marketValue'] as num).toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF16A34A)),
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

  Widget _buildAdditionalSourceSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.briefcase, color: Color(0xFF166534), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Source',
                    style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Manage your additional income sources and additional expenses here.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isMobile) ...[
          _buildSourceTableCard(
            title: 'ADDITIONAL SOURCE',
            subHeader: 'ADDITIONAL INCOME',
            searchHint: 'Search income',
            searchController: _additionalIncomeSearch,
            items: _filteredItems(_additionalIncomes, _additionalIncomeSearch.text),
            isIncome: true,
            isFixed: false,
            emptyText: 'No income sources added yet',
            onAdd: () => _showAddSourceDialog(title: 'Additional Income', isIncome: true, isFixed: false),
          ),
          const SizedBox(height: 16),
          _buildSourceTableCard(
            title: 'ADDITIONAL SOURCE',
            subHeader: 'ADDITIONAL EXPENSE',
            searchHint: 'Search addition',
            searchController: _additionalExpenseSearch,
            items: _filteredItems(_additionalExpenses, _additionalExpenseSearch.text),
            isIncome: false,
            isFixed: false,
            emptyText: 'No additional expenses added yet',
            onAdd: () => _showAddSourceDialog(title: 'Additional Expense', isIncome: false, isFixed: false),
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSourceTableCard(
                  title: 'ADDITIONAL SOURCE',
                  subHeader: 'ADDITIONAL INCOME',
                  searchHint: 'Search income',
                  searchController: _additionalIncomeSearch,
                  items: _filteredItems(_additionalIncomes, _additionalIncomeSearch.text),
                  isIncome: true,
                  isFixed: false,
                  emptyText: 'No income sources added yet',
                  onAdd: () => _showAddSourceDialog(title: 'Additional Income', isIncome: true, isFixed: false),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildSourceTableCard(
                  title: 'ADDITIONAL SOURCE',
                  subHeader: 'ADDITIONAL EXPENSE',
                  searchHint: 'Search addition',
                  searchController: _additionalExpenseSearch,
                  items: _filteredItems(_additionalExpenses, _additionalExpenseSearch.text),
                  isIncome: false,
                  isFixed: false,
                  emptyText: 'No additional expenses added yet',
                  onAdd: () => _showAddSourceDialog(title: 'Additional Expense', isIncome: false, isFixed: false),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBillsAndRemindersCard() {
    return Container(
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
          Padding(
            padding: const EdgeInsets.all(20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isCompact = constraints.maxWidth < 450;
                final titleSection = Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF5FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.bell, color: Color(0xFF7C3AED), size: 18),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Bills & Reminders',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                );

                final addBillButton = ElevatedButton.icon(
                  onPressed: _showAddBillDialog,
                  icon: const Icon(LucideIcons.plus, size: 14, color: Colors.white),
                  label: const Text('Add Bill', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF166534),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );

                if (isCompact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleSection,
                      const SizedBox(height: 12),
                      addBillButton,
                    ],
                  );
                }

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: titleSection),
                    const SizedBox(width: 8),
                    addBillButton,
                  ],
                );
              },
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            child: _bills.isEmpty
                ? const Center(
                    child: Text(
                      'No recurring bills set up. Add your first bill reminder!',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                    ),
                  )
                : Column(
                    children: _bills
                        .map(
                          (b) => Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: Row(
                              children: [
                                const Icon(LucideIcons.calendarCheck, color: Color(0xFF166534), size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(b['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                                      Text('${b['category']} • ${b['dueDate']}', style: const TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                                    ],
                                  ),
                                ),
                                Text(
                                  '₹${(b['amount'] as num).toStringAsFixed(2)}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                                ),
                              ],
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

  Widget _buildFixedSourceSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.briefcase, color: Color(0xFF166534), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fixed Source',
                    style: TextStyle(fontSize: isMobile ? 18 : 20, fontWeight: FontWeight.bold, color: const Color(0xFF0F172A)),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Manage your income sources and daily expenses here.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isMobile) ...[
          _buildSourceTableCard(
            title: 'FIXED SOURCE',
            subHeader: 'FIXED INCOME',
            searchHint: 'Search income',
            searchController: _fixedIncomeSearch,
            items: _filteredItems(_fixedIncomes, _fixedIncomeSearch.text),
            isIncome: true,
            isFixed: true,
            emptyText: 'No income sources added yet',
            onAdd: () => _showAddSourceDialog(title: 'Fixed Income', isIncome: true, isFixed: true),
          ),
          const SizedBox(height: 16),
          _buildSourceTableCard(
            title: 'ADDITIONAL SOURCE',
            subHeader: 'ADDITIONAL EXPENSE',
            searchHint: 'Search expen:',
            searchController: _fixedExpenseSearch,
            items: _filteredItems(_fixedExpenses, _fixedExpenseSearch.text),
            isIncome: false,
            isFixed: true,
            emptyText: 'No expenses added yet',
            onAdd: () => _showAddSourceDialog(title: 'Fixed Expense', isIncome: false, isFixed: true),
          ),
        ] else ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildSourceTableCard(
                  title: 'FIXED SOURCE',
                  subHeader: 'FIXED INCOME',
                  searchHint: 'Search income',
                  searchController: _fixedIncomeSearch,
                  items: _filteredItems(_fixedIncomes, _fixedIncomeSearch.text),
                  isIncome: true,
                  isFixed: true,
                  emptyText: 'No income sources added yet',
                  onAdd: () => _showAddSourceDialog(title: 'Fixed Income', isIncome: true, isFixed: true),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildSourceTableCard(
                  title: 'ADDITIONAL SOURCE',
                  subHeader: 'ADDITIONAL EXPENSE',
                  searchHint: 'Search expen:',
                  searchController: _fixedExpenseSearch,
                  items: _filteredItems(_fixedExpenses, _fixedExpenseSearch.text),
                  isIncome: false,
                  isFixed: true,
                  emptyText: 'No expenses added yet',
                  onAdd: () => _showAddSourceDialog(title: 'Fixed Expense', isIncome: false, isFixed: true),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  // Helper filter
  List<Map<String, dynamic>> _filteredItems(List<Map<String, dynamic>> src, String query) {
    if (query.trim().isEmpty) return src;
    final q = query.toLowerCase();
    return src.where((it) {
      final name = (it['name'] ?? '').toString().toLowerCase();
      final desc = (it['description'] ?? '').toString().toLowerCase();
      return name.contains(q) || desc.contains(q);
    }).toList();
  }

  Widget _buildSourceTableCard({
    required String title,
    required String subHeader,
    required String searchHint,
    required TextEditingController searchController,
    required List<Map<String, dynamic>> items,
    required bool isIncome,
    required bool isFixed,
    required String emptyText,
    required VoidCallback onAdd,
  }) {
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
          // Sub-card Title
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),

          // Search / Action bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF0FDF4),
              border: Border.symmetric(horizontal: BorderSide(color: Color(0xFFDCFCE7))),
            ),
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    subHeader,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: TextField(
                      controller: searchController,
                      style: const TextStyle(fontSize: 12),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(LucideIcons.search, size: 14, color: Color(0xFF94A3B8)),
                        hintText: searchHint,
                        hintStyle: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (val) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: onAdd,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Icon(LucideIcons.plus, size: 14, color: Color(0xFF0F172A)),
                  ),
                ),
              ],
            ),
          ),

          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            color: const Color(0xFFF1F5F9),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 420),
                child: Row(
                  children: [
                    SizedBox(
                      width: 110,
                      child: InkWell(
                        onTap: () => _toggleSort(isIncome: isIncome, isFixed: isFixed, field: 'name'),
                        child: const Text('NAME  ⇅', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: InkWell(
                        onTap: () => _toggleSort(isIncome: isIncome, isFixed: isFixed, field: 'description'),
                        child: const Text('DESCRIPTION  ⇅', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      ),
                    ),
                    SizedBox(
                      width: 80,
                      child: InkWell(
                        onTap: () => _toggleSort(isIncome: isIncome, isFixed: isFixed, field: 'date'),
                        child: const Text('DATE  ⇅', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      ),
                    ),
                    const SizedBox(width: 60, child: Text('TIME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                    SizedBox(
                      width: 70,
                      child: InkWell(
                        onTap: () => _toggleSort(isIncome: isIncome, isFixed: isFixed, field: isFixed ? 'schedule' : 'amount'),
                        child: Text(isFixed ? 'SCHEDULE  ⇅' : 'AMOUNT  ⇅', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569))),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Table Content / Empty state
          items.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(
                    child: Text(
                      emptyText,
                      style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
                    ),
                  ),
                )
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 420),
                    child: Column(
                      children: items.map((row) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 110, child: Text(row['name'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                              SizedBox(width: 120, child: Text(row['description'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                              SizedBox(width: 80, child: Text(row['date'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                              SizedBox(width: 60, child: Text(row['time'] ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)))),
                              SizedBox(
                                width: 70,
                                child: Text(
                                  isFixed ? (row['schedule'] ?? 'Monthly') : '₹${(row['amount'] as num).toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isIncome ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
