import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/onboard_staff_employee_dialog.dart';
import '../widgets/file_performance_review_dialog.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class StaffPage extends ConsumerStatefulWidget {
  const StaffPage({super.key});

  @override
  ConsumerState<StaffPage> createState() => _StaffPageState();
}

class _StaffPageState extends ConsumerState<StaffPage> {
  int _activeTab = 0; // 0: Employee Profiles, 1: Hierarchy, 2: Payroll & Bank, 3: Leaves & Shifts, 4: Appraisals

  final List<String> _tabs = [
    'Employee Profiles',
    'Hierarchy & Employment',
    'Payroll & Bank Details',
    'Leaves & Shifts Rosters',
    'Performance Appraisals',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.user,
    LucideIcons.network,
    LucideIcons.creditCard,
    LucideIcons.calendarDays,
    LucideIcons.award,
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(paddingVal),
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
            _buildMainContent(isMobile, screenWidth).animate().fadeIn(duration: 500.ms, delay: 200.ms),
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
                color: const Color(0xFFE289F2).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.users, color: Color(0xFFD63384), size: 24),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'HR Staff & Employees Database',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Manage whole workforce life cycle: Central Profiles database, Employment designations, Payroll PF/ESI bank accounts, Leaves, Shifts, and Performance ratings.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const FilePerformanceReviewDialog(),
            );
          },
          icon: const Icon(LucideIcons.fileEdit, size: 16),
          label: const Text('File Appraisal Review'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD63384),
            side: const BorderSide(color: Color(0xFFF8D7DA)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const OnboardStaffEmployeeDialog(),
            );
          },
          icon: const Icon(LucideIcons.userPlus, size: 16),
          label: const Text('Onboard Staff Employee', style: TextStyle(fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD63384),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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

  Widget _buildStatCards(bool isMobile) {
    final cards = [
      _buildStatCard(
        title: '0 Employees',
        subtitle: 'TOTAL ACTIVE HEADCOUNT',
        icon: LucideIcons.userCheck,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: '₹0',
        subtitle: 'MONTHLY BASIC PAYROLL',
        icon: LucideIcons.creditCard,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: '0.0 / 5.0 Rating',
        subtitle: 'WORKFORCE PERFORMANCE',
        icon: LucideIcons.star,
        iconColor: const Color(0xFF8A2BE2),
        bgColor: const Color(0xFFF3E5F5),
      ),
      _buildStatCard(
        title: 'General (9AM - 6PM)',
        subtitle: 'ASSIGNED SHIFTS',
        icon: LucideIcons.clock,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
      ),
    ];

    if (isMobile) {
      return Column(
        children: cards.map((c) => Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: SizedBox(width: double.infinity, child: c),
        )).toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards.map((c) => SizedBox(width: (constraints.maxWidth - 48) / 4, child: c)).toList(),
        );
      },
    );
  }

  Widget _buildStatCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabsBar(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          final color = index == 0
              ? const Color(0xFFD63384)
              : (index == 1
                  ? const Color(0xFF2563EB)
                  : (index == 2 ? const Color(0xFF7C3AED) : (index == 3 ? const Color(0xFF10B981) : const Color(0xFFF59E0B))));

          return Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () => setState(() => _activeTab = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isSelected ? color : AppColors.border),
                  boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabIcons[index],
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.secondaryText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMainContent(bool isMobile, double screenWidth) {
    String sectionTitle = "";
    List<String> headers = [];
    String emptyMessage = "No active records found in system database.";
    IconData emptyIcon = LucideIcons.users;
    Widget? searchRow;

    switch (_activeTab) {
      case 0: // Employee Profiles
        sectionTitle = "Employee Workforce Profiles";
        headers = ['EMPLOYEE PROFILE', 'ID / CODE', 'CONTACT INFO', 'EMERGENCY PERSON', 'PERSONAL INFO', 'RESIDENTIAL ADDRESS', 'ACTION'];
        searchRow = _buildSearchRow(isMobile);
        emptyIcon = LucideIcons.userPlus;
        break;
      case 1: // Hierarchy & Employment
        sectionTitle = "Organizational Structure & Hierarchy";
        headers = ['Employee Name', 'Department', 'Designation Roles', 'Reporting Manager', 'Employment Type'];
        emptyIcon = LucideIcons.network;
        break;
      case 2: // Payroll & Bank
        sectionTitle = "Workforce Payroll Structure & Bank Details";
        headers = ['Employee', 'Salary Type', 'Basic Monthly Salary', 'Bank Name & Account', 'IFSC Code', 'PF Number', 'PAN Number'];
        emptyIcon = LucideIcons.creditCard;
        break;
      case 3: // Leaves & Shifts
        sectionTitle = "Leaves Balance & assigned Roster Shifts";
        headers = ['Employee Name', 'Assigned Work Shift', 'Annual Leave Balance', 'Weekly Holiday'];
        emptyIcon = LucideIcons.calendarRange;
        break;
      case 4: // Appraisals
        sectionTitle = "Personnel Appraisal & Rating scorecard";
        headers = ['Employee', 'Performance Rating', 'KPI Targets Score', 'Appraisal Target Date'];
        emptyIcon = LucideIcons.award;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sectionTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F2942)),
          ),
          if (searchRow != null) ...[
            const SizedBox(height: 20),
            searchRow,
          ],
          const SizedBox(height: 24),
          _buildTableOrList(isMobile, headers, emptyMessage, emptyIcon),
        ],
      ),
    );
  }

  Widget _buildSearchRow(bool isMobile) {
    return SizedBox(
      width: isMobile ? double.infinity : 320,
      height: 44,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: const Row(
          children: [
            Icon(LucideIcons.search, size: 18, color: AppColors.secondaryText),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search employees by name...',
                  hintStyle: TextStyle(fontSize: 13, color: AppColors.secondaryText),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableOrList(bool isMobile, List<String> headers, String emptyMessage, IconData emptyIcon) {
    final Map<int, TableColumnWidth> colWidths = {};
    double colWidth = 150.0;
    if (_activeTab == 0) {
      colWidth = 160.0;
    }
    double totalWidth = headers.length * colWidth;
    
    for (int i = 0; i < headers.length; i++) {
      colWidths[i] = FixedColumnWidth(colWidth);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            width: totalWidth,
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: colWidths,
              children: [
                TableRow(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
                  ),
                  children: headers.map((h) {
                    final showChevron = _activeTab == 0 && h != 'ACTION';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              h.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 9.5, 
                                fontWeight: FontWeight.bold, 
                                color: Colors.blueGrey,
                              ),
                            ),
                          ),
                          if (showChevron) ...[
                            const SizedBox(width: 4),
                            const Icon(LucideIcons.chevronDown, size: 8, color: Colors.blueGrey),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  shape: BoxShape.circle,
                ),
                child: Icon(emptyIcon, size: 28, color: AppColors.secondaryText),
              ),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                style: const TextStyle(fontSize: 13, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
