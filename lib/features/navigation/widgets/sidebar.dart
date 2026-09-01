import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../../payments/widgets/add_money_dialog.dart';
import 'sidebar_utility_rail.dart';

class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigation = ref.watch(navigationProvider);

    final double topPadding = MediaQuery.of(context).padding.top;

    return Container(
      width: 285,
      decoration: const BoxDecoration(
        color: AppColors.sidebarBackground,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Top section - stays fixed curvy green gradient card
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, 24 + topPadding, 16, 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.primaryGreen, Color(0xFF0F5B2E)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      clipBehavior: Clip.antiAlias,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9), // Light green covering the curvy square
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.asset(
                        'assets/cliks_logo.png',
                        width: 28,
                        height: 28,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Cliks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(height: 1, thickness: 1, color: Colors.white.withValues(alpha: 0.2)),
                const SizedBox(height: 12),
                const SidebarUtilityRail(),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Scrollable rest of the list (now inline in main ListView)
                if (navigation.currentModule == AppModule.books) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: InkWell(
                      onTap: () {
                        ref.read(navigationProvider.notifier).setRoute(AppRoute.dashboard);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: (navigation.currentRoute == AppRoute.dashboard)
                              ? AppColors.primaryGreen.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: (navigation.currentRoute == AppRoute.dashboard)
                                ? AppColors.primaryGreen
                                : Colors.transparent,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              LucideIcons.layoutDashboard,
                              size: 20,
                              color: (navigation.currentRoute == AppRoute.dashboard)
                                  ? AppColors.primaryGreen
                                  : AppColors.secondaryText,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Dashboard',
                                style: TextStyle(
                                  color: (navigation.currentRoute == AppRoute.dashboard)
                                      ? AppColors.primaryGreen
                                      : AppColors.darkText,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.wallet,
                    label: 'Finance',
                    isSelected: navigation.currentRoute == AppRoute.accounting,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.trendingUp,
                    label: 'Stock',
                    isSelected: navigation.currentRoute == AppRoute.stock,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.stock);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.users,
                    label: 'People',
                    isSelected: navigation.currentRoute == AppRoute.people,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.people);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.split,
                    label: 'Split Expenses',
                    isSelected: navigation.currentRoute == AppRoute.splitCollect,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.splitCollect);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.barChart2,
                    label: 'Report',
                    isSelected: navigation.currentRoute == AppRoute.reports,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.reports);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.compass,
                    label: 'Track',
                    isSelected: navigation.currentRoute == AppRoute.track,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.track);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.target,
                    label: 'Goal Buckets',
                    isSelected: navigation.currentRoute == AppRoute.goalBuckets,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.goalBuckets);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.folder,
                    label: 'Documents',
                    isSelected: navigation.currentRoute == AppRoute.documents,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.documents);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.briefcase,
                    label: 'FIN-PRO',
                    isSelected: navigation.currentRoute == AppRoute.auditHub,
                    onTap: () {
                      final scaffold = Scaffold.maybeOf(context);
                      if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.auditHub);
                    },
                  ),
                  _SidebarItem(
                    icon: LucideIcons.sparkles,
                    label: 'Refer & Earn',
                    isSelected: navigation.currentRoute == AppRoute.referral,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.referral),
                  ),
                ] else if (navigation.currentModule == AppModule.payments) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => const AddMoneyDialog(),
                        );
                      },
                      icon: const Icon(LucideIcons.plus, size: 16),
                      label: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.calendarDays,
                    label: 'Planner',
                    isSelected: navigation.currentRoute == AppRoute.planner,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.planner),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.wallet,
                    label: 'Wallet',
                    isSelected: navigation.currentRoute == AppRoute.wallet,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.wallet),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.history,
                    label: 'Transaction',
                    isSelected: navigation.currentRoute == AppRoute.transaction,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.transaction),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.split,
                    label: 'Segregation',
                    isSelected: navigation.currentRoute == AppRoute.segregation,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.segregation),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.gift,
                    label: 'Rewards & Offers',
                    isSelected: navigation.currentRoute == AppRoute.rewards,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.rewards),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.sparkles,
                    label: 'Refer & Earn',
                    isSelected: navigation.currentRoute == AppRoute.referral,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.referral),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.activity,
                    label: 'Cash Flow Heatmap',
                    isSelected: navigation.currentRoute == AppRoute.cashFlowHeatmap,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.cashFlowHeatmap),
                  ),
                ] else if (navigation.currentModule == AppModule.social) ...[
                  _SidebarItem(
                    icon: LucideIcons.fileText,
                    label: 'Trading docs',
                    isSelected: navigation.currentRoute == AppRoute.tradingDocs,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.tradingDocs),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.userCheck,
                    label: 'BETA Club',
                    isSelected: navigation.currentRoute == AppRoute.betaClub,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.betaClub),
                  ),
                  _SidebarItem(
                    icon: LucideIcons.sparkles,
                    label: 'Refer & Earn',
                    isSelected: navigation.currentRoute == AppRoute.referral,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.referral),
                  ),
                ] else if (navigation.currentModule == AppModule.profile) ...[
                  _SidebarItem(
                    icon: LucideIcons.user,
                    label: 'Account Profile',
                    isSelected: navigation.currentRoute == AppRoute.profile,
                    onTap: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.profile),
                  ),
                ],

                // Global Settings and Help & Support items
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Divider(height: 1, thickness: 1, color: AppColors.border),
                ),
                _SidebarItem(
                  icon: LucideIcons.settings,
                  label: 'Settings',
                  isSelected: navigation.currentRoute == AppRoute.settings,
                  onTap: () => ref.read(navigationProvider.notifier).setModuleAndRoute(AppModule.profile, AppRoute.settings),
                ),
                _SidebarItem(
                  icon: LucideIcons.helpCircle,
                  label: 'Help & Support',
                  isSelected: navigation.currentRoute == AppRoute.help,
                  onTap: () => ref.read(navigationProvider.notifier).setModuleAndRoute(AppModule.profile, AppRoute.help),
                ),

                if (navigation.currentModule == AppModule.books || navigation.currentModule == AppModule.payments) ...[
                  const _PlanBanner(),
                ],
                if (navigation.currentModule != AppModule.profile) const _BottomActions(),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;
  final bool isHeader;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.trailing,
    this.isHeader = false,
  });

  @override
  Widget build(BuildContext context) {
    final trailingWidget = trailing;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: InkWell(
        onTap: () {
          onTap();
          if (!isHeader && Scaffold.of(context).isDrawerOpen) {
            Navigator.of(context).pop();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primaryGreen : AppColors.secondaryText,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? AppColors.primaryGreen : AppColors.darkText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              ?trailingWidget,
              if (isSelected) ...[
                const SizedBox(width: 8),
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

final sidebarExpandedProvider = StateProvider<Map<String, bool>>((ref) => {});

class _SidebarExpandable extends ConsumerWidget {
  final IconData icon;
  final String label;
  final List<Widget> children;
  final bool isInitiallyExpanded;

  const _SidebarExpandable({
    required this.icon,
    required this.label,
    required this.children,
  }) : isInitiallyExpanded = false;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedStates = ref.watch(sidebarExpandedProvider);
    final isExpanded = expandedStates[label] ?? isInitiallyExpanded;

    return Column(
      children: [
        _SidebarItem(
          icon: icon,
          label: label,
          isSelected: false,
          isHeader: true,
          onTap: () {
            ref.read(sidebarExpandedProvider.notifier).update((state) => {
              ...state,
              label: !isExpanded,
            });
          },
          trailing: Icon(
            isExpanded ? LucideIcons.chevronUp : LucideIcons.chevronDown,
            size: 16,
            color: AppColors.secondaryText,
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(children: children),
          ),
      ],
    );
  }
}

class _SidebarSubItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarSubItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      onTap: () {
        onTap();
        if (Scaffold.of(context).isDrawerOpen) {
          Navigator.of(context).pop();
        }
      },
      title: Text(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.primaryGreen : AppColors.secondaryText,
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }
}

class _BottomActions extends ConsumerWidget {
  const _BottomActions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'CLIKS',
                style: TextStyle(
                  color: AppColors.darkText,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'App Version 2.4.0',
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 11,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Terminate Session?'),
                  content: const Text('Are you sure you want to disconnect from the active business session?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: const Text('Terminate', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              LucideIcons.power,
              color: Colors.redAccent,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanBanner extends ConsumerWidget {
  const _PlanBanner();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final scaffold = Scaffold.maybeOf(context);
        if (scaffold != null && scaffold.isDrawerOpen) Navigator.pop(context);
        ref.read(navigationProvider.notifier).setRoute(AppRoute.subscription);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF14275E), // Darker professional blue
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF14275E).withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(LucideIcons.crown, color: Color(0xFFF2C94C), size: 24),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Get Subscription',
                    style: TextStyle(
                      color: Color(0xFFF2C94C), // High-visibility yellow
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFF2C94C), width: 3),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '20',
                    style: TextStyle(
                      color: Color(0xFF14275E),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'DAYS',
                    style: TextStyle(
                      color: Color(0xFF14275E),
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

