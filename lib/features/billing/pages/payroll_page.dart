import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/navigation/navigation_provider.dart';
import '../../../core/theme/app_colors.dart';

class PayrollPage extends ConsumerStatefulWidget {
  const PayrollPage({super.key});

  @override
  ConsumerState<PayrollPage> createState() => _PayrollPageState();
}

class _PayrollPageState extends ConsumerState<PayrollPage> {
  int _activeTab = 0; // 0: Monthly Payroll Register, 1: Salary Structures, 2: Compliance, 3: Loans

  final List<String> _tabs = [
    'Monthly Payroll Register',
    'Salary Structures (CTC)',
    'Compliance (PF / ESI / PAN)',
    'Loans & Salary Advances',
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
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE289F2).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(LucideIcons.wallet, color: Color(0xFFD63384), size: 20),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Workforce Payroll Engine',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Text(
          'Manage monthly earnings structures, HRA allowances, EPF/ESI statutory compliance filings, TDS calculations, loans EMIs, and auto payouts.',
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
            ref.read(navigationProvider.notifier).setRoute(AppRoute.allocateEmployeeLoan);
          },
          icon: const Icon(LucideIcons.sliders, size: 14),
          label: const Text('Allocate Employee Loan', style: TextStyle(fontSize: 12)),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFFD63384),
            side: const BorderSide(color: Color(0xFFF8D7DA)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            backgroundColor: Colors.white,
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.processMonthlyPayroll);
          },
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('Process Monthly Payroll', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD63384),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
        title: '₹0',
        subtitle: 'MONTHLY SALARY EXPENSE',
        icon: LucideIcons.wallet,
        iconColor: const Color(0xFFD63384),
        bgColor: const Color(0xFFFDE8E8),
      ),
      _buildStatCard(
        title: '₹0 Filed',
        subtitle: 'COMPLIANCE PF / ESI',
        icon: LucideIcons.shieldCheck,
        iconColor: const Color(0xFF198754),
        bgColor: const Color(0xFFE6F4EA),
      ),
      _buildStatCard(
        title: '₹0',
        subtitle: 'OUTSTANDING LOANS',
        icon: LucideIcons.sliders,
        iconColor: const Color(0xFF0D6EFD),
        bgColor: const Color(0xFFE8F0FE),
      ),
      _buildStatCard(
        title: '0 Generated',
        subtitle: 'TOTAL PAYSLIPS',
        icon: LucideIcons.fileText,
        iconColor: const Color(0xFF8A2BE2),
        bgColor: const Color(0xFFF3E5F5),
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
              color: iconColor,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: bgColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, color: iconColor, size: 18),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade500,
                              letterSpacing: 0.5,
                            ),
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
      ),
    );
  }

  Widget _buildTabsBar(bool isMobile) {
    final List<IconData> tabIcons = [
      LucideIcons.fileText,
      LucideIcons.creditCard,
      LucideIcons.shieldCheck,
      LucideIcons.sliders,
    ];

    final List<Color> activeColors = [
      const Color(0xFFD63384), // Pink/Magenta
      const Color(0xFF0D6EFD), // Blue
      const Color(0xFF7C3AED), // Purple/Violet
      const Color(0xFF007A5E), // Teal/Green
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: List.generate(_tabs.length, (index) {
          final isSelected = _activeTab == index;
          final activeColor = activeColors[index];

          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _activeTab = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? activeColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected ? activeColor : AppColors.border,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      tabIcons[index],
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

  Widget _buildMainContent(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row inside the Content box based on selected tab
          _buildContentHeader(isMobile),
          const SizedBox(height: 20),

          // Table structure for selected tab
          _buildTabTable(isMobile),
        ],
      ),
    );
  }

  Widget _buildContentHeader(bool isMobile) {
    if (_activeTab == 0) {
      // Monthly Payroll Register search bar
      return Container(
        height: 44,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: const Row(
          children: [
            SizedBox(width: 12),
            Icon(LucideIcons.search, size: 16, color: AppColors.secondaryText),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search salary register...',
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
    } else if (_activeTab == 1) {
      return const Text(
        'Compensation Breakdown Structure (Annual CTC)',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF004D40), // Dark Green
        ),
      );
    } else if (_activeTab == 2) {
      return const Text(
        'Statutory EPF, ESI, PAN Compliance Identifiers',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF004D40),
        ),
      );
    } else {
      // Loans & Salary Advances: Title + Button
      final titleWidget = const Text(
        'Active Loans & Salary Advance Balances',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF004D40),
        ),
      );

      final buttonWidget = ElevatedButton.icon(
        onPressed: () {
          ref.read(navigationProvider.notifier).setRoute(AppRoute.allocateEmployeeLoan);
        },
        icon: const Icon(LucideIcons.plus, size: 14),
        label: const Text(
          'Grant Employee Loan',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF004D40), // Dark green
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
            titleWidget,
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: buttonWidget),
          ],
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: titleWidget),
          buttonWidget,
        ],
      );
    }
  }

  Widget _buildTabTable(bool isMobile) {
    // Determine headers and rows based on active tab
    List<String> headers = [];
    List<List<Widget>> rows = [];
    List<double> columnWidths = [];

    if (_activeTab == 0) {
      // Monthly Payroll Register
      headers = [
        'PAYSLIP REF',
        'EMPLOYEE',
        'BASE SALARY',
        'EARNINGS',
        'DEDUCTIONS',
        'NET TAKE HOME',
        'BANK ACCOUNT',
        'STATUS',
        'ACTIONS',
      ];
      columnWidths = [1.2, 1.6, 1.2, 1.2, 1.2, 1.4, 1.6, 1.0, 1.2];

      rows = [
        [
          const Text('PAY-2026-001', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const Text('Rahul Dev', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹85,000', style: TextStyle(fontSize: 12)),
          const Text('₹92,500', style: TextStyle(fontSize: 12, color: Colors.green)),
          const Text('₹10,500', style: TextStyle(fontSize: 12, color: Colors.red)),
          const Text('₹82,000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('HDFC ****1234', style: TextStyle(fontSize: 12)),
          _buildStatusBadge('Paid', Colors.green),
          _buildActionText('View Payslip', Colors.blue, () {}),
        ],
        [
          const Text('PAY-2026-002', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const Text('Michael Scott', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹1,20,000', style: TextStyle(fontSize: 12)),
          const Text('₹1,35,000', style: TextStyle(fontSize: 12, color: Colors.green)),
          const Text('₹15,000', style: TextStyle(fontSize: 12, color: Colors.red)),
          const Text('₹1,20,000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('ICICI ****5678', style: TextStyle(fontSize: 12)),
          _buildStatusBadge('Paid', Colors.green),
          _buildActionText('View Payslip', Colors.blue, () {}),
        ],
        [
          const Text('PAY-2026-003', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const Text('Jim Halpert', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹95,000', style: TextStyle(fontSize: 12)),
          const Text('₹1,02,000', style: TextStyle(fontSize: 12, color: Colors.green)),
          const Text('₹11,200', style: TextStyle(fontSize: 12, color: Colors.red)),
          const Text('₹90,800', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('SBI ****9012', style: TextStyle(fontSize: 12)),
          _buildStatusBadge('Pending', Colors.amber),
          _buildActionText('Process', Colors.purple, () {
            ref.read(navigationProvider.notifier).setRoute(AppRoute.processMonthlyPayroll);
          }),
        ],
      ];
    } else if (_activeTab == 1) {
      // Salary Structures (CTC)
      headers = [
        'EMPLOYEE NAME',
        'BASIC BASE SALARY',
        'HOUSE RENT ALLOWANCE (HRA)',
        'SPECIAL ALLOWANCES',
        'APPROX ANNUAL COST (CTC)',
      ];
      columnWidths = [1.8, 1.5, 2.0, 1.5, 1.8];
      rows = [
        [
          const Text('Rahul Dev', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹42,500', style: TextStyle(fontSize: 12)),
          const Text('₹21,250', style: TextStyle(fontSize: 12)),
          const Text('₹21,250', style: TextStyle(fontSize: 12)),
          const Text('₹10,20,000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
        [
          const Text('Michael Scott', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹60,000', style: TextStyle(fontSize: 12)),
          const Text('₹30,000', style: TextStyle(fontSize: 12)),
          const Text('₹30,000', style: TextStyle(fontSize: 12)),
          const Text('₹14,40,000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
        [
          const Text('Jim Halpert', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹47,500', style: TextStyle(fontSize: 12)),
          const Text('₹23,750', style: TextStyle(fontSize: 12)),
          const Text('₹23,750', style: TextStyle(fontSize: 12)),
          const Text('₹11,40,000', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ];
    } else if (_activeTab == 2) {
      // Compliance (PF / ESI / PAN)
      headers = [
        'EMPLOYEE NAME',
        'PAN NUMBER',
        'UNIVERSAL ACCOUNT NUMBER (UAN)',
        'ESI IDENTIFICATION NO',
        'MONTHLY EPF CONTRIBUTION',
      ];
      columnWidths = [1.8, 1.5, 2.2, 1.8, 1.8];
      rows = [
        [
          const Text('Rahul Dev', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('ABCDE1234F', style: TextStyle(fontSize: 12)),
          const Text('100123456789', style: TextStyle(fontSize: 12)),
          const Text('ESI-987654321', style: TextStyle(fontSize: 12)),
          const Text('₹1,800', style: TextStyle(fontSize: 12)),
        ],
        [
          const Text('Michael Scott', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('FGHIJ5678K', style: TextStyle(fontSize: 12)),
          const Text('100987654321', style: TextStyle(fontSize: 12)),
          const Text('ESI-123456789', style: TextStyle(fontSize: 12)),
          const Text('₹1,800', style: TextStyle(fontSize: 12)),
        ],
        [
          const Text('Jim Halpert', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('LMNOP9012Q', style: TextStyle(fontSize: 12)),
          const Text('100555666777', style: TextStyle(fontSize: 12)),
          const Text('ESI-555666777', style: TextStyle(fontSize: 12)),
          const Text('₹1,800', style: TextStyle(fontSize: 12)),
        ],
      ];
    } else {
      // Loans & Salary Advances
      headers = [
        'EMPLOYEE NAME',
        'GRANTED LOAN AMOUNT',
        'MONTHLY EMI DEDUCTION',
        'REMAINING LOAN BALANCE',
        'SALARY ADVANCE',
      ];
      columnWidths = [1.8, 1.5, 1.5, 1.5, 1.2];
      rows = [
        [
          const Text('Rahul Dev', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹50,000', style: TextStyle(fontSize: 12)),
          const Text('₹5,000', style: TextStyle(fontSize: 12)),
          const Text('₹35,000', style: TextStyle(fontSize: 12, color: Colors.blue)),
          const Text('₹10,000', style: TextStyle(fontSize: 12)),
        ],
        [
          const Text('Jim Halpert', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          const Text('₹30,000', style: TextStyle(fontSize: 12)),
          const Text('₹3,000', style: TextStyle(fontSize: 12)),
          const Text('₹18,000', style: TextStyle(fontSize: 12, color: Colors.blue)),
          const Text('₹0', style: TextStyle(fontSize: 12)),
        ],
      ];
    }

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
}
