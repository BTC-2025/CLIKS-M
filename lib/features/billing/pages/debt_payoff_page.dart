import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class DebtPayoffPage extends StatefulWidget {
  const DebtPayoffPage({super.key});

  @override
  State<DebtPayoffPage> createState() => _DebtPayoffPageState();
}

class _DebtPayoffPageState extends State<DebtPayoffPage> {
  int _strategyIndex = 0; // 0: Avalanche (High Interest First), 1: Snowball (Small Balance First)

  final List<Map<String, dynamic>> _debts = [
    {
      'title': 'HDFC Regalia Credit Card',
      'lender': 'HDFC Bank',
      'balance': 45000,
      'original': 100000,
      'interestRate': '42% p.a.',
      'minEmi': 4500,
      'isTopTarget': true,
      'color': const Color(0xFFEF4444),
    },
    {
      'title': 'ICICI Personal Loan',
      'lender': 'ICICI Bank',
      'balance': 180000,
      'original': 300000,
      'interestRate': '12.5% p.a.',
      'minEmi': 9000,
      'isTopTarget': false,
      'color': const Color(0xFF2563EB),
    },
    {
      'title': 'Borrowed from Friend (Rahul)',
      'lender': 'Personal',
      'balance': 120000,
      'original': 150000,
      'interestRate': '0% p.a.',
      'minEmi': 5000,
      'isTopTarget': false,
      'color': const Color(0xFF059669),
    },
  ];

  double get _totalBalance => _debts.fold(0, (sum, item) => sum + (item['balance'] as num));
  double get _totalOriginal => _debts.fold(0, (sum, item) => sum + (item['original'] as num));
  double get _totalEmi => _debts.fold(0, (sum, item) => sum + (item['minEmi'] as num));

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

            // Strategy Switcher Pill Bar
            _buildStrategySwitcher(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 20),

