import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class GoalBucketsPage extends StatefulWidget {
  const GoalBucketsPage({super.key});

  @override
  State<GoalBucketsPage> createState() => _GoalBucketsPageState();
}

class _GoalBucketsPageState extends State<GoalBucketsPage> {
  String _selectedSubTab = 'all'; // 'all', 'savings', 'debts', 'summary'

  // Unified Goals & Debts Data
  final List<Map<String, dynamic>> _items = [
    // SAVINGS GOALS
    {
      'id': 'goal_1',
      'type': 'savings',
      'title': 'Emergency Reserve Fund',
      'category': 'Emergency Fund',
      'target': 500000.0,
      'current': 350000.0,
      'estDate': 'Dec 2026',
      'icon': LucideIcons.shieldCheck,
      'color': const Color(0xFF059669),
    },
    {
      'id': 'goal_2',
      'type': 'savings',
      'title': 'New Electric Car',
      'category': 'Vehicle Upgrade',
      'target': 400000.0,
      'current': 180000.0,
      'estDate': 'Jul 2027',
      'icon': LucideIcons.car,
      'color': const Color(0xFF2563EB),
    },
    {
      'id': 'goal_3',
      'type': 'savings',
      'title': 'Japan Cherry Blossom Trip',
      'category': 'Travel & Vacation',
      'target': 150000.0,
      'current': 75000.0,
      'estDate': 'Apr 2027',
      'icon': LucideIcons.plane,
      'color': const Color(0xFFD946EF),
    },
    {
      'id': 'goal_4',
      'type': 'savings',
      'title': 'MacBook Pro M3 Max',
      'category': 'Gadgets & Tech',
      'target': 250000.0,
      'current': 30000.0,
      'estDate': 'Nov 2026',
      'icon': LucideIcons.laptop,
      'color': const Color(0xFF7C3AED),
    },
    // DEBT PAYOFF TARGETS
    {
      'id': 'debt_1',
      'type': 'debt',
      'title': 'HDFC Credit Card Snowball',
      'category': 'Credit Card Debt',
      'lender': 'HDFC Bank',
      'target': 120000.0, // Total Debt Owed
      'current': 80000.0,  // Amount Paid Off So Far
      'estDate': 'Nov 2026',
      'icon': LucideIcons.creditCard,
      'color': const Color(0xFFEF4444),
      'minEmi': 12000.0,
    },
    {
      'id': 'debt_2',
      'type': 'debt',
      'title': 'SBI Home Loan Lump Sum',
      'category': 'Home Mortgage',
      'lender': 'State Bank of India',
      'target': 800000.0,
      'current': 320000.0,
      'estDate': 'Jan 2029',
      'icon': LucideIcons.home,
      'color': const Color(0xFFF59E0B),
      'minEmi': 25000.0,
    },
    {
      'id': 'debt_3',
      'type': 'debt',
      'title': 'Car Finance Pre-closure',
      'category': 'Vehicle Loan',
      'lender': 'Axis Finance',
      'target': 300000.0,
      'current': 210000.0,
      'estDate': 'May 2027',
      'icon': LucideIcons.trendingDown,
      'color': const Color(0xFFDC2626),
      'minEmi': 15000.0,
    },
  ];

  // Calculated Money Aggregates
  double get _totalSavingsTarget => _items.where((i) => i['type'] == 'savings').fold(0.0, (sum, i) => sum + (i['target'] as num).toDouble());
  double get _totalSavingsSaved => _items.where((i) => i['type'] == 'savings').fold(0.0, (sum, i) => sum + (i['current'] as num).toDouble());

  double get _totalDebtTotal => _items.where((i) => i['type'] == 'debt').fold(0.0, (sum, i) => sum + (i['target'] as num).toDouble());
  double get _totalDebtPaid => _items.where((i) => i['type'] == 'debt').fold(0.0, (sum, i) => sum + (i['current'] as num).toDouble());
  double get _totalDebtRemaining => _totalDebtTotal - _totalDebtPaid;

