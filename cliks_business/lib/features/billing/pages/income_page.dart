import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/income_provider.dart';
import '../../../widgets/modals/add_transaction_modal.dart';

class IncomePage extends ConsumerStatefulWidget {
  const IncomePage({super.key});

  @override
  ConsumerState<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends ConsumerState<IncomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  String _selectedPeriod = 'This Month';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openAddIncomeModal() {
    showDialog(
      context: context,
      builder: (_) => const AddTransactionModal(
        initialType: TransactionType.income,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final incomeList = ref.watch(incomeEntriesProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 850;
    final paddingVal = isMobile ? 16.0 : 28.0;

    // Filter list
    final query = _searchController.text.trim().toLowerCase();
    final filteredList = incomeList.where((item) {
      final matchesQuery = query.isEmpty ||
          item.sourceName.toLowerCase().contains(query) ||
          item.category.toLowerCase().contains(query);
      final matchesFilter =
          _selectedFilter == 'All' || item.category == _selectedFilter;
      return matchesQuery && matchesFilter;
    }).toList();

    final totalIncome =
        incomeList.fold<double>(0.0, (sum, item) => sum + item.amount);
    final recurringRevenue = incomeList
        .where((item) => item.isRecurring)
        .fold<double>(0.0, (sum, item) => sum + item.amount);
    final activeSourcesCount = incomeList.length;
    final uniqueCategoriesCount =
        incomeList.map((item) => item.category).toSet().length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 24, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Top Subtitle & + Record Income Button
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // 2. Three Stat Cards
            _buildStatCards(
              screenWidth,
              totalIncome,
              recurringRevenue,
              activeSourcesCount,
              uniqueCategoriesCount,
            ).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 24),

            // 3. Search & Filter Bar
            _buildSearchBar(isMobile)
                .animate()
                .fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 20),

            // 4. Income Records Table / List Container
            _buildIncomeTable(context, filteredList, isMobile)
                .animate()
                .fadeIn(duration: 500.ms, delay: 200.ms),
            SizedBox(height: isMobile ? 110 : 36),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Top Header Row
  // ---------------------------------------------------------------------------
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Track and manage your revenue streams',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF16A34A),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _openAddIncomeModal,
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text(
                'Record Income',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Track and manage your revenue streams',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF16A34A),
          ),
        ),
        ElevatedButton.icon(
          onPressed: _openAddIncomeModal,
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text(
            'Record Income',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5132),
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Three Stat Cards
  // ---------------------------------------------------------------------------
  Widget _buildStatCards(
    double screenWidth,
    double totalIncome,
    double recurringRevenue,
    int activeSources,
    int uniqueCategories,
  ) {
    final c1 = _IncomeStatCard(
      title: 'Total Income',
      value: '₹${_formatCurrency(totalIncome)}',
      subtext: '+12% from last month',
      subtextColor: const Color(0xFF16A34A),
      iconWidget: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFECFDF5),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Text(
          '₹',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF059669),
          ),
        ),
      ),
    );

    final c2 = _IncomeStatCard(
      title: 'Recurring Revenue',
      value: '₹${_formatCurrency(recurringRevenue)}',
      subtext: 'Monthly stable income',
      subtextColor: const Color(0xFF16A34A),
      iconWidget: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFEFF6FF),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Icon(
          LucideIcons.calendar,
          size: 20,
          color: Color(0xFF3B82F6),
        ),
      ),
    );

    final c3 = _IncomeStatCard(
      title: 'Active Sources',
      value: '$activeSources',
      subtext: 'Across $uniqueCategories categories',
      subtextColor: const Color(0xFF16A34A),
      iconWidget: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: const Icon(
          LucideIcons.pieChart,
          size: 20,
          color: Color(0xFFA855F7),
        ),
      ),
    );

    if (screenWidth >= 850) {
      return Row(
        children: [
          Expanded(child: c1),
          const SizedBox(width: 16),
          Expanded(child: c2),
          const SizedBox(width: 16),
          Expanded(child: c3),
        ],
      );
    }

    return Column(
      children: [
        c1,
        const SizedBox(height: 12),
        c2,
        const SizedBox(height: 12),
        c3,
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Search & Filter Controls
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar(bool isMobile) {
    final searchField = SizedBox(
      height: 42,
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13.5),
        decoration: InputDecoration(
          hintText: 'Search income sources...',
          hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
          prefixIcon: Icon(
            LucideIcons.search,
            size: 16,
            color: Colors.grey.shade400,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF059669)),
          ),
        ),
      ),
    );

    final filterButton = PopupMenuButton<String>(
      onSelected: (val) => setState(() => _selectedFilter = val),
      itemBuilder: (context) => [
        'All',
        'Sales & Revenue',
        'Client Retainer',
        'Investment Return',
        'Consulting',
        'Salary',
        'Other Income',
      ].map((cat) {
        return PopupMenuItem<String>(
          value: cat,
          child: Text(cat, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.filter,
                  size: 16, color: Color(0xFF475569)),
              const SizedBox(width: 6),
              Text(
                _selectedFilter == 'All' ? 'Filter' : _selectedFilter,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(LucideIcons.chevronDown,
                  size: 14, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );

    final periodButton = PopupMenuButton<String>(
      onSelected: (val) => setState(() => _selectedPeriod = val),
      itemBuilder: (context) => [
        'This Month',
        'Last Month',
        'This Quarter',
        'This Year',
      ].map((period) {
        return PopupMenuItem<String>(
          value: period,
          child: Text(period, style: const TextStyle(fontSize: 13)),
        );
      }).toList(),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(LucideIcons.calendar,
                  size: 16, color: Color(0xFF475569)),
              const SizedBox(width: 6),
              Text(
                _selectedPeriod,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(LucideIcons.chevronDown,
                  size: 14, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: filterButton),
              const SizedBox(width: 10),
              Expanded(child: periodButton),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: searchField),
        const SizedBox(width: 12),
        filterButton,
        const SizedBox(width: 12),
        periodButton,
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Income Records Table Container
  // ---------------------------------------------------------------------------
  Widget _buildIncomeTable(
    BuildContext context,
    List<IncomeRecord> list,
    bool isMobile,
  ) {
    final tableCard = Container(
      constraints: BoxConstraints(minWidth: isMobile ? 540 : 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    'SOURCE NAME',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'CATEGORY',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'DATE',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'AMOUNT',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                SizedBox(
                  width: 50,
                  child: Text(
                    'ACTION',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

          // Table Content or Empty State
          if (list.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 60),
              child: Center(
                child: Text(
                  'No income records found.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: list.length,
              separatorBuilder: (_, _) => const Divider(
                height: 1,
                thickness: 1,
                color: Color(0xFFF1F5F9),
              ),
              itemBuilder: (context, index) {
                final item = list[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      // Source Name
                      Expanded(
                        flex: 3,
                        child: Text(
                          item.sourceName,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.darkText,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Category
                      Expanded(
                        flex: 2,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              item.category,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF059669),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ),
                      // Date
                      Expanded(
                        flex: 2,
                        child: Text(
                          '${item.date.day.toString().padLeft(2, '0')}/${item.date.month.toString().padLeft(2, '0')}/${item.date.year}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ),
                      // Amount
                      Expanded(
                        flex: 2,
                        child: Text(
                          '₹${_formatCurrency(item.amount)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF059669),
                          ),
                        ),
                      ),
                      // Action
                      SizedBox(
                        width: 50,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              ref
                                  .read(incomeEntriesProvider.notifier)
                                  .removeRecord(item.id);
                            },
                            borderRadius: BorderRadius.circular(6),
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                LucideIcons.trash2,
                                size: 16,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: 580,
          child: tableCard,
        ),
      );
    }
    return tableCard;
  }

  String _formatCurrency(double val) {
    if (val == 0) return '0';
    if (val == val.roundToDouble()) {
      return val.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]},',
          );
    }
    return val.toStringAsFixed(2);
  }
}

// -----------------------------------------------------------------------------
// Income Stat Card Widget
// -----------------------------------------------------------------------------
class _IncomeStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtext;
  final Color subtextColor;
  final Widget iconWidget;

  const _IncomeStatCard({
    required this.title,
    required this.value,
    required this.subtext,
    required this.subtextColor,
    required this.iconWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB).withValues(alpha: 0.6),
        ),
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
          // Top Row: Title + Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              iconWidget,
            ],
          ),
          const SizedBox(height: 12),
          // Value
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Subtext
          Text(
            subtext,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: subtextColor,
            ),
          ),
        ],
      ),
    );
  }
}
