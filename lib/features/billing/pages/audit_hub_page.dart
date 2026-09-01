import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';
import '../widgets/request_document_dialog.dart';
import '../widgets/assign_task_dialog.dart';
import '../widgets/register_client_dialog.dart';
import '../widgets/invite_team_dialog.dart';

class AuditHubPage extends StatefulWidget {
  const AuditHubPage({super.key});

  @override
  State<AuditHubPage> createState() => _AuditHubPageState();
}

class _AuditHubPageState extends State<AuditHubPage> {
  int _activeWorkplace = 0; // 0: Business Command Centre, 1: Advisory Workspace (Firm)
  int _activeAdvisoryTab = 0; // 0: Home, 1: Clients, 2: Client Requests, 3: Tasks, 4: Teams, etc.
  final TextEditingController _emailController = TextEditingController();

  final List<String> _advisoryTabs = [
    'Home',
    'Clients',
    'Client Requests',
    'Tasks',
    'Teams',
    'Team Requests',
    'Time Tracking',
    'Workpaper',
    'Documents',
    'Reports',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
            // Header Switcher row
            _buildHeaderWorkplaceToggle(isMobile)
                .animate()
                .fadeIn(duration: 400.ms)
                .slideY(begin: -0.05, end: 0),
            const SizedBox(height: 24),

            if (_activeWorkplace == 0) ...[
              // Business Command Centre Views
              _buildMainBannerCard().animate().fadeIn(duration: 450.ms, delay: 80.ms),
              const SizedBox(height: 24),
              // Two Column Section
              if (isMobile)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildComplianceChecklistCard(),
                    const SizedBox(height: 24),
                    _buildAccountantConnectionCard(isMobile),
                  ],
                ).animate().fadeIn(duration: 500.ms, delay: 160.ms)
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: _buildComplianceChecklistCard(),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      flex: 2,
                      child: _buildAccountantConnectionCard(isMobile),
                    ),
                  ],
                ).animate().fadeIn(duration: 500.ms, delay: 160.ms),
            ] else ...[
              // Advisory Workspace (Firm) Views
              _buildAdvisoryTabsBar(isMobile).animate().fadeIn(duration: 400.ms, delay: 80.ms),
              const SizedBox(height: 24),
              _buildAdvisoryContent(isMobile).animate().fadeIn(duration: 500.ms, delay: 160.ms),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWorkplaceToggle(bool isMobile) {
    final businessBtn = Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeWorkplace = 0),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _activeWorkplace == 0 ? const Color(0xFF0F3A8E) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _activeWorkplace == 0 ? const Color(0xFF0F3A8E) : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.monitor,
                color: _activeWorkplace == 0 ? Colors.white : Colors.black87,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                'FIN-PRO Command Centre (Business)',
                style: TextStyle(
                  color: _activeWorkplace == 0 ? Colors.white : Colors.black87,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final firmBtn = Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeWorkplace = 1),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: _activeWorkplace == 1 ? const Color(0xFF1B5E20) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _activeWorkplace == 1 ? const Color(0xFF1B5E20) : AppColors.border,
            ),
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                LucideIcons.userCheck,
                color: _activeWorkplace == 1 ? Colors.white : Colors.black54,
                size: 15,
              ),
              const SizedBox(width: 8),
              Text(
                'FIN-PRO Advisory Workspace (Firm)',
                style: TextStyle(
                  color: _activeWorkplace == 1 ? Colors.white : Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          Row(children: [businessBtn]),
          const SizedBox(height: 10),
          Row(children: [firmBtn]),
        ],
      );
    }

    return Row(
      children: [
        businessBtn,
        const SizedBox(width: 16),
        firmBtn,
      ],
    );
  }

  Widget _buildMainBannerCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.briefcase, color: Color(0xFF0F3A8E), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'FIN-PRO Command Centre',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FE),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PROFESSIONAL LAYER',
                        style: TextStyle(
                          color: Color(0xFF0F3A8E),
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Manage audits, taxes, compliance, and client reports in one place.',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceChecklistCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.checkCircle, color: Color(0xFF0F3A8E), size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'FIN-PRO-Assigned Checklist',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F4EA),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.check, size: 9, color: Color(0xFF137333)),
                    SizedBox(width: 4),
                    Text(
                      'All Caught Up!',
                      style: TextStyle(color: Color(0xFF137333), fontSize: 8.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "These are the live compliance and audit actions assigned to your account by your connected FIN-PRO. Mark them as 'Completed' or 'In Progress' to sync status in real time.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 28),

          // Inner Empty State Card
          Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE6F4EA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.check, color: Color(0xFF137333), size: 24),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Active Tasks',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Your FIN-PRO Advisor hasn't assigned any compliance checklists to your email yet.",
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountantConnectionCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(LucideIcons.users, color: Color(0xFF0F3A8E), size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Accountant Connection',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Not Connected',
                  style: TextStyle(color: Colors.black54, fontSize: 8.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Invite your FIN-PRO Advisory Partner to securely manage your taxes, scan transactions for compliance, and compile operational financial audits in real time.",
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
          ),
          const SizedBox(height: 20),

          // Email Input & Invite Button Form
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: _emailController,
                    style: const TextStyle(fontSize: 11.5),
                    decoration: const InputDecoration(
                      hintText: "Enter your FIN-PRO's professional email...",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 11),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final email = _emailController.text.trim();
                  if (email.isEmpty) {
                    AppSnackbar.show(
                      context,
                      "Please enter a valid FIN-PRO email address.",
                      type: SnackType.warning,
                    );
                  } else {
                    AppSnackbar.show(
                      context,
                      "Invitation sent successfully to $email!",
                      type: SnackType.success,
                    );
                    _emailController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3A8E),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text('+ Invite FIN-PRO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Sharing details section
          const Text(
            'What you will share with your FIN-PRO:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 12),

          // Grid list of features shared
          _buildShareFeatureItem('Check GST & Tax Records', 'Validates input credit & filing status'),
          const SizedBox(height: 10),
          _buildShareFeatureItem('Analyze Invoices & Fraud Risks', 'Flags suspicious payments & variance scores'),
          const SizedBox(height: 10),
          _buildShareFeatureItem('Map International Accounts', 'IFRS / US GAAP layout mapping'),
          const SizedBox(height: 10),
          _buildShareFeatureItem('Reconcile Bank Feed Transactions', 'Matches inbound ledger payments'),
        ],
      ),
    );
  }

  Widget _buildShareFeatureItem(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(LucideIcons.check, color: Color(0xFF137333), size: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 9.5, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisoryTabsBar(bool isMobile) {
    final List<IconData> icons = [
      LucideIcons.home,
      LucideIcons.users,
      LucideIcons.helpCircle,
      LucideIcons.checkCircle,
      LucideIcons.userCheck,
      LucideIcons.userPlus,
      LucideIcons.clock,
      LucideIcons.fileText,
      LucideIcons.folder,
      LucideIcons.barChart,
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_advisoryTabs.length, (index) {
          final isSelected = _activeAdvisoryTab == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _activeAdvisoryTab = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFE8F5E9) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? const Color(0xFF81C784) : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      icons[index],
                      size: 14,
                      color: isSelected ? const Color(0xFF1B5E20) : AppColors.secondaryText,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _advisoryTabs[index],
                      style: TextStyle(
                        color: isSelected ? const Color(0xFF1B5E20) : AppColors.secondaryText,
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

  Widget _buildAdvisoryContent(bool isMobile) {
    switch (_activeAdvisoryTab) {
      case 0:
        return _buildAdvisoryHomeTab(isMobile);
      case 1:
        return _buildAdvisoryClientsTab(isMobile);
      case 2:
        return _buildAdvisoryClientRequestsTab(isMobile);
      case 3:
        return _buildAdvisoryTasksTab(isMobile);
      case 4:
        return _buildAdvisoryTeamsTab(isMobile);
      case 5:
        return _buildAdvisoryTeamRequestsTab(isMobile);
      case 6:
        return _buildAdvisoryTimeTrackingTab(isMobile);
      case 7:
        return _buildAdvisoryWorkpaperTab(isMobile);
      case 8:
        return _buildAdvisoryDocumentsTab(isMobile);
      case 9:
        return _buildAdvisoryReportsTab(isMobile);
      default:
        return _buildAdvisoryFallbackTab(_advisoryTabs[_activeAdvisoryTab]);
    }
  }

  Widget _buildAdvisoryHomeTab(bool isMobile) {
    final stats = [
      _buildAdvisoryStatCard(
        title: 'Total Practice Clients',
        value: '0',
        subtitle: 'Active Taxpayers Portal',
        color: const Color(0xFF1B5E20),
        bgColor: const Color(0xFFE8F5E9),
        icon: LucideIcons.users,
      ),
      _buildAdvisoryStatCard(
        title: 'Awaiting Client Uploads',
        value: '0',
        subtitle: 'Outbound requests pending',
        color: const Color(0xFFEF6C00),
        bgColor: const Color(0xFFFFF3E0),
        icon: LucideIcons.uploadCloud,
      ),
      _buildAdvisoryStatCard(
        title: 'Open Compliance Tasks',
        value: '0',
        subtitle: 'Filing checklist items',
        color: const Color(0xFFD32F2F),
        bgColor: const Color(0xFFFFEBEE),
        icon: LucideIcons.checkCircle,
      ),
      _buildAdvisoryStatCard(
        title: 'Timesheet Records',
        value: '0',
        subtitle: 'Logged consulting blocks',
        color: const Color(0xFF1976D2),
        bgColor: const Color(0xFFE3F2FD),
        icon: LucideIcons.clock,
      ),
    ];

    final statsGrid = isMobile
        ? Column(
            children: [
              Row(
                children: [
                  Expanded(child: stats[0]),
                  const SizedBox(width: 12),
                  Expanded(child: stats[1]),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: stats[2]),
                  const SizedBox(width: 12),
                  Expanded(child: stats[3]),
                ],
              ),
            ],
          )
        : Row(
            children: stats.map((s) => Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: s,
              ),
            )).toList(),
          );

    final leftCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.bookOpen, color: Color(0xFF1B5E20), size: 16),
              const SizedBox(width: 8),
              const Text(
                'Practice Activity Stream',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 36),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'No practice activities recorded yet. Add clients or create tasks to see live updates.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );

    final rightCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.zap, color: Colors.amber, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Quick Practice Actions',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildQuickActionButton('Add New Practice Client', LucideIcons.plusCircle, () {
            setState(() => _activeAdvisoryTab = 1);
          }),
          const SizedBox(height: 12),
          _buildQuickActionButton('Request Client Document', LucideIcons.helpCircle, () {
            setState(() => _activeAdvisoryTab = 2);
          }),
          const SizedBox(height: 12),
          _buildQuickActionButton('Create Operations Task', LucideIcons.checkSquare, () {
            setState(() => _activeAdvisoryTab = 3);
          }),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        statsGrid,
        const SizedBox(height: 24),
        if (isMobile)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              leftCard,
              const SizedBox(height: 24),
              rightCard,
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: leftCard),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: rightCard),
            ],
          ),
      ],
    );
  }

  Widget _buildAdvisoryStatCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required Color bgColor,
    required IconData icon,
  }) {
    return IntrinsicHeight(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 4,
              color: color,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey.shade500),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          alignment: Alignment.centerLeft,
                          fit: BoxFit.scaleDown,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
                          child: Icon(icon, color: color, size: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: color),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
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

  Widget _buildQuickActionButton(String label, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFC8E6C9)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF2E7D32), size: 14),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF2E7D32),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdvisoryClientsTab(bool isMobile) {
    final headers = [
      'TAXPAYER NAME',
      'EMAIL ADDRESS',
      'REGIME',
      'EST. GROSS INCOME',
      'PENDING FILINGS',
      'STATUS',
    ];
    final columnWidths = [2.0, 2.2, 1.8, 1.8, 1.5, 1.5];

    final rows = [
      [
        const Text('Acme Corp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('finance@acme.com', style: TextStyle(fontSize: 12)),
        const Text('New Tax Regime', style: TextStyle(fontSize: 12)),
        const Text('₹45,00,000', style: TextStyle(fontSize: 12)),
        const Text('2', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
        _buildStatusBadge('Active', Colors.green),
      ],
      [
        const Text('Wayne Enterprises', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('bruce@wayne.com', style: TextStyle(fontSize: 12)),
        const Text('Old Tax Regime', style: TextStyle(fontSize: 12)),
        const Text('₹1,20,00,000', style: TextStyle(fontSize: 12)),
        const Text('0', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Active', Colors.green),
      ],
      [
        const Text('Stark Industries', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('pepper@stark.com', style: TextStyle(fontSize: 12)),
        const Text('New Tax Regime', style: TextStyle(fontSize: 12)),
        const Text('₹95,00,000', style: TextStyle(fontSize: 12)),
        const Text('1', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.amber)),
        _buildStatusBadge('Awaiting Upload', Colors.amber),
      ],
    ];

    final headerRow = _buildAdvisoryTableHeader(
      searchHint: 'Search taxpayers by name or email...',
      btnLabel: 'Add Taxpayer Client',
      onBtnTap: () {
        showDialog(
          context: context,
          builder: (context) => const RegisterClientDialog(),
        );
      },
      isMobile: isMobile,
    );

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow,
          const SizedBox(height: 20),
          _buildAdvisoryTable(headers, rows, columnWidths),
        ],
      ),
    );
  }

  Widget _buildAdvisoryTableHeader({
    required String searchHint,
    required String btnLabel,
    required VoidCallback onBtnTap,
    required bool isMobile,
  }) {
    final searchWidget = Container(
      height: 44,
      constraints: const BoxConstraints(maxWidth: 400),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 12),
          const Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: searchHint,
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.secondaryText),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
        ],
      ),
    );

    final buttonWidget = ElevatedButton.icon(
      onPressed: onBtnTap,
      icon: const Icon(LucideIcons.plus, size: 14),
      label: Text(
        btnLabel,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20), // Dark green
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchWidget,
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: buttonWidget),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: searchWidget),
        buttonWidget,
      ],
    );
  }

  Widget _buildAdvisoryTable(List<String> headers, List<List<Widget>> rows, List<double> columnWidths) {
    final Map<int, TableColumnWidth> colWidthMap = {};
    double totalWidthScale = 0;
    for (var w in columnWidths) {
      totalWidthScale += w;
    }
    final double tableWidth = totalWidthScale * 100;

    for (int i = 0; i < columnWidths.length; i++) {
      colWidthMap[i] = FixedColumnWidth(columnWidths[i] * 100);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: tableWidth,
        child: Table(
          columnWidths: colWidthMap,
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            // Table Header
            TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border, width: 1.5)),
              ),
              children: headers.map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        h,
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondaryText,
                        ),
                      ),
                    ),
                    const Icon(LucideIcons.chevronDown, size: 8, color: AppColors.secondaryText),
                  ],
                ),
              )).toList(),
            ),
            // Table Body
            if (rows.isEmpty)
              TableRow(
                children: List.generate(headers.length, (idx) {
                  return const SizedBox(height: 0);
                }),
              )
            else
              ...rows.map((row) => TableRow(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.border, width: 1)),
                ),
                children: row.map((cell) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  child: cell,
                )).toList(),
              )),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildAdvisoryClientRequestsTab(bool isMobile) {
    final titleWidget = Row(
      children: [
        const Icon(LucideIcons.folderClosed, color: Colors.amber, size: 18),
        const SizedBox(width: 8),
        const Text(
          'Outbound Document Requests Ledger',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
      ],
    );

    final buttonWidget = ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const RequestDocumentDialog(),
        );
      },
      icon: const Icon(LucideIcons.plus, size: 14),
      label: const Text(
        'Create Document Requisition',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20), // Dark green
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    final headerRow = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: buttonWidget),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleWidget),
              buttonWidget,
            ],
          );

    final simulatorCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(LucideIcons.playCircle, color: Colors.indigo, size: 16),
              const SizedBox(width: 8),
              const Text(
                'Client Collaboration Simulator',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(
              'Select a request from the ledger to simulate taxpayer file uploads and audits.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );

    final tableHeaders = ['REQUEST ID', 'TAXPAYER', 'DOCUMENT TYPE', 'STATUS'];
    final colWidths = [1.2, 1.8, 2.2, 1.2];
    final tableRows = [
      [
        const Text('REQ-001', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const Text('Acme Corp', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('GST Annexure A', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Pending', Colors.amber),
      ],
      [
        const Text('REQ-002', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const Text('Wayne Enterprises', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('FY25 Form 16', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Fulfilled', Colors.green),
      ],
    ];

    final leftPanel = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: _buildAdvisoryTable(tableHeaders, tableRows, colWidths),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headerRow,
        const SizedBox(height: 24),
        if (isMobile)
          Column(
            children: [
              leftPanel,
              const SizedBox(height: 24),
              simulatorCard,
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: leftPanel),
              const SizedBox(width: 24),
              Expanded(flex: 2, child: simulatorCard),
            ],
          ),
      ],
    );
  }

  Widget _buildAdvisoryTasksTab(bool isMobile) {
    final titleWidget = Row(
      children: [
        const Icon(LucideIcons.checkSquare, color: Colors.green, size: 18),
        const SizedBox(width: 8),
        const Text(
          'Operational Compliance checklist',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
      ],
    );

    final buttonWidget = ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const AssignTaskDialog(),
        );
      },
      icon: const Icon(LucideIcons.plus, size: 14),
      label: const Text(
        'New Operations Task',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20), // Dark green
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    final headerRow = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: buttonWidget),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleWidget),
              buttonWidget,
            ],
          );

    final headers = [
      'TASK DESCRIPTION',
      'TAXPAYER CLIENT',
      'DUE DATE',
      'PRIORITY',
      'FILING LIFECYCLE STATUS',
    ];
    final colWidths = [2.2, 1.8, 1.4, 1.2, 1.8];
    final rows = [
      [
        const Text('Q2 GST Filing Reconciliation', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('Acme Corp', style: TextStyle(fontSize: 12)),
        const Text('2026-07-31', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('High', Colors.red),
        _buildStatusBadge('In Progress', Colors.blue),
      ],
      [
        const Text('Annual Balance Sheet Upload', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('Wayne Enterprises', style: TextStyle(fontSize: 12)),
        const Text('2026-08-15', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Critical', const Color(0xFFB71C1C)),
        _buildStatusBadge('Awaiting Docs', Colors.amber),
      ],
      [
        const Text('TDS Return E-filing', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('Stark Industries', style: TextStyle(fontSize: 12)),
        const Text('2026-07-25', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Medium', Colors.orange),
        _buildStatusBadge('Filing Ready', Colors.green),
      ],
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow,
          const SizedBox(height: 20),
          _buildAdvisoryTable(headers, rows, colWidths),
        ],
      ),
    );
  }

  Widget _buildAdvisoryTeamsTab(bool isMobile) {
    final titleWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.users, color: Colors.purple, size: 18),
            const SizedBox(width: 8),
            const Text(
              'Practice Team Members',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Manage roles, access control, and staff associations inside your advisory firm.',
          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );

    final buttonWidget = ElevatedButton.icon(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => const InviteTeamDialog(),
        );
      },
      icon: const Icon(LucideIcons.plus, size: 14),
      label: const Text(
        'Add Team Member',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20), // Dark green
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    final headerRow = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: buttonWidget),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleWidget),
              buttonWidget,
            ],
          );

    final headers = [
      'TEAM MEMBER',
      'EMAIL ADDRESS',
      'DESIGNATION / ROLE',
      'STATUS',
      'ACTIONS',
    ];
    final colWidths = [1.8, 2.2, 1.8, 1.2, 1.2];
    final rows = [
      [
        const Text('Rahul Dev', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('rahul@finpro.com', style: TextStyle(fontSize: 12)),
        const Text('Lead Auditor', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Active', Colors.green),
        _buildActionText('Manage', Colors.blue, () {}),
      ],
      [
        const Text('Sarah Connor', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('sarah@finpro.com', style: TextStyle(fontSize: 12)),
        const Text('Tax Consultant', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('Active', Colors.green),
        _buildActionText('Manage', Colors.blue, () {}),
      ],
      [
        const Text('John Doe', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const Text('john@finpro.com', style: TextStyle(fontSize: 12)),
        const Text('Articled Assistant', style: TextStyle(fontSize: 12)),
        _buildStatusBadge('On Leave', Colors.grey),
        _buildActionText('Manage', Colors.blue, () {}),
      ],
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow,
          const SizedBox(height: 20),
          _buildAdvisoryTable(headers, rows, colWidths),
        ],
      ),
    );
  }

  Widget _buildActionText(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildAdvisoryTimeTrackingTab(bool isMobile) {
    final leftCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.clock, color: Colors.purple, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Live Ticking Stopwatch Widget',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildLabel('Select Client'),
          _buildDropdown(['-- Select Taxpayer --', 'Acme Corp', 'Wayne Enterprises'], '-- Select Taxpayer --', (v) {}),
          const SizedBox(height: 16),
          _buildLabel('Task Description'),
          _buildTextField(TextEditingController(), 'Audit draft calculation, GSTR preparation...'),
          const SizedBox(height: 24),
          
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(
              child: Column(
                children: [
                  Text(
                    '00:00:00',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  SizedBox(height: 6),
                  Text(
                    '• TIMER PAUSED',
                    style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(LucideIcons.play, size: 14),
                  label: const Text('Start Timer', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Reset', style: TextStyle(fontSize: 12, color: AppColors.darkText)),
              ),
            ],
          ),
        ],
      ),
    );

    final tableHeaders = ['CLIENT', 'TASK DESCRIPTION', 'DATE', 'DURATION', 'BILLABLE'];
    final colWidths = [1.5, 2.2, 1.4, 1.2, 1.2];
    
    final rightCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.calendar, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Practice Timesheet Sessions History',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAdvisoryTable(tableHeaders, [], colWidths),
          const SizedBox(height: 32),
          Center(
            child: Text(
              'No timesheet sessions logged yet.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          leftCard,
          const SizedBox(height: 24),
          rightCard,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: leftCard),
        const SizedBox(width: 24),
        Expanded(flex: 3, child: rightCard),
      ],
    );
  }

  Widget _buildAdvisoryDocumentsTab(bool isMobile) {
    final leftCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.folder, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Practice Folder Tree',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(LucideIcons.folderClosed, color: Color(0xFF2E7D32), size: 14),
                    SizedBox(width: 8),
                    Text('All Folders', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
                  ],
                ),
                Text('0 files', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );

    final uploadCard = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.folderClosed, color: Colors.amber, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Upload Practice Document from Laptop',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE3F2FD),
                  foregroundColor: const Color(0xFF1565C0),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: Color(0xFF90CAF9))),
                  elevation: 0,
                ),
                child: const Text('+ Choose File', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              const Text('No file selected', style: TextStyle(fontSize: 11, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildTextField(TextEditingController(), 'Document Name (e.g. pan_card_draft_2026.pdf)...'),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildDropdown(['All Folders'], 'All Folders', (v) {}),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(LucideIcons.uploadCloud, size: 14),
              label: const Text('Upload to Practice Vault', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB0BEC5), // Greyed out
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );

    final explorerCard = Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.fileText, color: Colors.blue, size: 18),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'File Vault Explorer: All Secure Documents',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildAdvisoryTable(['FILE NAME', 'SIZE', 'FOLDER', 'DATE ADDED', 'ACTIONS'], [], [2.2, 1.2, 1.5, 1.6, 1.2]),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          leftCard,
          const SizedBox(height: 24),
          uploadCard,
          explorerCard,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: leftCard),
        const SizedBox(width: 24),
        Expanded(
          flex: 3,
          child: Column(
            children: [
              uploadCard,
              explorerCard,
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdvisoryWorkpaperTab(bool isMobile) {
    final titleRow = Row(
      children: [
        const Icon(LucideIcons.checkSquare, color: Colors.blue, size: 18),
        const SizedBox(width: 8),
        const Text(
          'Workpaper — Select a Client',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
      ],
    );

    final headers = ['Client Name', 'Email', 'Status', 'Checklist Progress', 'Action'];
    final colWidths = [2.0, 2.2, 1.5, 1.8, 1.2];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleRow,
          const SizedBox(height: 6),
          const Text(
            'Click on a client to view and manage their audit checklist.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 24),
          _buildAdvisoryTable(headers, [], colWidths),
          const SizedBox(height: 36),
          Center(
            child: Text(
              'No clients found. Add clients first in the Clients tab.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisoryTeamRequestsTab(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.mail, color: Colors.pink, size: 18),
              const SizedBox(width: 8),
              const Text(
                'Team Invitations & Requests',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Approve incoming join requests or track pending outgoing invitations sent to other advisors.',
            style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
          ),
          const SizedBox(height: 36),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 48),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.userCheck, color: Color(0xFF2E7D32), size: 24),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Pending Requests',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'All team invitations and member requests have been fully processed.',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisoryReportsTab(bool isMobile) {
    final titleWidget = Row(
      children: [
        const Icon(LucideIcons.barChart, color: Colors.teal, size: 18),
        const SizedBox(width: 8),
        const Text(
          'Filing Compliance & Master Sheets',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
      ],
    );

    final buttonWidget = ElevatedButton.icon(
      onPressed: () {},
      icon: const Icon(LucideIcons.checkSquare, size: 14),
      label: const Text(
        'Compile Master Audit Sheet',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF1B5E20), // Dark green
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
    );

    final headerRow = isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              titleWidget,
              const SizedBox(height: 12),
              SizedBox(width: double.infinity, child: buttonWidget),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: titleWidget),
              buttonWidget,
            ],
          );

    final headers = ['CLIENT TAXPAYER', 'FILING FORM TYPE', 'ASSESSMENT YEAR', 'FILING SEASON STATUS', 'EXEMPTION STATUS'];
    final colWidths = [2.0, 1.8, 1.5, 1.8, 1.5];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          headerRow,
          const SizedBox(height: 24),
          _buildAdvisoryTable(headers, [], colWidths),
          const SizedBox(height: 36),
          Center(
            child: Text(
              'No practice clients registered in workspace database.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvisoryFallbackTab(String tabName) {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Icon(LucideIcons.folderOpen, color: AppColors.secondaryText, size: 36),
          const SizedBox(height: 16),
          Text(
            '$tabName Ledger',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText),
          ),
          const SizedBox(height: 8),
          Text(
            'No records found in this category. Connect client portals or add members to sync workspace records.',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 9, 
          fontWeight: FontWeight.bold, 
          color: Colors.grey.shade600, 
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildDropdown(List<String> items, String value, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(LucideIcons.chevronDown, size: 16),
          items: items.map((i) => DropdownMenuItem(value: i, child: Text(i, style: const TextStyle(fontSize: 13)))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 13),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