            // Debt Cards List
            _buildDebtsList(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
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
                child: const Icon(LucideIcons.trendingDown, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Debt Payoff Planner', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    SizedBox(height: 2),
                    Text('Accelerate freedom using Snowball or Avalanche strategies.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openAddDebtModal(isMobile),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Add Debt Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
              child: const Icon(LucideIcons.trendingDown, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debt & Loan Payoff Planner', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                SizedBox(height: 4),
                Text('Accelerate freedom using Snowball or Avalanche strategies.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddDebtModal(isMobile),
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Add Debt Account', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
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
          _buildSummaryCell('TOTAL DEBT OUTSTANDING', '₹${_totalBalance.toStringAsFixed(0)}', const Color(0xFFEF4444)),
          Container(height: 35, width: 1, color: Colors.grey.shade200),
          _buildSummaryCell('TOTAL MONTHLY EMI', '₹${_totalEmi.toStringAsFixed(0)}', const Color(0xFF2563EB)),
          Container(height: 35, width: 1, color: Colors.grey.shade200),
          _buildSummaryCell('TARGET DEBT-FREE', 'Nov 2027', const Color(0xFF059669)),
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

  Widget _buildStrategySwitcher(bool isMobile) {
    return Column(
      children: [
        // Strategy Explainer Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8, offset: const Offset(0, 2)),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _strategyIndex == 0 ? const Color(0xFFEFF6FF) : const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _strategyIndex == 0 ? LucideIcons.mountain : LucideIcons.snowflake,
                  color: _strategyIndex == 0 ? const Color(0xFF2563EB) : const Color(0xFF059669),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _strategyIndex == 0 ? '🏔️ What is Debt Avalanche?' : '❄️ What is Debt Snowball?',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _strategyIndex == 0
                          ? 'Pays highest interest rate loans first (e.g. Credit Cards @ 42%). Mathematically saves you maximum interest money!'
                          : 'Pays smallest loan balance first regardless of interest rate. Gives fast psychological wins & momentum!',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFFECFDF5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStrategyPill(0, '🏔️ Avalanche (Save Interest)'),
                  const SizedBox(width: 4),
                  _buildStrategyPill(1, '❄️ Snowball (Quick Wins)'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStrategyPill(int index, String label) {
    final isSelected = _strategyIndex == index;
    return InkWell(
      onTap: () => setState(() => _strategyIndex = index),
      borderRadius: BorderRadius.circular(26),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F172A) : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade800),
        ),
      ),
    );
  }

  Widget _buildDebtsList(bool isMobile) {
    // Sort based on strategy
    final sortedDebts = List<Map<String, dynamic>>.from(_debts);
    if (_strategyIndex == 0) {
      // Avalanche: highest interest rate first
      sortedDebts.sort((a, b) => b['interestRate'].compareTo(a['interestRate']));
    } else {
      // Snowball: smallest balance first
      sortedDebts.sort((a, b) => (a['balance'] as num).compareTo(b['balance'] as num));
    }

    return Column(
      children: sortedDebts.map((d) {
        final bal = (d['balance'] as num).toDouble();
        final orig = (d['original'] as num).toDouble();
        final emi = (d['minEmi'] as num).toDouble();
        final paidRatio = ((orig - bal) / orig).clamp(0.0, 1.0);
        final monthsLeft = emi > 0 ? (bal / emi).ceil() : 0;

        return Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: (d['isTopTarget'] as bool) ? Border.all(color: const Color(0xFFEF4444), width: 1.5) : null,
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
                            color: (d['color'] as Color).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(LucideIcons.creditCard, color: d['color'] as Color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(d['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText), maxLines: 2, softWrap: true),
                              Text('Lender: ${d['lender']} • Rate: ${d['interestRate']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500), overflow: TextOverflow.ellipsis),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (d['isTopTarget'] as bool) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: const Color(0xFFFEF2F2), borderRadius: BorderRadius.circular(12)),
                          child: const Row(
                            children: [
                              Icon(LucideIcons.flame, size: 12, color: Color(0xFFEF4444)),
                              SizedBox(width: 4),
                              Text('TOP TARGET', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 6),
                      ],
                      InkWell(
                        onTap: () {
                          final title = d['title'];
                          setState(() {
                            _debts.remove(d);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$title deleted from Debt Payoff'),
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
              const SizedBox(height: 14),

              // Months Remaining Banner Badge
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(LucideIcons.clock, size: 14, color: Color(0xFF2563EB)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        monthsLeft > 0 ? '⏳ $monthsLeft Months Remaining to Pay Off Completely' : '🎉 Loan Fully Paid Off!',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              const SizedBox(height: 18),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: paidRatio,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade100,
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF059669)),
                ),
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Remaining Dues: ₹${bal.toStringAsFixed(0)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFEF4444))),
                  Text('${(paidRatio * 100).toStringAsFixed(0)}% Paid Off', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF059669))),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Min EMI: ₹${d['minEmi']}/mo', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  ElevatedButton.icon(
                    onPressed: () => _openMakePaymentModal(d, isMobile),
                    icon: const Icon(LucideIcons.arrowUpRight, size: 14),
                    label: const Text('Make Extra Payment', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F5132),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  void _openAddDebtModal(bool isMobile) {
    final titleCtrl = TextEditingController();
    final balanceCtrl = TextEditingController();
    final rateCtrl = TextEditingController();
    final emiCtrl = TextEditingController();

    void submit() {
      if (titleCtrl.text.isNotEmpty && balanceCtrl.text.isNotEmpty) {
        setState(() {
          final bal = double.tryParse(balanceCtrl.text) ?? 50000;
          _debts.add({
            'title': titleCtrl.text,
            'lender': 'Bank',
            'balance': bal,
            'original': bal,
            'interestRate': rateCtrl.text.isEmpty ? '15% p.a.' : rateCtrl.text,
            'minEmi': double.tryParse(emiCtrl.text) ?? 2500,
            'isTopTarget': false,
            'color': const Color(0xFF2563EB),
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
                    Text('Add Debt Account', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    SizedBox(height: 2),
                    Text('Add a credit card, loan, or debt balance.', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
          _buildInputField('DEBT NAME *', 'e.g. SBI Credit Card', titleCtrl),
          const SizedBox(height: 12),
          _buildInputField('CURRENT BALANCE (₹) *', 'e.g. 60000', balanceCtrl),
          const SizedBox(height: 12),
          _buildInputField('INTEREST RATE *', 'e.g. 18% p.a.', rateCtrl),
          const SizedBox(height: 12),
          _buildInputField('MINIMUM MONTHLY EMI (₹) *', 'e.g. 3000', emiCtrl),
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
              child: const Text('Add Debt Account', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        builder: (context) => FractionallySizedBox(heightFactor: 0.7, child: Padding(padding: const EdgeInsets.all(20), child: content)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Container(width: 480, padding: const EdgeInsets.all(24), child: content)),
      );
    }
  }

  void _openMakePaymentModal(Map<String, dynamic> debt, bool isMobile) {
    final payCtrl = TextEditingController();

    void submit() {
      if (payCtrl.text.isNotEmpty) {
        final amount = double.tryParse(payCtrl.text) ?? 1000;
        setState(() {
          final current = (debt['balance'] as num).toDouble();
          final orig = (debt['original'] as num).toDouble();
          debt['balance'] = (current - amount).clamp(0.0, orig);
        });
      }
      Navigator.pop(context);
    }

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Payoff Payment: ${debt['title']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText)),
        const SizedBox(height: 16),
        _buildInputField('PAYMENT AMOUNT (₹) *', 'e.g. 5000', payCtrl),
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
            child: const Text('Record Payment', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        builder: (context) => FractionallySizedBox(heightFactor: 0.55, child: Padding(padding: const EdgeInsets.all(20), child: content)),
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
