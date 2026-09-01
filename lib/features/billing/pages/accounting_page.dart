import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class AccountingPage extends ConsumerStatefulWidget {
  const AccountingPage({super.key});

  @override
  ConsumerState<AccountingPage> createState() => _AccountingPageState();
}

class _AccountingPageState extends ConsumerState<AccountingPage> {
  final TextEditingController _fixedIncomeSearch = TextEditingController();
  final TextEditingController _fixedExpenseSearch = TextEditingController();
  final TextEditingController _addIncomeSearch = TextEditingController();
  final TextEditingController _addExpenseSearch = TextEditingController();

  double _monthlyBudget = 20000.0;
  final double _currentExpenses = 0.0;

  @override
  void dispose() {
    _fixedIncomeSearch.dispose();
    _fixedExpenseSearch.dispose();
    _addIncomeSearch.dispose();
    _addExpenseSearch.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final paddingVal = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Page Header & Actions
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // 2. Summary Stat Cards (4 Cards)
            _buildSummaryCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 20),

            // 3. Portfolio & Tax Cards (2 Cards)
            _buildPortfolioAndTaxCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 150.ms),
            const SizedBox(height: 20),

            // 4. Wallet & Budget Cards (2 Cards)
            _buildWalletAndBudgetCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 200.ms),
            const SizedBox(height: 28),

            // 5. Additional Source Section (Image 2)
            _buildAdditionalSourceSection(isMobile).animate().fadeIn(duration: 500.ms, delay: 250.ms),
            const SizedBox(height: 28),

            // 6. Bills & Reminders Card (Image 1 & 2)
            _buildBillsAndRemindersCard(isMobile).animate().fadeIn(duration: 500.ms, delay: 300.ms),
            const SizedBox(height: 28),

            // 7. Fixed Source Section (Image 1)
            _buildFixedSourceSection(isMobile).animate().fadeIn(duration: 500.ms, delay: 350.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Header Widget
  // ---------------------------------------------------------------------------
  Widget _buildHeader(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF0F5132),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F5132).withValues(alpha: 0.2),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Icon(LucideIcons.indianRupee, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Finance',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your Income, fixed costs, and daily spending in one place.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.secondaryText.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
        if (!isMobile) ...[
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Icon(LucideIcons.bell, size: 18, color: AppColors.darkText),
          ),
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(LucideIcons.shieldCheck, size: 16),
            label: const Text('Tax & Deductions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFEBEB),
              foregroundColor: const Color(0xFFDC2626),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Summary Cards (4 Cards Grid)
  // ---------------------------------------------------------------------------
  Widget _buildSummaryCards(bool isMobile) {
    const c1 = _SummaryStatCard(
      width: double.infinity,
      title: 'TOTAL INCOME',
      value: '₹0',
      bgColor: Color(0xFFECFDF5),
      textColor: Color(0xFF059669),
    );
    const c2 = _SummaryStatCard(
      width: double.infinity,
      title: 'TOTAL EXPENSES',
      value: '₹0',
      bgColor: Color(0xFFFFFBEB),
      textColor: Color(0xFFD97706),
    );
    const c3 = _SummaryStatCard(
      width: double.infinity,
      title: 'MONTHLY SAVINGS',
      value: '₹0',
      bgColor: Color(0xFFF5F3FF),
      textColor: Color(0xFF7C3AED),
    );
    const c4 = _SummaryStatCard(
      width: double.infinity,
      title: 'NET WORTH',
      value: '₹0',
      bgColor: Color(0xFFF1F5F9),
      textColor: Color(0xFF475569),
    );

    if (isMobile) {
      return const Column(
        children: [
          Row(
            children: [
              Expanded(child: c1),
              SizedBox(width: 12),
              Expanded(child: c2),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: c3),
              SizedBox(width: 12),
              Expanded(child: c4),
            ],
          ),
        ],
      );
    }

    return const Row(
      children: [
        Expanded(child: c1),
        SizedBox(width: 12),
        Expanded(child: c2),
        SizedBox(width: 12),
        Expanded(child: c3),
        SizedBox(width: 12),
        Expanded(child: c4),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Investment Portfolio & Estimated Tax Due Cards
  // ---------------------------------------------------------------------------
  Widget _buildPortfolioAndTaxCards(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Investment Portfolio Card
            Container(
              width: cardWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFDBEAFE)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'INVESTMENT PORTFOLIO',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1D4ED8),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Icon(LucideIcons.arrowUpRight, size: 18, color: Colors.blue.shade700),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '₹0',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '+% All-time',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                      ),
                      Text(
                        'Monthly P/L: +₹0',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.blue.shade800),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Estimated Tax Due Card
            Container(
              width: cardWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFFEE2E2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ESTIMATED TAX DUE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFDC2626),
                          letterSpacing: 0.5,
                        ),
                      ),
                      Icon(LucideIcons.shieldCheck, size: 18, color: Colors.red.shade700),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '₹0',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Due by July 31st',
                        style: TextStyle(fontSize: 12, color: Colors.red.shade700),
                      ),
                      Text(
                        'TDS Paid: ₹0',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Wallet & Budget Cards
  // ---------------------------------------------------------------------------
  Widget _buildWalletAndBudgetCards(bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // My Wallet Card
            Container(
              width: cardWidth,
              constraints: const BoxConstraints(minHeight: 170),
              padding: const EdgeInsets.all(20),
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
                  const Row(
                    children: [
                      Icon(LucideIcons.wallet, color: Color(0xFF6366F1), size: 20),
                      SizedBox(width: 8),
                      Text(
                        'My Wallet',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Text(
                      'No wallet cards linked yet',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                    ),
                  ),
                ],
              ),
            ),

            // Budget Planner Card
            Container(
              width: cardWidth,
              constraints: const BoxConstraints(minHeight: 170),
              padding: const EdgeInsets.all(20),
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
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEEF2FF),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(LucideIcons.target, color: Color(0xFF6366F1), size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Budget Planner',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'MONTHLY BUDGET LIMIT',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  '₹${_monthlyBudget.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                                ),
                                const SizedBox(width: 6),
                                InkWell(
                                  onTap: () {
                                    _showEditBudgetDialog();
                                  },
                                  child: Icon(LucideIcons.pencil, size: 14, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'EXPENSES',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${_currentExpenses.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                            ),
                          ],
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'REMAINING',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '₹${(_monthlyBudget - _currentExpenses).toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF059669)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Usage', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      Text('0%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.0,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6366F1)),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 5. Additional Source Section (Image 2)
  // ---------------------------------------------------------------------------
  Widget _buildAdditionalSourceSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.briefcase, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Additional Source',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  Text(
                    'Manage your additional income sources and additional expenses here.',
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildDataTableCard(
                  width: cardWidth,
                  badgeLabel: 'ADDITIONAL SOURCE',
                  tabTitle: 'ADDITIONAL INCOME',
                  searchController: _addIncomeSearch,
                  searchHint: 'Search income',
                  columns: const ['NAME ⇅', 'DESCRIPTION ⇅', 'DATE', 'TIME', 'AMOUNT'],
                  emptyText: 'No income sources added yet',
                ),
                _buildDataTableCard(
                  width: cardWidth,
                  badgeLabel: 'ADDITIONAL SOURCE',
                  tabTitle: 'ADDITIONAL EXPENSE',
                  searchController: _addExpenseSearch,
                  searchHint: 'Search additio',
                  columns: const ['NAME ⇅', 'DESCRIPTION ⇅', 'DATE', 'TIME', 'AMOUNT'],
                  emptyText: 'No additional expenses added yet.',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 6. Bills & Reminders Card (Image 1 & 2)
  // ---------------------------------------------------------------------------
  Widget _buildBillsAndRemindersCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
              const Row(
                children: [
                  Icon(LucideIcons.bell, color: Color(0xFF6366F1), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Bills & Reminders',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(LucideIcons.plus, size: 14),
                label: const Text('Add Bill', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F5132),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFB),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Text(
                'No recurring bills set up. Add your first bill reminder!',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 7. Fixed Source Section (Image 1)
  // ---------------------------------------------------------------------------
  Widget _buildFixedSourceSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.briefcase, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fixed Source',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  Text(
                    'Manage your income sources and daily expenses here.',
                    style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = isMobile ? constraints.maxWidth : (constraints.maxWidth - 16) / 2;

            return Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildDataTableCard(
                  width: cardWidth,
                  badgeLabel: 'FIXED SOURCE',
                  tabTitle: 'FIXED INCOME',
                  searchController: _fixedIncomeSearch,
                  searchHint: 'Search income',
                  columns: const ['Name ⇅', 'Description ⇅', 'Date ⇅', 'Time', 'Schedule'],
                  emptyText: 'No income sources added yet',
                ),
                _buildDataTableCard(
                  width: cardWidth,
                  badgeLabel: 'ADDITIONAL SOURCE',
                  tabTitle: 'ADDITIONAL EXPENSE',
                  searchController: _fixedExpenseSearch,
                  searchHint: 'Search expen',
                  columns: const ['NAME ⇅', 'DESCRIPTION ⇅', 'DATE ⇅', 'TIME', 'SCHEDULE'],
                  emptyText: 'No expenses added yet',
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Generic Data Table Card Builder
  // ---------------------------------------------------------------------------
  Widget _buildDataTableCard({
    required double width,
    required String badgeLabel,
    required String tabTitle,
    required TextEditingController searchController,
    required String searchHint,
    required List<String> columns,
    required String emptyText,
  }) {
    return Container(
      width: width,
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
        children: [
          // Header Badge
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: Text(
              badgeLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E3A8A),
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Control Bar Container (Blue Box)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F4FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    tabTitle,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E3A8A),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: 120,
                  height: 30,
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(fontSize: 11),
                    decoration: InputDecoration(
                      hintText: searchHint,
                      hintStyle: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                      prefixIcon: Icon(LucideIcons.search, size: 12, color: Colors.grey.shade400),
                      contentPadding: EdgeInsets.zero,
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF1E3A8A)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(LucideIcons.plus, size: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Table Columns Header Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: columns.map((col) {
                  return SizedBox(
                    width: 90,
                    child: Text(
                      col,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Table Content Empty State
          Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                emptyText,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditBudgetDialog() {
    final controller = TextEditingController(text: _monthlyBudget.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Monthly Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Budget Amount (₹)',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newBudget = double.tryParse(controller.text);
              if (newBudget != null && newBudget > 0) {
                setState(() {
                  _monthlyBudget = newBudget;
                });
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F5132)),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Helper Stat Card Widget
class _SummaryStatCard extends StatelessWidget {
  final double width;
  final String title;
  final String value;
  final Color bgColor;
  final Color textColor;

  const _SummaryStatCard({
    required this.width,
    required this.title,
    required this.value,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: textColor,
              letterSpacing: 0.5,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          const SizedBox(height: 6),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
