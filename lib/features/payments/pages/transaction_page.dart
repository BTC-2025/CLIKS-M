import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _transactions = [
    {
      'id': '1',
      'title': 'rent giving',
      'category': 'Rental',
      'rate': 45,
      'amount': -1000.0,
      'type': 'expense',
      'icon': LucideIcons.dollarSign,
      'date': '07-08-2026',
    },
    {
      'id': '2',
      'title': 'salary',
      'category': 'Employment',
      'rate': 30,
      'amount': 3000.0,
      'type': 'income',
      'icon': LucideIcons.briefcase,
      'date': '01-08-2026',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _addTransaction(Map<String, dynamic> tx) {
    setState(() {
      _transactions.insert(0, tx);
    });
  }

  void _deleteTransaction(int index) {
    final tx = _transactions[index];
    setState(() {
      _transactions.removeAt(index);
    });
    AppSnackbar.show(
      context,
      "Transaction '${tx['title']}' deleted.",
      type: SnackType.info,
    );
  }

  void _showAddIncomeSheet() {
    final nameController = TextEditingController();
    final amountController = TextEditingController(text: '0');
    final dateController = TextEditingController(text: _formatDate(DateTime.now()));
    final notesController = TextEditingController();
    String selectedCategory = 'Salary';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle Bar
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Income',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 18, color: Colors.black54),
                        onPressed: () => Navigator.pop(ctx),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 20),

                  // SOURCE NAME
                  const Text('SOURCE NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText),
                    decoration: InputDecoration(
                      hintText: 'e.g. Salary, Freelance',
                      hintStyle: const TextStyle(color: Color(0xFFC1C7D0), fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF4FBF7),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CATEGORY
                  const Text('CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    icon: const Icon(LucideIcons.chevronDown, size: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF4FBF7),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                      ),
                    ),
                    items: ['Salary', 'Freelance', 'Employment', 'Investments', 'Business', 'Other']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13, color: AppColors.darkText))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // AMOUNT & DATE ROW
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AMOUNT (₹)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF4FBF7),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
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
                            const Text('DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  setModalState(() => dateController.text = _formatDate(date));
                                }
                              },
                              style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(LucideIcons.calendar, size: 16, color: AppColors.secondaryText),
                                filled: true,
                                fillColor: const Color(0xFFF4FBF7),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // NOTES
                  const Text('NOTES (OPTIONAL)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                    decoration: InputDecoration(
                      hintText: 'Additional details...',
                      hintStyle: const TextStyle(color: Color(0xFFC1C7D0), fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF4FBF7),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // BUTTONS ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkText,
                          side: const BorderSide(color: Color(0xFFE5EAF4)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final title = nameController.text.trim();
                          final amount = double.tryParse(amountController.text.trim()) ?? 0;
                          if (title.isNotEmpty && amount > 0) {
                            _addTransaction({
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'title': title,
                              'category': selectedCategory,
                              'rate': 30,
                              'amount': amount,
                              'type': 'income',
                              'icon': LucideIcons.briefcase,
                              'date': dateController.text,
                            });
                            Navigator.pop(ctx);
                            AppSnackbar.show(
                              context,
                              "Income '₹${amount.toInt()}' recorded!",
                              type: SnackType.success,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF084421),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Save Income', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddExpenseSheet() {
    final nameController = TextEditingController();
    final amountController = TextEditingController(text: '0');
    final dateController = TextEditingController(text: _formatDate(DateTime.now()));
    final notesController = TextEditingController();
    String selectedCategory = 'Rental';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
              left: 24,
              right: 24,
              top: 16,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle Bar
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Header Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Expense',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 18, color: Colors.black54),
                        onPressed: () => Navigator.pop(ctx),
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.grey.shade100,
                          shape: const CircleBorder(),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 20),

                  // EXPENSE NAME
                  const Text('EXPENSE NAME', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.darkText),
                    decoration: InputDecoration(
                      hintText: 'e.g. Rent, Groceries',
                      hintStyle: const TextStyle(color: Color(0xFFC1C7D0), fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF4FBF7),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CATEGORY
                  const Text('CATEGORY', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    icon: const Icon(LucideIcons.chevronDown, size: 16),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF4FBF7),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                      ),
                    ),
                    items: ['Rental', 'Food & Groceries', 'Utilities', 'Shopping', 'Transport', 'Other']
                        .map((cat) => DropdownMenuItem(value: cat, child: Text(cat, style: const TextStyle(fontSize: 13, color: AppColors.darkText))))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedCategory = val);
                    },
                  ),
                  const SizedBox(height: 16),

                  // AMOUNT & DATE ROW
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('AMOUNT (₹)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF4FBF7),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
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
                            const Text('DATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                            const SizedBox(height: 6),
                            TextField(
                              controller: dateController,
                              readOnly: true,
                              onTap: () async {
                                final date = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2030),
                                );
                                if (date != null) {
                                  setModalState(() => dateController.text = _formatDate(date));
                                }
                              },
                              style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                              decoration: InputDecoration(
                                suffixIcon: const Icon(LucideIcons.calendar, size: 16, color: AppColors.secondaryText),
                                filled: true,
                                fillColor: const Color(0xFFF4FBF7),
                                isDense: true,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // NOTES
                  const Text('NOTES (OPTIONAL)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF5A7184))),
                  const SizedBox(height: 6),
                  TextField(
                    controller: notesController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                    decoration: InputDecoration(
                      hintText: 'Additional details...',
                      hintStyle: const TextStyle(color: Color(0xFFC1C7D0), fontSize: 13),
                      filled: true,
                      fillColor: const Color(0xFFF4FBF7),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE5EAF4)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // BUTTONS ROW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkText,
                          side: const BorderSide(color: Color(0xFFE5EAF4)),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          final title = nameController.text.trim();
                          final amount = double.tryParse(amountController.text.trim()) ?? 0;
                          if (title.isNotEmpty && amount > 0) {
                            _addTransaction({
                              'id': DateTime.now().millisecondsSinceEpoch.toString(),
                              'title': title,
                              'category': selectedCategory,
                              'rate': 45,
                              'amount': -amount,
                              'type': 'expense',
                              'icon': LucideIcons.dollarSign,
                              'date': dateController.text,
                            });
                            Navigator.pop(ctx);
                            AppSnackbar.show(
                              context,
                              "Expense '₹${amount.toInt()}' recorded!",
                              type: SnackType.success,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF084421),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Save Expense', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    return '$d-$m-${date.year}';
  }

  Widget _buildHeader(bool isMobile) {
    final titleCol = const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transactions',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        SizedBox(height: 4),
        Text(
          'Track and manage your financial activity',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
        ),
      ],
    );

    final actionsRow = PopupMenuButton<String>(
      offset: const Offset(0, 45),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      color: Colors.white,
      onSelected: (value) {
        if (value == 'income') {
          _showAddIncomeSheet();
        } else if (value == 'expense') {
          _showAddExpenseSheet();
        }
      },
      itemBuilder: (ctx) => [
        PopupMenuItem<String>(
          value: 'income',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD1FAE5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.arrowUpRight, color: Color(0xFF10B981), size: 18),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Income', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  SizedBox(height: 2),
                  Text('Salary, Freelance...', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                ],
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'expense',
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEE2E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(LucideIcons.arrowDownRight, color: Color(0xFFEF4444), size: 18),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add Expense', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  SizedBox(height: 2),
                  Text('Bills, Food, Shop...', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                ],
              ),
            ],
          ),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F5132),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.plus, size: 16, color: Colors.white),
            SizedBox(width: 8),
            Text('Record Transaction', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
            SizedBox(width: 6),
            Icon(LucideIcons.chevronDown, size: 14, color: Colors.white),
          ],
        ),
      ),
    );

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleCol,
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: actionsRow),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              titleCol,
              actionsRow,
            ],
          );
  }

  Widget _buildStatCards(bool isMobile) {
    final double totalIncome = _transactions.where((t) => t['type'] == 'income').fold(0.0, (s, t) => s + (t['amount'] as double));
    final double totalExpenses = _transactions.where((t) => t['type'] == 'expense').fold(0.0, (s, t) => s + (t['amount'] as double).abs());
    final double netBalance = totalIncome - totalExpenses;
    final bool isDeficit = totalExpenses > totalIncome;

    final cardsData = [
      {
        'title': 'Total Income',
        'value': '₹${totalIncome.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
        'subtitle': 'Actual • This Month',
        'icon': LucideIcons.trendingUp,
        'iconColor': const Color(0xFF10B981),
        'bgColor': const Color(0xFFD1FAE5),
        'borderColor': AppColors.border,
        'cardBgColor': Colors.white,
        'subtitleColor': AppColors.secondaryText,
        'isDeficit': false,
      },
      {
        'title': 'Total Expenses',
        'value': '₹${totalExpenses.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
        'subtitle': isDeficit ? '⚠️ High Spending' : 'Actual • This Month',
        'icon': LucideIcons.trendingDown,
        'iconColor': const Color(0xFFEF4444),
        'bgColor': const Color(0xFFFEE2E2),
        'borderColor': isDeficit ? const Color(0xFFFCA5A5) : AppColors.border,
        'cardBgColor': isDeficit ? const Color(0xFFFFF5F5) : Colors.white,
        'subtitleColor': isDeficit ? const Color(0xFFDC2626) : AppColors.secondaryText,
        'isDeficit': false,
      },
      {
        'title': 'Net Balance',
        'value': isDeficit
            ? '-₹${(netBalance.abs()).toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}'
            : '₹${netBalance.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
        'subtitle': isDeficit ? '⚠️ Expense Above Income' : 'Cash Flow Status',
        'icon': isDeficit ? LucideIcons.alertTriangle : LucideIcons.wallet,
        'iconColor': isDeficit ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        'bgColor': isDeficit ? const Color(0xFFFEE2E2) : const Color(0xFFECFDF5),
        'borderColor': isDeficit ? const Color(0xFFEF4444) : AppColors.border,
        'cardBgColor': isDeficit ? const Color(0xFFFEF2F2) : Colors.white,
        'subtitleColor': isDeficit ? const Color(0xFFDC2626) : AppColors.secondaryText,
        'isDeficit': isDeficit,
      },
    ];

    Widget buildSingleStatCard(Map<String, dynamic> c, {required bool isMobileCard}) {
      final double paddingVal = isMobileCard ? 14.0 : 20.0;
      final double valueFontSize = isMobileCard ? 18.0 : 24.0;
      final double titleFontSize = isMobileCard ? 11.0 : 13.0;
      final Color borderColor = (c['borderColor'] as Color?) ?? AppColors.border;
      final Color cardBg = (c['cardBgColor'] as Color?) ?? Colors.white;
      final Color subtitleColor = (c['subtitleColor'] as Color?) ?? AppColors.secondaryText;
      final bool cardDeficit = (c['isDeficit'] as bool?) ?? false;

      return Container(
        padding: EdgeInsets.all(paddingVal),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: cardDeficit ? 1.8 : 1.0),
          boxShadow: [
            BoxShadow(
              color: cardDeficit ? const Color(0xFFEF4444).withValues(alpha: 0.12) : Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    c['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: cardDeficit ? const Color(0xFF991B1B) : AppColors.secondaryText,
                      fontWeight: cardDeficit ? FontWeight.bold : FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(isMobileCard ? 6 : 8),
                  decoration: BoxDecoration(
                    color: c['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(c['icon'] as IconData, color: c['iconColor'] as Color, size: isMobileCard ? 14 : 16),
                ),
              ],
            ),
            SizedBox(height: isMobileCard ? 6 : 10),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                c['value'] as String,
                style: TextStyle(
                  fontSize: valueFontSize,
                  fontWeight: FontWeight.bold,
                  color: cardDeficit ? const Color(0xFFDC2626) : AppColors.darkText,
                ),
              ),
            ),
            SizedBox(height: isMobileCard ? 4 : 8),
            Text(
              c['subtitle'] as String,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: isMobileCard ? 10 : 11,
                color: subtitleColor,
                fontWeight: cardDeficit ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      );
    }

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: buildSingleStatCard(cardsData[0], isMobileCard: true)),
              const SizedBox(width: 12),
              Expanded(child: buildSingleStatCard(cardsData[1], isMobileCard: true)),
            ],
          ),
          const SizedBox(height: 12),
          buildSingleStatCard(cardsData[2], isMobileCard: true),
        ],
      );
    }

    return Row(
      children: cardsData
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: buildSingleStatCard(c, isMobileCard: false),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildSearchFilterBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: isMobile
          ? Column(
              children: [
                TextField(
                  controller: _searchController,
                  style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
                    prefixIcon: const Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          AppSnackbar.show(context, "Filter options loaded.", type: SnackType.info);
                        },
                        icon: const Icon(LucideIcons.filter, size: 14),
                        label: const Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkText,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          AppSnackbar.show(context, "Date filter loaded.", type: SnackType.info);
                        },
                        icon: const Icon(LucideIcons.calendar, size: 14),
                        label: const Text('This Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.darkText,
                          side: const BorderSide(color: AppColors.border),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(fontSize: 13, color: AppColors.darkText),
                    decoration: InputDecoration(
                      hintText: 'Search transactions...',
                      hintStyle: const TextStyle(color: AppColors.secondaryText, fontSize: 13),
                      prefixIcon: const Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    AppSnackbar.show(context, "Filter options loaded.", type: SnackType.info);
                  },
                  icon: const Icon(LucideIcons.filter, size: 14),
                  label: const Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkText,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {
                    AppSnackbar.show(context, "Date filter loaded.", type: SnackType.info);
                  },
                  icon: const Icon(LucideIcons.calendar, size: 14),
                  label: const Text('This Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkText,
                    side: const BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTransactionsListCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(LucideIcons.filter, size: 16, color: AppColors.secondaryText),
                  SizedBox(width: 8),
                  Text(
                    'List of Transactions',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {},
                child: const Text('See All', style: TextStyle(color: Color(0xFF6366F1), fontWeight: FontWeight.bold, fontSize: 13)),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (isMobile)
            Column(
              children: _transactions.asMap().entries.map((entry) {
                final index = entry.key;
                final tx = entry.value;
                final isIncome = tx['type'] == 'income';
                final amountVal = (tx['amount'] as double).abs().toInt();
                final amountStr = isIncome ? '₹$amountVal' : '-₹$amountVal';
                final rate = tx['rate'] as int;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Icon(tx['icon'] as IconData, size: 18, color: AppColors.darkText),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tx['title'] as String,
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${tx['category']} • Rate $rate%',
                              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            amountStr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: isIncome ? const Color(0xFF10B981) : AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 4),
                          IconButton(
                            icon: const Icon(LucideIcons.trash2, size: 14, color: AppColors.secondaryText),
                            onPressed: () => _deleteTransaction(index),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }).toList(),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 700),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(40),
                    1: FlexColumnWidth(2.5),
                    2: FlexColumnWidth(1.5),
                    3: FlexColumnWidth(2),
                    4: FlexColumnWidth(1.5),
                    5: FixedColumnWidth(60),
                  },
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    // Column Headers
                    TableRow(
                      decoration: const BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                      ),
                      children: [
                        const SizedBox(height: 36),
                        const Text('APPLICATION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8C9BA5), letterSpacing: 0.5)),
                        const Text('TYPE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8C9BA5), letterSpacing: 0.5)),
                        const Text('RATE', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8C9BA5), letterSpacing: 0.5)),
                        const AlignmentText('AMOUNT', Alignment.centerRight),
                        const AlignmentText('ACTIONS', Alignment.centerRight),
                      ],
                    ),
                    ..._transactions.asMap().entries.map((entry) {
                      final index = entry.key;
                      final tx = entry.value;
                      final isIncome = tx['type'] == 'income';
                      final amountVal = (tx['amount'] as double).abs().toInt();
                      final amountStr = isIncome ? '₹$amountVal' : '-₹$amountVal';
                      final rate = tx['rate'] as int;
                      final rateColor = isIncome ? const Color(0xFF6366F1) : const Color(0xFF10B981);

                      return TableRow(
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9), width: 1)),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Checkbox(
                              value: false,
                              onChanged: (_) {},
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(tx['icon'] as IconData, size: 16, color: AppColors.darkText),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  tx['title'] as String,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            tx['category'] as String,
                            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 80,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: rate / 100,
                                    minHeight: 6,
                                    backgroundColor: const Color(0xFFE2E8F0),
                                    valueColor: AlwaysStoppedAnimation<Color>(rateColor),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text('$rate%', style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          AlignmentText(
                            amountStr,
                            Alignment.centerRight,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isIncome ? const Color(0xFF10B981) : AppColors.darkText,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: IconButton(
                              icon: const Icon(LucideIcons.trash2, size: 16, color: AppColors.secondaryText),
                              onPressed: () => _deleteTransaction(index),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
            const SizedBox(height: 24),

            // Stat Cards Row
            _buildStatCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 24),

            // Search & Filter Control Bar
            _buildSearchFilterBar(isMobile).animate().fadeIn(duration: 450.ms, delay: 150.ms),
            const SizedBox(height: 24),

            // Transactions List Card
            _buildTransactionsListCard(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class AlignmentText extends StatelessWidget {
  final String text;
  final Alignment alignment;
  final TextStyle? style;

  const AlignmentText(this.text, this.alignment, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Text(
        text,
        style: style ?? const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF8C9BA5), letterSpacing: 0.5),
      ),
    );
  }
}