  double get _netGoalPosition => _totalSavingsSaved - _totalDebtRemaining;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final paddingVal = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(paddingVal, 16, paddingVal, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Header
                  _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
                  const SizedBox(height: 20),

                  // Top Money Calculation Banners & Summary Cards
                  _buildOverallMoneySummary(isMobile).animate().fadeIn(duration: 450.ms, delay: 50.ms),
                  const SizedBox(height: 20),

                  // Main Content depending on Sub-Tab
                  if (_selectedSubTab == 'summary')
                    _buildAnalyticsSummary(isMobile).animate().fadeIn(duration: 450.ms)
                  else
                    _buildBucketsGrid(isMobile).animate().fadeIn(duration: 500.ms),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // Sub-Tabs Anchored to Bottom (Like in Other Sections)
          _buildAnchoredSubTabsBar(isMobile).animate().fadeIn(duration: 350.ms),
        ],
      ),
    );
  }

  // HEADER WITH TITLE & CREATE BUTTONS
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5132),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.target, color: Colors.white, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Goal Buckets', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText), overflow: TextOverflow.ellipsis),
                        Text('Debt & Savings', style: TextStyle(fontSize: 11, color: AppColors.secondaryText), overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                InkWell(
                  onTap: () => _openCreateModal(isMobile, isDebt: false),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F5132),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.plus, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text('Savings', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                InkWell(
                  onTap: () => _openCreateModal(isMobile, isDebt: true),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(LucideIcons.trendingDown, color: Color(0xFFEF4444), size: 12),
                        SizedBox(width: 4),
                        Text('Debt', style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F5132),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(LucideIcons.target, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Goal Buckets & Debt Payoff Hub', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                  SizedBox(height: 4),
                  Text('Systematically build wealth with savings goals and eliminate liabilities with debt payoff targets.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () => _openCreateModal(isMobile, isDebt: false),
                icon: const Icon(LucideIcons.plus, size: 16),
                label: const Text('Add Savings Goal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton.icon(
                onPressed: () => _openCreateModal(isMobile, isDebt: true),
                icon: const Icon(LucideIcons.trendingDown, size: 16, color: Color(0xFFEF4444)),
                label: const Text('Add Debt Payoff', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFFFEF2F2),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // OVERALL MONEY CALCULATED CARDS (SAVINGS VS DEBTS VS NET POSITION)
  Widget _buildOverallMoneySummary(bool isMobile) {
    final savingsRatio = (_totalSavingsTarget > 0) ? (_totalSavingsSaved / _totalSavingsTarget).clamp(0.0, 1.0) : 0.0;
    final debtRatio = (_totalDebtTotal > 0) ? (_totalDebtPaid / _totalDebtTotal).clamp(0.0, 1.0) : 0.0;

    final cardsData = [
      {
        'title': 'TOTAL SAVINGS ACCUMULATED',
        'shortTitle': 'SAVINGS SAVED',
        'value': '₹${_fmt(_totalSavingsSaved)}',
        'sub': 'of ₹${_fmt(_totalSavingsTarget)} Target (${(savingsRatio * 100).toInt()}% Saved)',
        'shortSub': '${(savingsRatio * 100).toInt()}% of ₹${_fmt(_totalSavingsTarget)}',
        'progress': savingsRatio,
        'icon': LucideIcons.piggyBank,
        'color': const Color(0xFF059669),
        'bgColor': const Color(0xFFECFDF5),
      },
      {
        'title': 'OUTSTANDING DEBT OBLIGATION',
        'shortTitle': 'DEBT OBLIGATION',
        'value': '₹${_fmt(_totalDebtRemaining)}',
        'sub': '₹${_fmt(_totalDebtPaid)} Paid of ₹${_fmt(_totalDebtTotal)} Total (${(debtRatio * 100).toInt()}% Cleared)',
        'shortSub': '${(debtRatio * 100).toInt()}% of ₹${_fmt(_totalDebtTotal)} Paid',
        'progress': debtRatio,
        'icon': LucideIcons.trendingDown,
        'color': const Color(0xFFEF4444),
        'bgColor': const Color(0xFFFEF2F2),
      },
      {
        'title': 'NET FINANCIAL POSITION',
        'shortTitle': 'NET POSITION',
        'value': '${_netGoalPosition >= 0 ? '+' : '-'}₹${_fmt(_netGoalPosition.abs())}',
        'sub': _netGoalPosition >= 0 ? '✓ Net Surplus Position' : '⚠️ Liabilities exceed active savings',
        'shortSub': _netGoalPosition >= 0 ? 'Net Surplus' : 'Net Deficit',
        'progress': 1.0,
        'icon': _netGoalPosition >= 0 ? LucideIcons.shieldCheck : LucideIcons.alertTriangle,
        'color': _netGoalPosition >= 0 ? const Color(0xFF10B981) : const Color(0xFFF59E0B),
        'bgColor': _netGoalPosition >= 0 ? const Color(0xFFECFDF5) : const Color(0xFFFFFBEE),
      },
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildCompactSummaryCard(cardsData[0])),
              const SizedBox(width: 10),
              Expanded(child: _buildCompactSummaryCard(cardsData[1])),
            ],
          ),
          const SizedBox(height: 10),
          _buildNetPositionStrip(cardsData[2]),
        ],
      );
    }

    return Row(
      children: cardsData.map((c) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: _buildSummaryCard(c),
        ),
      )).toList(),
    );
  }

  Widget _buildCompactSummaryCard(Map<String, dynamic> c) {
    final color = c['color'] as Color;
    final progress = (c['progress'] as num).toDouble();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.015), blurRadius: 8, offset: const Offset(0, 3)),
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
                  c['shortTitle'] as String,
                  style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText, letterSpacing: 0.3),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: c['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(c['icon'] as IconData, color: color, size: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              c['value'] as String,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: color),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            c['shortSub'] as String,
            style: const TextStyle(fontSize: 10, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 4,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNetPositionStrip(Map<String, dynamic> c) {
    final color = c['color'] as Color;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: c['bgColor'] as Color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(c['icon'] as IconData, color: color, size: 15),
              const SizedBox(width: 8),
              const Text('NET GOAL POSITION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText, letterSpacing: 0.5)),
            ],
          ),
          Row(
            children: [
              Text(
                c['value'] as String,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: color),
              ),
              const SizedBox(width: 6),
              Text(
                _netGoalPosition >= 0 ? '(Surplus)' : '(Deficit)',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, dynamic> c) {
    final color = c['color'] as Color;
    final progress = (c['progress'] as num).toDouble();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.015), blurRadius: 10, offset: const Offset(0, 4)),
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
                  c['title'] as String,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText, letterSpacing: 0.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: c['bgColor'] as Color,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(c['icon'] as IconData, color: color, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              c['value'] as String,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: color),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            c['sub'] as String,
            style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFFF1F5F9),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }

  // SUB-TABS NAVIGATION BAR ANCHORED AT BOTTOM
  Widget _buildAnchoredSubTabsBar(bool isMobile) {
    final tabs = [
      {'id': 'all', 'label': 'All (${_items.length})', 'icon': LucideIcons.layoutGrid},
      {'id': 'savings', 'label': 'Savings (${_items.where((i) => i['type'] == 'savings').length})', 'icon': LucideIcons.piggyBank},
      {'id': 'debts', 'label': 'Debts (${_items.where((i) => i['type'] == 'debt').length})', 'icon': LucideIcons.trendingDown},
      {'id': 'summary', 'label': 'Projections', 'icon': LucideIcons.barChart2},
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(isMobile ? 12 : 24, 10, isMobile ? 12 : 24, isMobile ? 12 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: isMobile
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tabs.map((t) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildTabChip(t),
                )).toList(),
              ),
            )
          : Row(
              children: tabs.map((t) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _buildTabChip(t),
                ),
              )).toList(),
            ),
    );
  }

  Widget _buildTabChip(Map<String, dynamic> t) {
    final isSelected = _selectedSubTab == t['id'];
    return InkWell(
      onTap: () => setState(() => _selectedSubTab = t['id'] as String),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0F5132) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF0F5132) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(t['icon'] as IconData, size: 14, color: isSelected ? Colors.white : AppColors.secondaryText),
            const SizedBox(width: 6),
            Text(
              t['label'] as String,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.darkText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MAIN GRID DISPLAYING SAVINGS & DEBT CARDS
  Widget _buildBucketsGrid(bool isMobile) {
    final filtered = _items.where((i) {
      if (_selectedSubTab == 'savings') return i['type'] == 'savings';
      if (_selectedSubTab == 'debts') return i['type'] == 'debt';
      return true;
    }).toList();

    if (filtered.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            const Icon(LucideIcons.target, size: 40, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('No Goal Buckets Found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.darkText)),
            const SizedBox(height: 4),
            const Text('Click + Add Savings Goal or + Add Debt Payoff to get started.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 850 ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: filtered.map((item) {
            final isDebt = item['type'] == 'debt';
            final target = (item['target'] as num).toDouble();
            final current = (item['current'] as num).toDouble();
            final ratio = (target > 0) ? (current / target).clamp(0.0, 1.0) : 0.0;
            final color = item['color'] as Color;

            return Container(
              width: cardWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDebt ? const Color(0xFFFCA5A5).withValues(alpha: 0.5) : AppColors.border),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Type Badge + Title + Delete Icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isDebt ? const Color(0xFFFEF2F2) : const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              isDebt ? 'DEBT PAYOFF' : 'SAVINGS BUCKET',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: isDebt ? const Color(0xFFEF4444) : const Color(0xFF059669),
                              ),
                            ),
                          ),
                          if (isDebt && item['lender'] != null) ...[
                            const SizedBox(width: 6),
                            Text('• ${item['lender']}', style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                          ],
                        ],
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        padding: const EdgeInsets.all(4),
                        icon: const Icon(LucideIcons.trash2, size: 15, color: Colors.grey),
                        onPressed: () {
                          setState(() => _items.removeWhere((i) => i['id'] == item['id']));
                          AppSnackbar.show(context, "${item['title']} removed.", type: SnackType.info);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Icon + Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item['icon'] as IconData, color: color, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              isDebt
                                  ? 'Target Payoff: ${item['estDate']} (EMI: ₹${_fmt((item['minEmi'] as num).toDouble())}/mo)'
                                  : 'Target Completion: ${item['estDate']}',
                              style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${(ratio * 100).toInt()}%',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: color),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Progress Bar
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: ratio,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFF1F5F9),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Bottom Stat Line: Current vs Target
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isDebt ? 'Paid Off: ₹${_fmt(current)}' : 'Saved: ₹${_fmt(current)}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
                      ),
                      Text(
                        isDebt ? 'Remaining: ₹${_fmt(target - current)}' : 'Target: ₹${_fmt(target)}',
                        style: const TextStyle(fontSize: 12, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Interactive Action Button (Deposit vs Pay Owed)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _openTransactionModal(item, isMobile),
                      icon: Icon(isDebt ? LucideIcons.arrowUpRight : LucideIcons.plusCircle, size: 15),
                      label: Text(
                        isDebt ? 'Pay Owed Debt' : 'Deposit Savings',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDebt ? const Color(0xFFDC2626) : const Color(0xFF0F5132),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
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

  // ANALYTICS & DEBT FREE PROJECTION SUB-TAB
  Widget _buildAnalyticsSummary(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.sparkles, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Debt-Free & Savings Growth Projection',
                  style: TextStyle(fontSize: isMobile ? 15 : 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Based on current contribution rates, here is your path to complete debt freedom and milestone achievement.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 20),

          // Timeline Cards
          if (isMobile)
            Column(
              children: [
                _buildTimelineCard(
                  title: 'ESTIMATED DEBT FREE DATE',
                  value: 'Jan 2029',
                  sub: 'Accelerate with ₹5,000/mo extra EMI',
                  bgColor: const Color(0xFFECFDF5),
                  borderColor: const Color(0xFFA7F3D0),
                  titleColor: const Color(0xFF047857),
                  valColor: const Color(0xFF065F46),
                ),
                const SizedBox(height: 12),
                _buildTimelineCard(
                  title: 'ALL SAVINGS GOALS TARGET',
                  value: 'Jul 2027',
                  sub: 'On track for 4 major milestones',
                  bgColor: const Color(0xFFEFF6FF),
                  borderColor: const Color(0xFFBFDBFE),
                  titleColor: const Color(0xFF1D4ED8),
                  valColor: const Color(0xFF1E40AF),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: _buildTimelineCard(
                    title: 'ESTIMATED DEBT FREE DATE',
                    value: 'Jan 2029',
                    sub: 'Accelerate with ₹5,000/mo extra EMI',
                    bgColor: const Color(0xFFECFDF5),
                    borderColor: const Color(0xFFA7F3D0),
                    titleColor: const Color(0xFF047857),
                    valColor: const Color(0xFF065F46),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimelineCard(
                    title: 'ALL SAVINGS GOALS TARGET',
                    value: 'Jul 2027',
                    sub: 'On track for 4 major milestones',
                    bgColor: const Color(0xFFEFF6FF),
                    borderColor: const Color(0xFFBFDBFE),
                    titleColor: const Color(0xFF1D4ED8),
                    valColor: const Color(0xFF1E40AF),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimelineCard({
    required String title,
    required String value,
    required String sub,
    required Color bgColor,
    required Color borderColor,
    required Color titleColor,
    required Color valColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: titleColor)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: valColor)),
          const SizedBox(height: 4),
          Text(sub, style: TextStyle(fontSize: 11, color: titleColor)),
        ],
      ),
    );
  }

  // CREATE SAVINGS OR DEBT MODAL
  void _openCreateModal(bool isMobile, {required bool isDebt}) {
    final titleCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final lenderCtrl = TextEditingController();
    final dateCtrl = TextEditingController();

    void submit() {
      final title = titleCtrl.text.trim();
      final target = double.tryParse(targetCtrl.text.trim()) ?? 100000.0;
      if (title.isNotEmpty) {
        setState(() {
          _items.add({
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'type': isDebt ? 'debt' : 'savings',
            'title': title,
            'category': isDebt ? 'Loan / Payoff' : 'Savings Milestone',
            'lender': lenderCtrl.text.trim().isEmpty ? 'Financial Lender' : lenderCtrl.text.trim(),
            'target': target,
            'current': 0.0,
            'estDate': dateCtrl.text.trim().isEmpty ? 'Dec 2027' : dateCtrl.text.trim(),
            'icon': isDebt ? LucideIcons.creditCard : LucideIcons.target,
            'color': isDebt ? const Color(0xFFEF4444) : const Color(0xFF059669),
            'minEmi': isDebt ? (target * 0.05) : 0.0,
          });
        });
        AppSnackbar.show(
          context,
          isDebt ? "Debt payoff target '$title' created!" : "Savings goal '$title' created!",
          type: SnackType.success,
        );
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
              Expanded(
                child: Text(
                  isDebt ? 'Add Debt Payoff Target' : 'Create Savings Goal',
                  style: TextStyle(fontSize: isMobile ? 16 : 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildInputField(isDebt ? 'DEBT / LOAN TITLE *' : 'SAVINGS GOAL TITLE *', isDebt ? 'e.g. Credit Card, Car Loan' : 'e.g. Dream House, Vacation', titleCtrl),
          const SizedBox(height: 12),
          if (isDebt) ...[
            _buildInputField('LENDER / BANK NAME', 'e.g. HDFC Bank, SBI', lenderCtrl),
            const SizedBox(height: 12),
          ],
          _buildInputField(isDebt ? 'TOTAL DEBT AMOUNT (₹) *' : 'TARGET SAVINGS AMOUNT (₹) *', 'e.g. 100000', targetCtrl, keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          _buildInputField('TARGET COMPLETION DATE', 'e.g. Dec 2027', dateCtrl),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDebt ? const Color(0xFFDC2626) : const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isDebt ? 'Add Debt Payoff' : 'Create Savings Bucket', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
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
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: content,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: Container(width: 440, padding: const EdgeInsets.all(24), child: content),
        ),
      );
    }
  }

  // DEPOSIT SAVINGS OR PAY DEBT MODAL
  void _openTransactionModal(Map<String, dynamic> item, bool isMobile) {
    final isDebt = item['type'] == 'debt';
    final amountCtrl = TextEditingController();

    void submit() {
      final amt = double.tryParse(amountCtrl.text.trim()) ?? 5000.0;
      final current = (item['current'] as num).toDouble();
      final target = (item['target'] as num).toDouble();

      setState(() {
        item['current'] = (current + amt).clamp(0.0, target);
      });

      Navigator.pop(context);
      AppSnackbar.show(
        context,
        isDebt
            ? "Payment of ₹${_fmt(amt)} recorded against ${item['title']}!"
            : "Deposit of ₹${_fmt(amt)} added to ${item['title']}!",
        type: SnackType.success,
      );
    }

    final content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(isDebt ? LucideIcons.trendingDown : LucideIcons.plusCircle, color: isDebt ? const Color(0xFFEF4444) : AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isDebt ? 'Pay Owed Debt: ${item['title']}' : 'Deposit Savings: ${item['title']}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isDebt
                ? 'Record a payment towards clearing this debt obligation.'
                : 'Add money into this dedicated savings goal bucket.',
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 16),
          _buildInputField(isDebt ? 'PAYMENT AMOUNT (₹) *' : 'DEPOSIT AMOUNT (₹) *', 'e.g. 5000', amountCtrl, keyboardType: TextInputType.number),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDebt ? const Color(0xFFDC2626) : const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(isDebt ? 'Confirm Debt Payment' : 'Confirm Deposit', style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
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
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: content,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(width: 440, padding: const EdgeInsets.all(24), child: content),
        ),
      );
    }
  }

  Widget _buildInputField(String label, String placeholder, TextEditingController ctrl, {TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: AppColors.secondaryText, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: AppColors.darkText, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFFFAFAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.primaryGreen, width: 1.5)),
          ),
        ),
      ],
    );
  }

  String _fmt(double val) {
    return val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
  }
}
