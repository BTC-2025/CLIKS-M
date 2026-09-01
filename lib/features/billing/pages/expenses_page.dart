import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../widgets/set_budget_dialog.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  int _activeTab = 0; // 0: Expenses Registry & ITC, 1: Recurring Subscriptions, 2: Department Budgets & Limits, 3: Staff Reimbursements

  final List<Map<String, dynamic>> _tabsInfo = [
    {'label': 'Expenses Registry & ITC', 'icon': LucideIcons.tag},
    {'label': 'Recurring Subscriptions', 'icon': LucideIcons.calendarClock},
    {'label': 'Department Budgets & Limits', 'icon': LucideIcons.barChart3},
    {'label': 'Staff Reimbursements', 'icon': LucideIcons.users},
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
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
            const SizedBox(height: 28),

            // Tabs bar
            _buildTabsBar(isMobile).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 24),

            // Main Data content
            _buildMainContent(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD63384).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.trendingDown, color: Color(0xFFD63384), size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Expenses & Operational Costs',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  Text(
                    'Add operational spendings, manage departmental budgets, track GST Input Tax Credit (ITC), automate recurring bills, and process staff reimbursement claims.',
                    style: TextStyle(fontSize: 11, color: AppColors.secondaryText, height: 1.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );

    final actionsWidget = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildActionButton(
            label: 'Lodge Staff Claim',
            icon: LucideIcons.user,
            color: const Color(0xFFD63384),
            isOutlined: true,
            onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.lodgeStaffClaim),
          ),
          const SizedBox(width: 8),
          _buildActionButton(
            label: 'Record Expense',
            icon: LucideIcons.plus,
            color: const Color(0xFFD63384),
            isOutlined: false,
            onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.recordExpense),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleWidget,
          const SizedBox(height: 16),
          actionsWidget,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleWidget),
        const SizedBox(width: 16),
        actionsWidget,
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isOutlined,
    required VoidCallback onPressed,
  }) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 14, color: color),
        label: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: Colors.white,
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 14, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );
  }

  Widget _buildStatCards(bool isMobile) {
    final cards = [
      _buildStatCard(
        title: 'TOTAL OPERATIONAL COSTS (MTD)',
        value: '₹ 0',
        icon: LucideIcons.trendingUp,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFD63384).withValues(alpha: 0.05),
      ),
      _buildStatCard(
        title: 'GST INPUT TAX CREDITS (ITC)',
        value: '₹ 0',
        icon: LucideIcons.percent,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFF0D6EFD).withValues(alpha: 0.05),
      ),
      _buildStatCard(
        title: 'ACTIVE MONTHLY RECURRINGS',
        value: '0 Automation',
        icon: LucideIcons.calendar,
        iconColor: const Color(0xFF6F42C1),
        bgColor: const Color(0xFF6F42C1).withValues(alpha: 0.05),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cards[0]),
              const SizedBox(width: 12),
              Expanded(child: cards[1]),
            ],
          ),
          if (cards.length > 2) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: cards[2]),
                const SizedBox(width: 12),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ],
      );
    }

    return Row(
      children: cards.map((c) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: c,
        ),
      )).toList(),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 6),
                FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildTabsBar(bool isMobile) {
    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSingleTab(0)),
              const SizedBox(width: 8),
              Expanded(child: _buildSingleTab(1)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildSingleTab(2)),
              const SizedBox(width: 8),
              Expanded(child: _buildSingleTab(3)),
            ],
          ),
        ],
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabsInfo.length, (index) => Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: _buildSingleTab(index),
        )),
      ),
    );
  }

  Widget _buildSingleTab(int index) {
    final isSelected = _activeTab == index;
    final tab = _tabsInfo[index];

    return InkWell(
      onTap: () => setState(() => _activeTab = index),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD63384).withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFFD63384) : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(tab['icon'], size: 14, color: isSelected ? const Color(0xFFD63384) : AppColors.secondaryText),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                tab['label'],
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? const Color(0xFFD63384) : AppColors.secondaryText,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile) {
    String title = '';
    Widget? extraButton;

    switch (_activeTab) {
      case 0:
        title = 'Expenses Registry & ITC';
        break;
      case 1:
        title = 'Active Recurring bills & Subscriptions';
        break;
      case 2:
        title = 'Departmental Budgets & Spending Limits';
        extraButton = _buildSmallButton(
          label: 'Set Budget Limit',
          icon: LucideIcons.plus,
          color: const Color(0xFFD63384),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const SetBudgetDialog(),
            );
          },
        );
        break;
      case 3:
        title = 'Employee Reimbursements & Travel claims';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (extraButton != null) ...[
              const SizedBox(width: 8),
              extraButton,
            ],
          ],
        ),
          const SizedBox(height: 20),
          _buildFilterRow(isMobile),
          const SizedBox(height: 20),
          _buildTableOrList(isMobile),
        ],
      ),
    );
  }

  Widget _buildSmallButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 12, color: Colors.white),
      label: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        elevation: 0,
      ),
    );
  }

  Widget _buildFilterRow(bool isMobile) {
    final searchField = Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: const Row(
        children: [
          SizedBox(width: 10),
          Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search any column (date, payee, amount)...',
                hintStyle: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );

    final dropdowns = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDropdown('All Categories'),
          const SizedBox(width: 8),
          _buildDropdown('All Modes'),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          searchField,
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: dropdowns),
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: searchField),
        const SizedBox(width: 16),
        dropdowns,
      ],
    );
  }

  Widget _buildDropdown(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          const SizedBox(width: 6),
          const Icon(LucideIcons.chevronDown, size: 14, color: AppColors.secondaryText),
        ],
      ),
    );
  }

  Widget _buildTableOrList(bool isMobile) {
    List<String> headers = [];
    String emptyMessage = '';
    IconData emptyIcon = LucideIcons.receipt;

    switch (_activeTab) {
      case 0:
        headers = ['VOUCHER NO', 'DATE', 'CATEGORY DESCRIPTION', 'PAYEE / MERCHANT', 'GST SUBTOTAL', 'ITC TAX CLAIM', 'TOTAL PAID', 'MODE'];
        emptyMessage = 'No recorded operational expenses found.';
        break;
      case 1:
        headers = ['AUTOMATION ID', 'CATEGORY NAME', 'FREQUENCY', 'NEXT DUE DATE', 'AUTO-POST', 'RECURRING COST'];
        emptyMessage = 'No active recurring bills or subscriptions found.';
        emptyIcon = LucideIcons.calendarClock;
        break;
      case 2:
        headers = ['CATEGORY GROUP', 'MONTHLY ALLOCATED LIMIT', 'ACTUAL SPENT (MTD)', 'UTILIZATION INDEX', 'BUDGET STATUS'];
        emptyMessage = 'No departmental budgets or limits set yet.';
        emptyIcon = LucideIcons.barChart3;
        break;
      case 3:
        headers = ['CLAIM ID', 'EMPLOYEE PROFILE', 'CLAIM PURPOSE DESCRIPTION', 'LODGE DATE', 'CLAIM AMOUNT'];
        emptyMessage = 'No employee reimbursement claims found.';
        emptyIcon = LucideIcons.users;
        break;
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: BoxConstraints(minWidth: isMobile ? 800 : 1000),
        child: Table(
          columnWidths: {
            for (var i = 0; i < headers.length; i++) i: const IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1.2)),
              ),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Text(
                  h,
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                ),
              )).toList(),
            ),
            TableRow(
              children: [
                for (var i = 0; i < headers.length; i++)
                  if (i == (headers.length / 2).floor())
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 60),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(emptyIcon, size: 32, color: AppColors.secondaryText.withValues(alpha: 0.3)),
                          const SizedBox(height: 12),
                          Text(emptyMessage, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                        ],
                      ),
                    )
                  else
                    const SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
