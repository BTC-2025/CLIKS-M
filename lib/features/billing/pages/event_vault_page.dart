import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class EventVaultPage extends StatefulWidget {
  const EventVaultPage({super.key});

  @override
  State<EventVaultPage> createState() => _EventVaultPageState();
}

class _EventVaultPageState extends State<EventVaultPage> {
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Goa Vacation Trip 2026',
      'category': 'Travel',
      'budget': 50000,
      'spent': 38500,
      'items': [
        {'name': 'Flight Tickets', 'cost': 18000},
        {'name': 'Resort Deposit', 'cost': 14500},
        {'name': 'Bike Rental', 'cost': 6000},
      ],
      'icon': LucideIcons.plane,
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Diwali Festive Shopping',
      'category': 'Shopping',
      'budget': 35000,
      'spent': 15000,
      'items': [
        {'name': 'Family Ethnic Wear', 'cost': 10000},
        {'name': 'Sweets & Gifts', 'cost': 5000},
      ],
      'icon': LucideIcons.sparkles,
      'color': const Color(0xFFD946EF),
    },
    {
      'title': 'Home Office Setup',
      'category': 'Lifestyle',
      'budget': 60000,
      'spent': 45000,
      'items': [
        {'name': 'Ergonomic Desk & Chair', 'cost': 28000},
        {'name': 'Monitor Arm & Lighting', 'cost': 17000},
      ],
      'icon': LucideIcons.laptop,
      'color': const Color(0xFF059669),
    },
    {
      'title': 'Family Wedding Expense',
      'category': 'Family',
      'budget': 100000,
      'spent': 20000,
      'items': [
        {'name': 'Venue Booking Advance', 'cost': 20000},
      ],
      'icon': LucideIcons.heartHandshake,
      'color': const Color(0xFF7C3AED),
    },
  ];

  double get _totalBudget => _events.fold(0, (sum, item) => sum + (item['budget'] as num));
  double get _totalSpent => _events.fold(0, (sum, item) => sum + (item['spent'] as num));

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
            // Header
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // Summary Metrics Row
            _buildSummaryRow(isMobile).animate().fadeIn(duration: 450.ms, delay: 50.ms),
            const SizedBox(height: 24),

            // Section Subheader
            const Text(
              'Active Event Vaults',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
            ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
            const SizedBox(height: 16),

            // Event Cards Grid
            _buildEventGrid(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

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
                child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Event Expenses', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    SizedBox(height: 2),
                    Text('Isolate life event budgets from regular monthly reports.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openCreateEventModal(isMobile),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Create Event Vault', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.sparkles, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Event Expense Vault', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                SizedBox(height: 4),
                Text('Isolate life event budgets from regular monthly reports.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openCreateEventModal(isMobile),
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Create Event Vault', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5132),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryCell('TOTAL EVENT BUDGET', '₹${_totalBudget.toStringAsFixed(0)}', const Color(0xFF2563EB)),
          Container(height: 35, width: 1, color: Colors.grey.shade200),
          _buildSummaryCell('SPENT SO FAR', '₹${_totalSpent.toStringAsFixed(0)}', const Color(0xFF059669)),
          Container(height: 35, width: 1, color: Colors.grey.shade200),
          _buildSummaryCell('REMAINING POOL', '₹${(_totalBudget - _totalSpent).toStringAsFixed(0)}', const Color(0xFFD946EF)),
        ],
      ),
    );
  }

  Widget _buildSummaryCell(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: color)),
          ),
        ],
      ),
    );
  }

  Widget _buildEventGrid(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 850 ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: _events.map((ev) {
            final budget = (ev['budget'] as num).toDouble();
            final spent = (ev['spent'] as num).toDouble();
            final ratio = (spent / budget).clamp(0.0, 1.0);
            final items = List<Map<String, dynamic>>.from(ev['items'] ?? []);

            return Container(
              width: cardWidth,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: (ev['color'] as Color).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(ev['icon'] as IconData, color: ev['color'] as Color, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(ev['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText), maxLines: 2, softWrap: true),
                                  Text(ev['category'] as String, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                            child: Text('${(ratio * 100).toStringAsFixed(0)}% Used', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              final title = ev['title'];
                              setState(() {
                                _events.remove(ev);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$title deleted from Event Expenses'),
                                  backgroundColor: const Color(0xFF0F5132),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444), size: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation<Color>(ratio > 0.85 ? Colors.redAccent : (ev['color'] as Color)),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Spent: ₹${spent.toStringAsFixed(0)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                      Text('Budget: ₹${budget.toStringAsFixed(0)}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 12),

                  Text('TAGGED EXPENSES (${items.length})', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade500, letterSpacing: 0.5)),
                  const SizedBox(height: 8),

                  ...items.map((it) => Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(it['name'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade700), overflow: TextOverflow.ellipsis),
                            ),
                            Row(
                              children: [
                                Text('₹${it['cost']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                                const SizedBox(width: 8),
                                InkWell(
                                  onTap: () {
                                    final itemName = it['name'];
                                    final itemCost = (it['cost'] as num).toDouble();
                                    setState(() {
                                      final currentItems = List<Map<String, dynamic>>.from(ev['items'] ?? []);
                                      currentItems.remove(it);
                                      ev['items'] = currentItems;
                                      ev['spent'] = (((ev['spent'] as num).toDouble()) - itemCost).clamp(0.0, double.infinity);
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('$itemName removed from ${ev['title']}'),
                                        backgroundColor: const Color(0xFF0F5132),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(6),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFEF2F2),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Icon(LucideIcons.x, size: 13, color: Color(0xFFEF4444)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),

                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _openLogExpenseModal(ev, isMobile),
                      icon: const Icon(LucideIcons.plus, size: 14),
                      label: const Text('Log Expense to Vault', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0F5132),
                        side: const BorderSide(color: Color(0xFF0F5132)),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
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

  void _openCreateEventModal(bool isMobile) {
    final titleCtrl = TextEditingController();
    final budgetCtrl = TextEditingController();

    void submit() {
      if (titleCtrl.text.isNotEmpty && budgetCtrl.text.isNotEmpty) {
        setState(() {
          _events.add({
            'title': titleCtrl.text,
            'category': 'General',
            'budget': double.tryParse(budgetCtrl.text) ?? 20000,
            'spent': 0.0,
            'items': [],
            'icon': LucideIcons.sparkles,
            'color': const Color(0xFF059669),
          });
        });
      }
      Navigator.pop(context);
    }

    final content = SingleChildScrollView(
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
                    Text('Create Event Vault', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    SizedBox(height: 2),
                    Text('Set up a dedicated budget for your upcoming life event.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: const Icon(LucideIcons.x, size: 16, color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField('EVENT TITLE *', 'e.g. Europe Vacation 2026', titleCtrl),
          const SizedBox(height: 12),
          _buildInputField('TARGET EVENT BUDGET (₹) *', 'e.g. 150000', budgetCtrl),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Initialize Event Vault', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => FractionallySizedBox(heightFactor: 0.65, child: Padding(padding: const EdgeInsets.all(20), child: content)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Container(width: 480, padding: const EdgeInsets.all(24), child: content)),
      );
    }
  }

  void _openLogExpenseModal(Map<String, dynamic> ev, bool isMobile) {
    final itemCtrl = TextEditingController();
    final costCtrl = TextEditingController();

    void submit() {
      if (itemCtrl.text.isNotEmpty && costCtrl.text.isNotEmpty) {
        final cost = double.tryParse(costCtrl.text) ?? 500;
        setState(() {
          final currentItems = List<Map<String, dynamic>>.from(ev['items'] ?? []);
          currentItems.add({'name': itemCtrl.text, 'cost': cost.toInt()});
          ev['items'] = currentItems;
          ev['spent'] = ((ev['spent'] as num).toDouble()) + cost;
        });
      }
      Navigator.pop(context);
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Log Expense: ${ev['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText)),
        const SizedBox(height: 16),
        _buildInputField('ITEM NAME *', 'e.g. Dinner Receipt', itemCtrl),
        const SizedBox(height: 12),
        _buildInputField('AMOUNT (₹) *', 'e.g. 2500', costCtrl),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F5132),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Add to Event Ledger', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => FractionallySizedBox(heightFactor: 0.6, child: Padding(padding: const EdgeInsets.all(20), child: content)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Container(width: 450, padding: const EdgeInsets.all(24), child: content)),
      );
    }
  }

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
          ),
        ),
      ],
    );
  }
}
