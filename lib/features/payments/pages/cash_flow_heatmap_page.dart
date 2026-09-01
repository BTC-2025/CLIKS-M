import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class CashFlowHeatmapPage extends StatefulWidget {
  const CashFlowHeatmapPage({super.key});

  @override
  State<CashFlowHeatmapPage> createState() => _CashFlowHeatmapPageState();
}

class _CashFlowHeatmapPageState extends State<CashFlowHeatmapPage> {
  int _peakDayCap = 2500;
  int? _selectedDayIndex;

  // 35 days (5 weeks x 7 days) of spending intensities
  final List<int> _dailySpending = [
    250, 400, 150, 600, 2200, 4500, 3800,
    180, 320, 110, 480, 1800, 3900, 4100,
    0, 280, 410, 520, 2600, 5100, 3600,
    300, 150, 220, 710, 1900, 4200, 4900,
    210, 390, 180, 640, 2100, 0, 0
  ];

  final List<String> _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void _openCapDialog() {
    showDialog(
      context: context,
      builder: (context) => SetSpendingCapDialog(
        currentCap: _peakDayCap,
        onCapUpdated: (newCap) {
          setState(() {
            _peakDayCap = newCap;
          });
          AppSnackbar.show(context, 'Weekend/Peak Day Spending Cap updated to ₹$newCap!', type: SnackType.success);
        },
      ),
    );
  }

  Color _getHeatmapColor(int amount) {
    if (amount == 0) return Colors.grey.shade100;
    if (amount <= 500) return AppColors.primaryGreen.withValues(alpha: 0.25);
    if (amount <= 1500) return AppColors.primaryGreen.withValues(alpha: 0.65);
    if (amount <= 3000) return Colors.amber.shade600;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    final totalOutflow = _dailySpending.fold<int>(0, (sum, val) => sum + val);

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context, isMobile).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
            const SizedBox(height: 28),

            // Stat Cards 2x2 Grid
            _buildStatCards(isMobile, totalOutflow).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // GitHub-Style Heatmap Grid Container
            _buildHeatmapCard(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 28),

