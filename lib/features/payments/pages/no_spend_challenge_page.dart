import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class NoSpendChallengePage extends StatefulWidget {
  const NoSpendChallengePage({super.key});

  @override
  State<NoSpendChallengePage> createState() => _NoSpendChallengePageState();
}

class _NoSpendChallengePageState extends State<NoSpendChallengePage> {
  int _targetDays = 20;
  
  // Set of day numbers in August 2026 marked as No-Spend Days
  final Set<int> _noSpendDays = {1, 2, 4, 5, 7, 8, 10, 11, 13, 14, 15, 17, 18, 20};
  final Set<int> _spentDays = {3, 6, 9, 12, 16, 19};

  void _toggleDay(int day) {
    if (day > 20) return; // Future days
    setState(() {
      if (_noSpendDays.contains(day)) {
        _noSpendDays.remove(day);
        _spentDays.add(day);
        AppSnackbar.show(context, 'Day $day marked as spend day', type: SnackType.info);
      } else {
        _spentDays.remove(day);
        _noSpendDays.add(day);
        AppSnackbar.show(context, 'Awesome! Day $day marked as No-Spend Day 🎉', type: SnackType.success);
      }
    });
  }

  void _openSetTargetDialog() {
    showDialog(
      context: context,
      builder: (context) => SetNoSpendTargetDialog(
        currentTarget: _targetDays,
        onTargetUpdated: (newTarget) {
          setState(() {
            _targetDays = newTarget;
          });
          AppSnackbar.show(context, 'Monthly target updated to $newTarget days!', type: SnackType.success);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    final completedCount = _noSpendDays.length;
    final progressPercent = (completedCount / _targetDays).clamp(0.0, 1.0);

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
            _buildStatCards(isMobile, completedCount).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // Progress Banner
            _buildProgressBarCard(completedCount, progressPercent).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 28),

            // Calendar Grid Container
            _buildCalendarCard(isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
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
          'No-Spend Days Challenge',
          style: TextStyle(fontSize: isMobile ? 19 : 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 4),
        const Text(
          'Achieve zero non-essential spending days and build lasting financial discipline.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionBtn = ElevatedButton.icon(
      onPressed: _openSetTargetDialog,
      icon: const Icon(LucideIcons.target, size: 16),
      label: const Text('Set Monthly Target', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    child: const Icon(LucideIcons.checkCircle2, color: AppColors.primaryGreen, size: 18),
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
                child: const Icon(LucideIcons.checkCircle2, color: AppColors.primaryGreen, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: titleCol),
              const SizedBox(width: 20),
              actionBtn,
            ],
          );
  }

  Widget _buildStatCards(bool isMobile, int completedCount) {
    final cashSaved = completedCount * 1250;
    final percentVal = ((completedCount / _targetDays) * 100).toInt();

    final cardsData = [
      {
        'label': 'NO-SPEND DAYS THIS MONTH',
        'value': '$completedCount / $_targetDays Days',
        'icon': LucideIcons.checkCircle2,
        'color': AppColors.primaryGreen,
      },
      {
        'label': 'ESTIMATED CASH PRESERVED',
        'value': '₹ $cashSaved',
        'icon': LucideIcons.shieldCheck,
        'color': AppColors.blue,
      },
      {
        'label': 'LONGEST ZERO-SPEND STREAK',
        'value': '6 Days',
        'icon': LucideIcons.zap,
        'color': Colors.amber,
      },
      {
        'label': 'TARGET COMPLETED',
        'value': '$percentVal%',
        'icon': LucideIcons.trophy,
        'color': Colors.purple,
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

  Widget _buildProgressBarCard(int completedCount, double progressPercent) {
    return Container(
      width: double.infinity,
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
              const Expanded(
                child: Text(
                  'August 2026 Monthly Challenge Progress',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.darkText),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${(progressPercent * 100).toInt()}%',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryGreen),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progressPercent,
              minHeight: 10,
              backgroundColor: AppColors.hoverBackground,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$completedCount of $_targetDays target No-Spend days completed. Keep going to earn your monthly badge!',
            style: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(bool isMobile) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
                      'August 2026 Challenge Calendar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        _buildLegendItem(AppColors.primaryGreen, 'No-Spend Day'),
                        _buildLegendItem(Colors.red.shade400, 'Spend Day'),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'August 2026 Challenge Calendar',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    Wrap(
                      spacing: 12,
                      children: [
                        _buildLegendItem(AppColors.primaryGreen, 'No-Spend Day'),
                        _buildLegendItem(Colors.red.shade400, 'Spend Day'),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 20),

          // Weekday header row
          Row(
            children: weekdays
                .map((day) => Expanded(
                      child: Center(
                        child: Text(
                          day,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.secondaryText),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 12),

          // 31 Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 31,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final dayNum = index + 1;
              final isNoSpend = _noSpendDays.contains(dayNum);
              final isSpent = _spentDays.contains(dayNum);
              final isFuture = dayNum > 20;

              Color bgColor = Colors.grey.shade100;
              Color textColor = AppColors.darkText;
              Widget? statusIcon;

              if (isNoSpend) {
                bgColor = AppColors.primaryGreen;
                textColor = Colors.white;
                statusIcon = const Icon(LucideIcons.check, size: 14, color: Colors.white);
              } else if (isSpent) {
                bgColor = Colors.red.shade50;
                textColor = Colors.red.shade700;
                statusIcon = Icon(LucideIcons.x, size: 14, color: Colors.red.shade700);
              } else if (isFuture) {
                bgColor = Colors.grey.shade50;
                textColor = Colors.grey.shade400;
              }

              return InkWell(
                onTap: isFuture ? null : () => _toggleDay(dayNum),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isNoSpend
                          ? AppColors.primaryGreen
                          : (isSpent ? Colors.red.shade200 : AppColors.border),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$dayNum',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 12 : 14,
                          color: textColor,
                        ),
                      ),
                      if (statusIcon != null) ...[
                        const SizedBox(height: 2),
                        statusIcon,
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Tap any date to toggle between No-Spend Day and Spend Day status.',
              style: TextStyle(fontSize: 11, color: AppColors.secondaryText, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11, color: AppColors.secondaryText, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class SetNoSpendTargetDialog extends StatefulWidget {
  final int currentTarget;
  final Function(int) onTargetUpdated;

  const SetNoSpendTargetDialog({
    super.key,
    required this.currentTarget,
    required this.onTargetUpdated,
  });

  @override
  State<SetNoSpendTargetDialog> createState() => _SetNoSpendTargetDialogState();
}

class _SetNoSpendTargetDialogState extends State<SetNoSpendTargetDialog> {
  late double _targetVal;

  @override
  void initState() {
    super.initState();
    _targetVal = widget.currentTarget.toDouble();
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
                    child: const Icon(LucideIcons.target, color: AppColors.primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Set Monthly Target Goal',
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
                      '${_targetVal.round()} Days',
                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Target No-Spend Days in August',
                      style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                    ),
                    const SizedBox(height: 24),
                    Slider(
                      value: _targetVal,
                      min: 5,
                      max: 28,
                      divisions: 23,
                      activeColor: AppColors.primaryGreen,
                      onChanged: (val) {
                        setState(() {
                          _targetVal = val;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onTargetUpdated(_targetVal.round());
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Update Target', style: TextStyle(fontWeight: FontWeight.bold)),
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
