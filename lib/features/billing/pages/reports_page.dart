import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';

class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  String _selectedReportType = 'Monthly Report';
  String _selectedMonth = 'Jun';
  String _selectedYear = '2026';

  final List<String> _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  final List<double> _incomeHeights = [240, 320, 340, 380, 420, 350, 380, 440, 350, 330, 280, 380];
  final List<double> _expenseHeights = [180, 160, 140, 320, 200, 220, 260, 270, 200, 230, 180, 260];

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
            // 1. Finance Analytics Header & Bar Chart (Screenshot 2)
            _buildFinanceAnalyticsSection(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 28),

            // 2. Summary Metric Cards (4 Cards Grid) (Screenshot 2 & 1)
            _buildMetricSummaryCards(context, isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // 3. Interactive Analytics Section (Screenshot 1)
            _buildInteractiveAnalyticsSection(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 28),

            // 4. Reports Engine Section (Screenshot 3)
            _buildReportsEngineSection(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 1. Finance Analytics Header & Bar Chart
  // ---------------------------------------------------------------------------
  Widget _buildFinanceAnalyticsSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Finance Analytics',
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Income vs Expense comparison',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.calendar, size: 14),
                    label: const Text('Yearly ∨', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkText,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(LucideIcons.slidersHorizontal, size: 14),
                    label: const Text('Filter', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkText,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Monthly Comparison Bar Chart
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 800,
              height: 240,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y-Axis Scale
                  SizedBox(
                    width: 50,
                    height: 200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹1000', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        Text('₹800', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        Text('₹600', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        Text('₹400', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        Text('₹200', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                        Text('₹0', style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                      ],
                    ),
                  ),

                  // Chart Bars Area
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(12, (index) {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Navy Bar (Income)
                                  Container(
                                    width: 10,
                                    height: (_incomeHeights[index] / 1000) * 160,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0F172A),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  // Grey Bar (Expense)
                                  Container(
                                    width: 10,
                                    height: (_expenseHeights[index] / 1000) * 160,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE2E8F0),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(height: 1, color: Colors.grey.shade200),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _months.map((m) => Text(m, style: TextStyle(fontSize: 11, color: Colors.grey.shade600))).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2. Metric Summary Cards (4 Cards Grid)
  // ---------------------------------------------------------------------------
  Widget _buildMetricSummaryCards(BuildContext context, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 950
            ? (constraints.maxWidth - 48) / 4
            : constraints.maxWidth > 550
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // Card 1: Stock
            _MetricCard(
              width: cardWidth,
              title: 'Stock',
              icon: LucideIcons.trendingUp,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              onViewDetails: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.stock),
              rows: const [
                _MetricRowData(label: 'Total Items', value: '26'),
                _MetricRowData(label: 'Total Value', value: '₹2,60,500'),
                _MetricRowData(label: 'Low Stock', value: '1 Item'),
              ],
            ),

            // Card 2: People
            _MetricCard(
              width: cardWidth,
              title: 'People',
              icon: LucideIcons.user,
              iconBgColor: const Color(0xFFFFF7ED),
              iconColor: const Color(0xFFD97706),
              onViewDetails: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.people),
              rows: const [
                _MetricRowData(label: 'Total Contacts', value: '12'),
                _MetricRowData(label: 'To Receive', value: '₹500'),
                _MetricRowData(label: 'To Pay', value: '₹200'),
              ],
            ),

            // Card 3: Finance
            _MetricCard(
              width: cardWidth,
              title: 'Finance',
              icon: LucideIcons.trendingUp,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              onViewDetails: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
              rows: const [
                _MetricRowData(label: 'Tracking', value: 'Active', valueColor: Color(0xFF059669)),
                _MetricRowData(label: 'Updates', value: 'Real-time', valueColor: Color(0xFF0F5132)),
              ],
            ),

            // Card 4: Financial Contacts
            _MetricCard(
              width: cardWidth,
              title: 'Financial Contacts',
              icon: LucideIcons.contact,
              iconBgColor: const Color(0xFFECFDF5),
              iconColor: const Color(0xFF059669),
              onViewDetails: () {},
              rows: const [
                _MetricRowData(label: 'Bankers', value: '2'),
                _MetricRowData(label: 'Advisors', value: '1'),
                _MetricRowData(label: 'Auditors', value: '1'),
              ],
            ),
          ],
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // 3. Interactive Analytics Section
  // ---------------------------------------------------------------------------
  Widget _buildInteractiveAnalyticsSection(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(LucideIcons.lineChart, color: Color(0xFF7C3AED), size: 20),
            SizedBox(width: 8),
            Text(
              'Interactive Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
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
                // Income vs Expense Card
                Container(
                  width: cardWidth,
                  height: 180,
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
                          Icon(LucideIcons.barChart2, size: 16, color: Color(0xFF1E3A8A)),
                          SizedBox(width: 8),
                          Text(
                            'Income vs Expense',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            children: [
                              Text('Income', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              const SizedBox(height: 4),
                              const Text('₹0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('Expense', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              const SizedBox(height: 4),
                              const Text('₹0', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),

                // Category Breakdown Card
                Container(
                  width: cardWidth,
                  height: 180,
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
                          Icon(LucideIcons.pieChart, size: 16, color: Color(0xFF1E3A8A)),
                          SizedBox(width: 8),
                          Text(
                            'Category Breakdown',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No expense records available',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Monthly Savings Growth Card (Full Width)
                Container(
                  width: constraints.maxWidth,
                  height: 180,
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
                          Icon(LucideIcons.lineChart, size: 16, color: Color(0xFF1E3A8A)),
                          SizedBox(width: 8),
                          Text(
                            'Monthly Savings Growth',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A)),
                          ),
                        ],
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'No historical trend data found',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // 4. Reports Engine Section (Screenshot 3)
  // ---------------------------------------------------------------------------
  Widget _buildReportsEngineSection(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
          // Header & Timeframe Selectors
          if (isMobile) ...[
            const Row(
              children: [
                Icon(LucideIcons.fileText, color: Color(0xFF7C3AED), size: 22),
                SizedBox(width: 8),
                Text(
                  'Reports Engine',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _DropdownFilterChip(
                    value: _selectedReportType,
                    items: const ['Monthly Report', 'Quarterly Report', 'Annual Report'],
                    onChanged: (val) => setState(() => _selectedReportType = val!),
                  ),
                  const SizedBox(width: 8),
                  _DropdownFilterChip(
                    value: _selectedMonth,
                    items: _months,
                    onChanged: (val) => setState(() => _selectedMonth = val!),
                  ),
                  const SizedBox(width: 8),
                  _DropdownFilterChip(
                    value: _selectedYear,
                    items: const ['2024', '2025', '2026'],
                    onChanged: (val) => setState(() => _selectedYear = val!),
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.fileText, color: Color(0xFF7C3AED), size: 22),
                    SizedBox(width: 8),
                    Text(
                      'Reports Engine',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _DropdownFilterChip(
                      value: _selectedReportType,
                      items: const ['Monthly Report', 'Quarterly Report', 'Annual Report'],
                      onChanged: (val) => setState(() => _selectedReportType = val!),
                    ),
                    const SizedBox(width: 8),
                    _DropdownFilterChip(
                      value: _selectedMonth,
                      items: _months,
                      onChanged: (val) => setState(() => _selectedMonth = val!),
                    ),
                    const SizedBox(width: 8),
                    _DropdownFilterChip(
                      value: _selectedYear,
                      items: const ['2024', '2025', '2026'],
                      onChanged: (val) => setState(() => _selectedYear = val!),
                    ),
                  ],
                ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Monthly Statement Summary Box
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Monthly Statement Summary',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(LucideIcons.calendar, size: 12, color: Colors.grey.shade500),
                            const SizedBox(width: 4),
                            Text('$_selectedMonth $_selectedYear', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          ],
                        ),
                      ],
                    ),
                    if (!isMobile)
                      Text(
                        'Generated dynamically via CLIKS Books',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                      ),
                  ],
                ),

                const SizedBox(height: 20),

                // 4 Summary Boxes Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final boxWidth = constraints.maxWidth > 800
                        ? (constraints.maxWidth - 48) / 4
                        : constraints.maxWidth > 480
                            ? (constraints.maxWidth - 16) / 2
                            : constraints.maxWidth;

                    return Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        _SummaryStatBox(width: boxWidth, label: 'INCOME SUMMARY', value: '₹0', valueColor: const Color(0xFF059669)),
                        _SummaryStatBox(width: boxWidth, label: 'EXPENSE SUMMARY', value: '₹0', valueColor: const Color(0xFFDC2626)),
                        _SummaryStatBox(width: boxWidth, label: 'SAVINGS SUMMARY', value: '₹0', valueColor: const Color(0xFF7C3AED)),
                        _SummaryStatBox(width: boxWidth, label: 'BUDGET SUMMARY', value: '₹20,000', valueColor: AppColors.darkText),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 24),

                Center(
                  child: Text(
                    'No transaction history found for selected timeframe.',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Export Action Buttons Row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.download, size: 14),
                  label: const Text('Export CSV', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkText,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.download, size: 14),
                  label: const Text('Export Excel', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.darkText,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.printer, size: 14),
                  label: const Text('Export PDF / Print', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0F5132),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Metric Card Helper Component
// -----------------------------------------------------------------------------
class _MetricCard extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final VoidCallback onViewDetails;
  final List<_MetricRowData> rows;

  const _MetricCard({
    required this.width,
    required this.title,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.onViewDetails,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.darkText,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    InkWell(
                      onTap: onViewDetails,
                      child: Row(
                        children: [
                          Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                            ),
                          ),
                          const SizedBox(width: 3),
                          Icon(LucideIcons.arrowRight, size: 12, color: Colors.green.shade700),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      r.label,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                    ),
                    Text(
                      r.value,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: r.valueColor ?? AppColors.darkText,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _MetricRowData {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetricRowData({
    required this.label,
    required this.value,
    this.valueColor,
  });
}

// -----------------------------------------------------------------------------
// Dropdown Filter Chip
// -----------------------------------------------------------------------------
class _DropdownFilterChip extends StatelessWidget {
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownFilterChip({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: const Icon(LucideIcons.chevronDown, size: 14),
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText),
          onChanged: onChanged,
          items: items.map((i) {
            return DropdownMenuItem<String>(
              value: i,
              child: Text(i),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Summary Stat Box
// -----------------------------------------------------------------------------
class _SummaryStatBox extends StatelessWidget {
  final double width;
  final String label;
  final String value;
  final Color valueColor;

  const _SummaryStatBox({
    required this.width,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
        ],
      ),
    );
  }
}