            // Weekday Peak Analysis Bar Charts
            _buildWeekdayAnalysisCard(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    final titleCol = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cash Flow Heatmap & Peak Days',
          style: TextStyle(fontSize: isMobile ? 19 : 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 4),
        const Text(
          'Visualize spending intensity patterns across days of the week to set conscious boundaries.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionBtn = ElevatedButton.icon(
      onPressed: _openCapDialog,
      icon: const Icon(LucideIcons.sliders, size: 16),
      label: const Text('Set Spending Boundary', style: TextStyle(fontWeight: FontWeight.bold)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
      ),
    );

    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.hoverBackground,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(LucideIcons.activity, color: AppColors.primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: titleCol),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: actionBtn),
            ],
          )
        : Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.hoverBackground,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(LucideIcons.activity, color: AppColors.primaryGreen, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: titleCol),
              const SizedBox(width: 20),
              actionBtn,
            ],
          );
  }

  Widget _buildStatCards(bool isMobile, int totalOutflow) {
    final cardsData = [
      {
        'label': 'PEAK SPENDING DAY',
        'value': 'Saturday (₹ 4.4k)',
        'icon': LucideIcons.trendingUp,
        'color': Colors.red,
      },
      {
        'label': 'LOWEST SPENDING DAY',
        'value': 'Wednesday (₹ 220)',
        'icon': LucideIcons.trendingDown,
        'color': AppColors.primaryGreen,
      },
      {
        'label': 'WEEKEND VS WEEKDAY',
        'value': '+185% Higher',
        'icon': LucideIcons.barChart2,
        'color': Colors.amber,
      },
      {
        'label': 'MONTHLY TOTAL OUTFLOW',
        'value': '₹ $totalOutflow',
        'icon': LucideIcons.wallet,
        'color': AppColors.blue,
      },
    ];

    final cardWidgets = cardsData.map((c) {
      final iconColor = c['color'] as Color;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
                  child: Text(
                    c['label'] as String,
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 8.5, fontWeight: FontWeight.bold, letterSpacing: 0.2),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(c['icon'] as IconData, color: iconColor, size: 13),
                ),
              ],
            ),
            const SizedBox(height: 6),
            FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                c['value'] as String,
                style: const TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      );
    }).toList();

    if (isMobile) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(child: cardWidgets[0]),
              const SizedBox(width: 12),
              Expanded(child: cardWidgets[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: cardWidgets[2]),
              const SizedBox(width: 12),
              Expanded(child: cardWidgets[3]),
            ],
          ),
        ],
      );
    }

    return Row(
      children: cardWidgets
          .map((c) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: c,
                ),
              ))
          .toList(),
    );
  }

  Widget _buildHeatmapCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spending Intensity Heatmap',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Low', style: TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                        Container(width: 10, height: 10, color: Colors.grey.shade100),
                        Container(width: 10, height: 10, color: AppColors.primaryGreen.withValues(alpha: 0.25)),
                        Container(width: 10, height: 10, color: AppColors.primaryGreen.withValues(alpha: 0.65)),
                        Container(width: 10, height: 10, color: Colors.amber.shade600),
                        Container(width: 10, height: 10, color: Colors.red.shade600),
                        const Text('Peak', style: TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Spending Intensity Heatmap',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    Wrap(
                      spacing: 8,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        const Text('Low', style: TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                        Container(width: 10, height: 10, color: Colors.grey.shade100),
                        Container(width: 10, height: 10, color: AppColors.primaryGreen.withValues(alpha: 0.25)),
                        Container(width: 10, height: 10, color: AppColors.primaryGreen.withValues(alpha: 0.65)),
                        Container(width: 10, height: 10, color: Colors.amber.shade600),
                        Container(width: 10, height: 10, color: Colors.red.shade600),
                        const Text('Peak', style: TextStyle(fontSize: 10, color: AppColors.secondaryText)),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 20),

          // Heatmap grid (5 columns for weeks x 7 rows for days)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Weekday labels column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _weekdays
                      .map((w) => SizedBox(
                            height: 28,
                            child: Center(
                              child: Text(
                                w,
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(width: 12),

                // 5 Weeks columns
                Row(
                  children: List.generate(5, (weekIdx) {
                    return Column(
                      children: List.generate(7, (dayIdx) {
                        final cellIndex = (weekIdx * 7) + dayIdx;
                        final amount = cellIndex < _dailySpending.length ? _dailySpending[cellIndex] : 0;
                        final isSelected = _selectedDayIndex == cellIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = cellIndex;
                            });
                          },
                          child: Container(
                            width: 32,
                            height: 24,
                            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getHeatmapColor(amount),
                              borderRadius: BorderRadius.circular(4),
                              border: isSelected ? Border.all(color: AppColors.darkText, width: 2) : null,
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              ],
            ),
          ),

          if (_selectedDayIndex != null && _selectedDayIndex! < _dailySpending.length) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.hoverBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(LucideIcons.info, size: 16, color: AppColors.primaryGreen),
                  const SizedBox(width: 8),
                  Text(
                    'Day ${_selectedDayIndex! + 1} Spending: ₹${_dailySpending[_selectedDayIndex!]}',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWeekdayAnalysisCard(bool isMobile) {
    final weekdayAverages = [
      {'day': 'Mon', 'avg': 230},
      {'day': 'Tue', 'avg': 340},
      {'day': 'Wed', 'avg': 210},
      {'day': 'Thu', 'avg': 580},
      {'day': 'Fri', 'avg': 2150},
      {'day': 'Sat', 'avg': 4420},
      {'day': 'Sun', 'avg': 3850},
    ];

    const maxAvg = 4500.0;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Weekday Outflow Breakdown',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Cap Boundary: ₹$_peakDayCap',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Weekday Outflow Breakdown',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Cap Boundary: ₹$_peakDayCap',
                        style: TextStyle(color: Colors.red.shade700, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
          const SizedBox(height: 24),

          // Bar Chart Row
          SizedBox(
            height: 140,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: weekdayAverages.map((item) {
                final avgVal = item['avg'] as int;
                final heightRatio = (avgVal / maxAvg).clamp(0.05, 1.0);
                final isExceedingCap = avgVal > _peakDayCap;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '₹$avgVal',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: isExceedingCap ? Colors.red.shade700 : AppColors.secondaryText,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 100 * heightRatio,
                        width: isMobile ? 16 : 28,
                        decoration: BoxDecoration(
                          color: isExceedingCap ? Colors.red.shade500 : AppColors.primaryGreen,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['day'] as String,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SetSpendingCapDialog extends StatefulWidget {
  final int currentCap;
  final Function(int) onCapUpdated;

  const SetSpendingCapDialog({
    super.key,
    required this.currentCap,
    required this.onCapUpdated,
  });

  @override
  State<SetSpendingCapDialog> createState() => _SetSpendingCapDialogState();
}

class _SetSpendingCapDialogState extends State<SetSpendingCapDialog> {
  late double _capVal;

  @override
  void initState() {
    super.initState();
    _capVal = widget.currentCap.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Dialog(
      backgroundColor: Colors.white,
      alignment: Alignment.bottomCenter,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      insetPadding: EdgeInsets.zero,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 500,
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag Handle
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 12, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.sliders, color: AppColors.primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Set Peak Day Cap',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(LucideIcons.x, size: 18, color: AppColors.secondaryText),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: AppColors.border),

            // Scrollable Content Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      '₹ ${_capVal.round()}',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Maximum Spending Allowance per Peak Day',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 24),
                    Slider(
                      value: _capVal,
                      min: 500,
                      max: 5000,
                      divisions: 45,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) {
                        setState(() {
                          _capVal = val;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onCapUpdated(_capVal.round());
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Save Boundary Cap', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
