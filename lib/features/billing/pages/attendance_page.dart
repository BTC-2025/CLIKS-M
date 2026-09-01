import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/roster_shift_dialog.dart';

class AttendancePage extends ConsumerStatefulWidget {
  const AttendancePage({super.key});

  @override
  ConsumerState<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends ConsumerState<AttendancePage> {
  int _activeTab = 0; // 0: Today's Logs, 1: History, 2: Date-wise, 3: Shifts, 4: GPS, 5: Corrections, 6: Calendar

  final List<String> _tabs = [
    'Today\'s Logs',
    'History Ledger',
    'Date-wise Lookup',
    'Shift Configurations',
    'GPS Location Fencing',
    'Correction Verifications',
    'Calendar View',
  ];

  final List<IconData> _tabIcons = [
    LucideIcons.clock,
    LucideIcons.users,
    LucideIcons.calendarSearch,
    LucideIcons.layoutPanelTop,
    LucideIcons.mapPin,
    LucideIcons.refreshCw,
    LucideIcons.calendarRange,
  ];

  Color _getTabColor(int index) {
    switch (index) {
      case 0: return const Color(0xFFD63384); // Pink
      case 1: return const Color(0xFF10B981); // Teal
      case 2: return const Color(0xFF2563EB); // Blue
      case 3: return const Color(0xFF7C3AED); // Purple
      case 4: return const Color(0xFFF59E0B); // Orange
      case 5: return const Color(0xFFDB2777); // Magenta
      case 6: return const Color(0xFFEA580C); // Yellow/Orange
      default: return AppColors.primaryGreen;
    }
  }

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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE289F2).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.calendarCheck, color: Color(0xFFD63384), size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Time & Attendance tracking',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage work hours timesheets, shifts rosters, late punch penalty deductions, biometric syncs, and regularization approvals.',
          style: TextStyle(fontSize: 12, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.regularizeMissedPunch);
          },
          icon: const Icon(LucideIcons.refreshCw, size: 14),
          label: const Text('Regularize Missed Punch', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD63384),
            side: const BorderSide(color: Color(0xFFF8D7DA)),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.manualPunchEntry);
          },
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('Manual Punch Entry', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD63384),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          const SizedBox(height: 12),
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
        title: '0% Present',
        subtitle: 'ATTENDANCE PERCENTAGE',
        icon: LucideIcons.shieldAlert,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: '0 Late marks',
        subtitle: 'LATE PUNCH CHECK-INS',
        icon: LucideIcons.alertTriangle,
        iconColor: const Color(0xFFDC3545),
        bgColor: const Color(0xFFFFF5F5),
      ),
      _buildStatCard(
        title: '0 Active',
        subtitle: 'ACTIVE ROSTER SHIFTS',
        icon: LucideIcons.calendar,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: '0 Claims',
        subtitle: 'PENDING REGULARIZATION',
        icon: LucideIcons.refreshCcw,
        iconColor: const Color(0xFF8A2BE2),
        bgColor: const Color(0xFFF3E5F5),
      ),
    ];

    if (isMobile) {
      return Wrap(
        spacing: 12,
        runSpacing: 12,
        children: cards.map((c) => SizedBox(
          width: (MediaQuery.of(context).size.width - 48) / 2, 
          child: c
        )).toList(),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: cards.map((c) => Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 12.0),
              child: c,
            ),
          )).toList(),
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
    final isNarrow = MediaQuery.of(context).size.width < 500;
    return Container(
      padding: EdgeInsets.all(isNarrow ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 8, offset: const Offset(0, 2)),
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
                      style: TextStyle(fontSize: isNarrow ? 13 : 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                child: Icon(icon, color: iconColor, size: 14),
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
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          final color = _getTabColor(index);
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _activeTab = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? color : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isSelected ? color : AppColors.border),
                  boxShadow: isSelected ? [BoxShadow(color: color.withValues(alpha: 0.15), blurRadius: 8, offset: const Offset(0, 2))] : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _tabIcons[index],
                      size: 14,
                      color: isSelected ? Colors.white : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _tabs[index],
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.secondaryText,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
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
    switch (_activeTab) {
      case 0: return _buildTodayLogsView(isMobile);
      case 1: return _buildHistoryLedgerView(isMobile);
      case 2: return _buildDatewiseLookupView(isMobile);
      case 3: return _buildShiftConfigView(isMobile);
      case 4: return _buildGpsFencingView(isMobile);
      case 5: return _buildCorrectionVerificationsView(isMobile);
      case 6: return _buildCalendarView(isMobile, screenWidth);
      default: return const SizedBox.shrink();
    }
  }

  Widget _buildTodayLogsView(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildResponsiveSearchAndDate(isMobile, 'Search today\'s logs by employee...', 'Today: 2026-07-17'),
          const SizedBox(height: 24),
          _buildTable(
            isMobile: isMobile,
            headers: ['LOG ID', 'EMPLOYEE PROFILE', 'CHECK-IN / OUT', 'PRODUCTIVE HOURS', 'LOCATION', 'STATUS', 'ACTION'],
            emptyMessage: 'No attendance logs recorded for today yet.',
          ),
        ],
      ),
    );
  }

  Widget _buildResponsiveSearchAndDate(bool isMobile, String hint, String date) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchField(hint),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildDateChip(date)),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: _buildSearchField(hint)),
        const SizedBox(width: 12),
        _buildDateChip(date),
      ],
    );
  }

  Widget _buildHistoryLedgerView(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildSearchField('Search staff ledger...'),
          const SizedBox(height: 24),
          _buildTable(
            isMobile: isMobile,
            headers: ['EMPLOYEE ID', 'STAFF MEMBER', 'PRESENT DAYS', 'ABSENT DAYS', 'LATE MARKS', 'ACTION LEDGER'],
            emptyMessage: 'No historical attendance data found.',
          ),
        ],
      ),
    );
  }

  Widget _buildDatewiseLookupView(bool isMobile) {
    final searchAndSelector = isMobile 
      ? Column(
          children: [
            Row(
              children: [
                const Text('Date:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                _buildDateSelector('17-07-2026'),
              ],
            ),
            const SizedBox(height: 12),
            _buildSearchField('Search by employee...'),
          ],
        )
      : Row(
          children: [
            const Text('Select Lookup Date:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            _buildDateSelector('17-07-2026'),
            const Spacer(),
            SizedBox(width: 300, child: _buildSearchField('Search by employee...')),
          ],
        );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          searchAndSelector,
          const SizedBox(height: 24),
          _buildTable(
            isMobile: isMobile,
            headers: ['LOG ID', 'EMPLOYEE PROFILE', 'CHECK-IN / OUT', 'PRODUCTIVE HOURS', 'LOCATION', 'STATUS', 'ACTION'],
            emptyMessage: 'No attendance logs recorded for this date.',
          ),
        ],
      ),
    );
  }

  Widget _buildShiftConfigView(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text(
                'Roster Shifts & Work Timings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
              ),
              _buildTableActionButton('+ Add Roster Shift', const Color(0xFF137333), () {
                showDialog(
                  context: context,
                  builder: (context) => const RosterShiftDialog(),
                );
              }),
            ],
          ),
          const SizedBox(height: 24),
          _buildTable(
            isMobile: isMobile,
            headers: ['SHIFT ID', 'SHIFT NAME', 'SHIFT TIMING', 'SHIFT TYPE', 'ALLOWED GRACE TIME', 'ACTIONS'],
            emptyMessage: 'No work shifts configured.',
          ),
        ],
      ),
    );
  }

  Widget _buildGpsFencingView(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Geo-Fenced Active GPS Coordinates',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Only check-ins inside these coordinate boundaries are verified automatically as \'present\' without manager intervention.',
            style: TextStyle(fontSize: 13, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildGpsCard(isMobile, 'Headquarters Office, Mumbai', '19.0760° N, 72.8777° E', '200 Meters'),
              _buildGpsCard(isMobile, 'Operations Godown Godown B, Pune', '18.5204° N, 73.8567° E', '500 Meters'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGpsCard(bool isMobile, String title, String coords, String radius) {
    return Container(
      width: isMobile ? double.infinity : 450,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
              const SizedBox(width: 8),
              _buildActiveBadge(),
            ],
          ),
          const SizedBox(height: 12),
          Text('Coordinates: $coords | Fence Radius: $radius', style: const TextStyle(fontSize: 12, color: AppColors.secondaryText)),
        ],
      ),
    );
  }

  Widget _buildActiveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(6)),
      child: const Text('Active', style: TextStyle(color: Color(0xFF137333), fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildCorrectionVerificationsView(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Regularization Verification Request Queue',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF065F46)),
          ),
          const SizedBox(height: 24),
          _buildTable(
            isMobile: isMobile,
            headers: ['Request ID', 'Employee Profile', 'Timesheet Date', 'Missed Punch Reason', 'Proposed Times', 'Approved By', 'Status', 'Action'],
            emptyMessage: 'No pending regularization requests.',
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarView(bool isMobile, double screenWidth) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _buildCalendarHeader('July 2026 Calendar'),
              _buildDropdown(['Select an Employee...', 'Rahul Dev', 'Michael Scott'], 'Select an Employee...'),
            ],
          ),
          const SizedBox(height: 24),
          _buildCalendarGrid(isMobile, screenWidth),
          const SizedBox(height: 24),
          _buildCalendarLegend(isMobile),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: () {}, icon: const Icon(LucideIcons.chevronLeft, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF065F46))),
        ),
        IconButton(onPressed: () {}, icon: const Icon(LucideIcons.chevronRight, size: 18), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
      ],
    );
  }

  Widget _buildCalendarGrid(bool isMobile, double screenWidth) {
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final dayHeight = isMobile ? 50.0 : 60.0;

    return Column(
      children: [
        Row(
          children: days.map((d) => Expanded(
            child: Center(child: Text(d, style: TextStyle(fontSize: isMobile ? 10 : 12, fontWeight: FontWeight.bold, color: AppColors.secondaryText)))
          )).toList(),
        ),
        const SizedBox(height: 12),
        ...List.generate(5, (row) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: List.generate(7, (col) {
              int day = (row * 7 + col) - 2;
              bool isValid = day > 0 && day <= 31;
              return Expanded(
                child: Container(
                  height: dayHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isValid ? const Color(0xFFF8FAFC) : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.all(6),
                  child: isValid ? Text('$day', style: TextStyle(fontSize: isMobile ? 10 : 12, color: AppColors.secondaryText)) : null,
                ),
              );
            }),
          ),
        )),
      ],
    );
  }

  Widget _buildCalendarLegend(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _buildLegendItem('Present', const Color(0xFF10B981).withValues(alpha: 0.15)),
        _buildLegendItem('Late', const Color(0xFFF59E0B).withValues(alpha: 0.15)),
        _buildLegendItem('Absent', const Color(0xFFEF4444).withValues(alpha: 0.15)),
        _buildLegendItem('No Data', const Color(0xFFF1F5F9)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3))),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Widget _buildSearchField(String hint) {
    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
          const SizedBox(width: 8),
          Expanded(child: TextField(decoration: InputDecoration(hintText: hint, hintStyle: const TextStyle(fontSize: 12), border: InputBorder.none, isDense: true))),
        ],
      ),
    );
  }

  Widget _buildDateChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: const TextStyle(color: Color(0xFF137333), fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDateSelector(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          const Icon(LucideIcons.calendar, size: 14),
        ],
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: false,
          style: const TextStyle(fontSize: 12, color: AppColors.darkText),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
          onChanged: (val) {},
        ),
      ),
    );
  }

  Widget _buildTableActionButton(String label, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }

  Widget _buildTable({required bool isMobile, required List<String> headers, required String emptyMessage}) {
    if (isMobile) {
      return Container(
        height: 140,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(LucideIcons.info, size: 40, color: AppColors.secondaryText.withValues(alpha: 0.3)),
            const SizedBox(height: 10),
            Text(emptyMessage, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText), textAlign: TextAlign.center),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        constraints: const BoxConstraints(minWidth: 1000),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: const BoxDecoration(color: Color(0xFFF8FAFC), border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5))),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                child: Text(h, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
              )).toList(),
            ),
            TableRow(
              children: List.generate(headers.length, (idx) {
                if (idx == (headers.length / 2).floor()) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(emptyMessage, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                  );
                }
                return const SizedBox();
              }),
            ),
          ],
        ),
      ),
    );
  }
}
