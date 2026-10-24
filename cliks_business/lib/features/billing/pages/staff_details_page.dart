import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

/// Staff Details Page
/// Matching screenshots at cliks.beta-softnet.com/books/finance/staff-details
class StaffDetailsPage extends ConsumerStatefulWidget {
  const StaffDetailsPage({super.key});

  @override
  ConsumerState<StaffDetailsPage> createState() => _StaffDetailsPageState();
}

class _StaffDetailsPageState extends ConsumerState<StaffDetailsPage> {
  // Invitation State (starts as false to match Screenshots 1 & 2, toggles on Accept/Reset)
  bool _isAccepted = false;
  bool _showSuccessBanner = false;

  void _acceptInvitation() {
    setState(() {
      _isAccepted = true;
      _showSuccessBanner = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(LucideIcons.checkCircle2, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text('Invitation accepted! Salary details for ramaniteam123@bnxmail.com are now live.'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF166534),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _rejectInvitation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(LucideIcons.alertTriangle, color: Color(0xFFDC2626), size: 22),
            SizedBox(width: 10),
            Text('Decline HR Linkage?', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to decline the incoming workforce integration from Welton Consignor? You can re-request this from your HR team.',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF64748B))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Invitation was dismissed.'),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Decline Invitation'),
          ),
        ],
      ),
    );
  }

  void _resetStatus() {
    setState(() {
      _isAccepted = false;
      _showSuccessBanner = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reset invitation status to Pending for demonstration.'),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showPayslipModal(String month, String creditDate, String amount) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(LucideIcons.fileText, color: Color(0xFF166534), size: 22),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$month ($creditDate)',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(LucideIcons.x, size: 20),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildPayslipBreakdownRow('Employee Name', 'vincent ffjd'),
            _buildPayslipBreakdownRow('Employee Code', 'CLK-0040'),
            _buildPayslipBreakdownRow('Designation', 'Sales Executive - Operations'),
            _buildPayslipBreakdownRow('Employer', 'Welton Consignor (Cliks Business)'),
            _buildPayslipBreakdownRow('Disbursement Account', 'HDFC Bank •••• 5678'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildPayslipBreakdownRow('Basic Salary', '₹17,500.00'),
                  _buildPayslipBreakdownRow('House Rent Allowance (HRA)', '₹5,000.00'),
                  _buildPayslipBreakdownRow('Special Allowance', '₹2,500.00'),
                  const Divider(height: 16),
                  _buildPayslipBreakdownRow('Gross Earnings', '₹25,000.00', isBold: true),
                  _buildPayslipBreakdownRow('EPF / PF Deduction', '₹0.00'),
                  _buildPayslipBreakdownRow('Professional Tax (PT)', '₹0.00'),
                  const Divider(height: 16),
                  _buildPayslipBreakdownRow('Net Disbursed Amount', amount, isBold: true, color: const Color(0xFF166534)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading PDF for $month...'), backgroundColor: const Color(0xFF166534)),
                      );
                    },
                    icon: const Icon(LucideIcons.download, size: 16),
                    label: const Text('Download PDF'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening printable payslip for $month...'), backgroundColor: const Color(0xFF0F172A)),
                      );
                    },
                    icon: const Icon(LucideIcons.printer, size: 16),
                    label: const Text('Print Payslip'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF166534),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayslipBreakdownRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: const Color(0xFF64748B),
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: color ?? const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 950;
        final isMobile = constraints.maxWidth < 650;

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 28,
              vertical: isMobile ? 18 : 26,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. PAGE HEADER
                _buildHeader(isMobile),

                const SizedBox(height: 18),

                // 2. SUCCESS BANNER (SHOWN WHEN ACCEPTED)
                if (_showSuccessBanner) ...[
                  _buildSuccessBanner(),
                  const SizedBox(height: 20),
                ],

                // 3. ACTIVE INTEGRATIONS CARD
                _buildActiveIntegrationsCard(isMobile),

                const SizedBox(height: 24),

                // 4. YOUR SALARY HISTORY & DETAILS SECTION (LOCKED OR UNLOCKED)
                _buildSalaryHistorySection(isMobile, isDesktop),

                SizedBox(height: isMobile ? 110 : 40),
              ],
            ),
          ),
        );
      },
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 1. PAGE HEADER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(bool isMobile) {
    final titleSection = Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFDBEAFE)),
          ),
          child: const Center(
            child: Icon(LucideIcons.user, color: Color(0xFF2563EB), size: 22),
          ),
        ),
        const SizedBox(width: 14),
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
                    'Staff Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                      letterSpacing: -0.5,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _isAccepted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _isAccepted ? const Color(0xFFBBF7D0) : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _isAccepted ? 'INTEGRATION ACTIVE' : 'PENDING INVITATION',
                        style: TextStyle(
                          color: _isAccepted ? const Color(0xFF166534) : const Color(0xFFB45309),
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Workforce integrations, organization linkage & salary structure.',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    final loggedInBadge = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: const FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(LucideIcons.mail, size: 15, color: Color(0xFF64748B)),
            SizedBox(width: 8),
            Text(
              'Logged-in: ',
              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
            ),
            Text(
              'ramaniteam123@bnxmail.com',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
          ],
        ),
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleSection,
          const SizedBox(height: 12),
          loggedInBadge,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleSection),
        const SizedBox(width: 16),
        loggedInBadge,
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 2. SUCCESS BANNER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildSuccessBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 18),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Invitation accepted! Salary details for ramaniteam123@bnxmail.com are now live.',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF166534)),
            ),
          ),
          InkWell(
            onTap: () => setState(() => _showSuccessBanner = false),
            borderRadius: BorderRadius.circular(4),
            child: const Icon(LucideIcons.x, size: 16, color: Color(0xFF166534)),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 3. ACTIVE INTEGRATIONS CARD
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildActiveIntegrationsCard(bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Icon(LucideIcons.building, color: Color(0xFF2563EB), size: 18),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Integrations',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Incoming organization & HR linkages',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  '1 Invite',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF475569)),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Inner Integration Box
          Container(
            padding: EdgeInsets.all(isMobile ? 14 : 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _isAccepted ? const Color(0xFFBBF7D0) : const Color(0xFFE2E8F0),
                width: _isAccepted ? 1.5 : 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.015),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Inviter info row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: const Color(0xFF14532D),
                      child: const Text(
                        'SH',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'santhoshhhhh(HR)',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBEAFE),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'Cliks Business',
                                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E40AF)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Organization: Welton Consignor',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _isAccepted ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isAccepted ? const Color(0xFF86EFAC) : const Color(0xFFFDE68A),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _isAccepted ? LucideIcons.check : LucideIcons.clock,
                            size: 12,
                            color: _isAccepted ? const Color(0xFF166534) : const Color(0xFFB45309),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _isAccepted ? 'Active' : 'Pending',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: _isAccepted ? const Color(0xFF166534) : const Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // Gray Info Box
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'You have been added to the organization payroll & HR roster for target email:',
                        style: TextStyle(fontSize: 12, color: Color(0xFF475569)),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFFBFDBFE)),
                        ),
                        child: const Text(
                          'ramaniteam123@bnxmail.com',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1D4ED8)),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Two columns: Position & Department
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('POSITION', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                          SizedBox(height: 2),
                          Text('Sales Executive', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('DEPARTMENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                          SizedBox(height: 2),
                          Text('Operations', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Action Buttons / Status Indicator
                if (!_isAccepted) ...[
                  if (isMobile) ...[
                    Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            onPressed: _acceptInvitation,
                            icon: const Icon(LucideIcons.check, size: 16),
                            label: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF166534),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: OutlinedButton.icon(
                            onPressed: _rejectInvitation,
                            icon: const Icon(LucideIcons.x, size: 16, color: Color(0xFFDC2626)),
                            label: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFDC2626))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: ElevatedButton.icon(
                              onPressed: _acceptInvitation,
                              icon: const Icon(LucideIcons.check, size: 16),
                              label: const Text('Accept', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF166534),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: SizedBox(
                            height: 44,
                            child: OutlinedButton.icon(
                              onPressed: _rejectInvitation,
                              icon: const Icon(LucideIcons.x, size: 16, color: Color(0xFFDC2626)),
                              label: const Text('Reject', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFFDC2626))),
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFFECACA), width: 1.2),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ] else ...[
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(LucideIcons.checkCircle2, color: Color(0xFF16A34A), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Integration active & verified',
                              style: TextStyle(color: Color(0xFF166534), fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: _resetStatus,
                        icon: const Icon(LucideIcons.refreshCw, size: 14, color: Color(0xFF64748B)),
                        label: const Text('Reset Status', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Security Card: Direct HR Sync Protection
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(LucideIcons.shieldCheck, color: Color(0xFF16A34A), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Direct HR Sync Protection',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Your salary slips, tax deductions, and EPF records are securely synced directly from Cliks Business. Sensitive bank records remain read-only for security.',
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 4. YOUR SALARY HISTORY & DETAILS SECTION
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildSalaryHistorySection(bool isMobile, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(isMobile ? 16 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          if (isMobile) ...[
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(LucideIcons.lock, color: Color(0xFFD97706), size: 18),
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'YOUR SALARY History & Details',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Official payroll structure, compensations & tax documents',
                        style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (_isAccepted) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF86EFAC)),
                ),
                child: const Text(
                  '✓ VERIFIED UNLOCKED',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                ),
              ),
            ],
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Icon(LucideIcons.lock, color: Color(0xFFD97706), size: 18),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'YOUR SALARY History & Details',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'Official payroll structure, compensations & tax documents',
                              style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isAccepted)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF86EFAC)),
                    ),
                    child: const Text(
                      '✓ VERIFIED UNLOCKED',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                    ),
                  ),
              ],
            ),
          ],

          const SizedBox(height: 20),

          // Render Locked vs Unlocked
          if (!_isAccepted)
            _buildLockedState(isMobile)
          else
            _buildUnlockedState(isMobile, isDesktop),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 4A. LOCKED STATE (MATCHING SCREENSHOT 2)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildLockedState(bool isMobile) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 580),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            // Big Gold/Amber Lock
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Center(
                child: Icon(LucideIcons.lock, size: 36, color: Color(0xFFD97706)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Employment & Salary Details Locked',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your compensation structure, bank disbursement account, PAN, and PF/UAN are protected. Accept the incoming invitation from santhoshhhhh(HR) to unlock and view your records.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Color(0xFF64748B), height: 1.4),
            ),
            const SizedBox(height: 22),

            // Masked records container
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                children: [
                  _buildMaskedRow('EMPLOYEE NAME', '••••••••••••'),
                  const Divider(height: 16),
                  _buildMaskedRow('BASIC MONTHLY SALARY', '₹ ••••••••'),
                  const Divider(height: 16),
                  _buildMaskedRow('DISBURSEMENT BANK', '••••••••••••'),
                  const Divider(height: 16),
                  _buildMaskedRow('PAN & PF INFO', '••••••••••'),
                  const Divider(height: 16),
                  _buildMaskedRow('ADDRESS & EMERGENCY', '••••••••••••'),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Accept button to unlock
            SizedBox(
              height: 46,
              child: ElevatedButton.icon(
                onPressed: _acceptInvitation,
                icon: const Icon(LucideIcons.lock, size: 16),
                label: const Text('Accept Invitation to Unlock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaskedRow(String label, String maskedVal) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
          ),
        ),
        Text(
          maskedVal,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 2.0),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 4B. UNLOCKED STATE (MATCHING SCREENSHOTS 4 & 5)
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildUnlockedState(bool isMobile, bool isDesktop) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Employee Profile Banner Card (Dark Navy Blue)
        _buildEmployeeBannerCard(isMobile),

        const SizedBox(height: 18),

        // 2. Basic Monthly Salary Bento Card
        _buildBasicMonthlySalaryCard(isMobile, isDesktop),

        const SizedBox(height: 18),

        // 3. Bank Disbursement Details Card
        _buildBankDisbursementCard(isMobile, isDesktop),

        const SizedBox(height: 18),

        // 4. PAN, PF & Compliance Records Card
        _buildComplianceRecordsCard(isMobile, isDesktop),

        const SizedBox(height: 18),

        // 5. Residential Address & Emergency Contacts Card
        _buildAddressEmergencyCard(isMobile, isDesktop),

        const SizedBox(height: 18),

        // 6. Disbursed Payslips Card (Screenshot 5)
        _buildDisbursedPayslipsCard(isMobile),
      ],
    );
  }

  // 1. Employee Banner Card (Dark Navy)
  Widget _buildEmployeeBannerCard(bool isMobile) {
    final infoSection = Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Center(
            child: Text(
              'VF',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Flexible(
                    child: Text(
                      'vincent ffjd',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(LucideIcons.checkCircle2, color: Color(0xFF22C55E), size: 16),
                ],
              ),
              const SizedBox(height: 3),
              const Text(
                'Operations • Sales Executive',
                style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              ),
              const SizedBox(height: 2),
              const Text(
                'Employee Code: CLK-0040 • Joining: 01 Mar 2026',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );

    final statusSection = Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        const Text(
          'EMPLOYMENT STATUS',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF064E3B),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF059669)),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.circle, color: Color(0xFF34D399), size: 8),
              SizedBox(width: 6),
              Text(
                'FULL TIME ACTIVE',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF34D399)),
              ),
            ],
          ),
        ),
      ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                infoSection,
                const SizedBox(height: 14),
                statusSection,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: infoSection),
                const SizedBox(width: 16),
                statusSection,
              ],
            ),
    );
  }

  // 2. Basic Monthly Salary Bento Card
  Widget _buildBasicMonthlySalaryCard(bool isMobile, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                    const Text(
                      'BASIC MONTHLY SALARY',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '₹25,000',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF166534)),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '/ month',
                            style: TextStyle(fontSize: 14, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('ANNUAL CTC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                    SizedBox(height: 2),
                    Text('₹3,00,000', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),
          const Divider(height: 1),
          const SizedBox(height: 18),

          // 4 Breakdown Metrics
          if (isMobile) ...[
            Wrap(
              spacing: 14,
              runSpacing: 14,
              children: [
                _buildSalaryMetricItem('BASIC PAY (70%)', '₹17,500'),
                _buildSalaryMetricItem('HRA (20%)', '₹5,000'),
                _buildSalaryMetricItem('SPECIAL ALLOWANCE', '₹2,500'),
                _buildSalaryMetricItem('EST. IN-HAND TAKEHOME', '₹23,500', isHighlight: true),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildSalaryMetricItem('BASIC PAY (70%)', '₹17,500')),
                Expanded(child: _buildSalaryMetricItem('HRA (20%)', '₹5,000')),
                Expanded(child: _buildSalaryMetricItem('SPECIAL ALLOWANCE', '₹2,500')),
                Expanded(child: _buildSalaryMetricItem('EST. IN-HAND TAKEHOME', '₹23,500', isHighlight: true)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSalaryMetricItem(String label, String value, {bool isHighlight = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isHighlight ? const Color(0xFF166534) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // 3. Bank Disbursement Details Card
  Widget _buildBankDisbursementCard(bool isMobile, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.creditCard, color: Color(0xFF2563EB), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'BANK DISBURSEMENT DETAILS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            Wrap(
              spacing: 16,
              runSpacing: 14,
              children: [
                _buildInfoColumn('BANK NAME', 'HDFC Bank'),
                _buildInfoColumn('ACCOUNT NUMBER', '•••• •••• 5678'),
                _buildInfoColumn('IFSC CODE', 'HDFC0001234'),
                _buildInfoColumn('DISBURSEMENT MODE', 'Auto Direct Credit (NEFT)', isGreen: true),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(child: _buildInfoColumn('BANK NAME', 'HDFC Bank')),
                Expanded(child: _buildInfoColumn('ACCOUNT NUMBER', '•••• •••• 5678')),
                Expanded(child: _buildInfoColumn('IFSC CODE', 'HDFC0001234')),
                Expanded(child: _buildInfoColumn('DISBURSEMENT MODE', 'Auto Direct Credit (NEFT)', isGreen: true)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 4. PAN, PF & Compliance Records Card
  Widget _buildComplianceRecordsCard(bool isMobile, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.shieldCheck, color: Color(0xFF16A34A), size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'PAN, PF & COMPLIANCE RECORDS',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            Wrap(
              spacing: 16,
              runSpacing: 14,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PAN NUMBER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('ABCDE1234F', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text('VERIFIED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildInfoColumn('PF / UAN NUMBER', '101234567890'),
                _buildInfoColumn('ESI ACCOUNT NUMBER', '31009876540001'),
              ],
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PAN NUMBER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Text('ABCDE1234F', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('VERIFIED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF166534))),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(child: _buildInfoColumn('PF / UAN NUMBER', '101234567890')),
                Expanded(child: _buildInfoColumn('ESI ACCOUNT NUMBER', '31009876540001')),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 5. Residential Address & Emergency Contacts Card
  Widget _buildAddressEmergencyCard(bool isMobile, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.mapPin, color: Color(0xFF2563EB), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'RESIDENTIAL ADDRESS & EMERGENCY CONTACTS',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HR SUBMITTED RECORD',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                  ),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.mapPin, color: Color(0xFF2563EB), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'RESIDENTIAL ADDRESS & EMERGENCY CONTACTS',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'HR SUBMITTED RECORD',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 16),
          if (isMobile) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoColumn('RESIDENTIAL ADDRESS', 'Plot No. 12, Anna Nagar, Chennai, Tamil Nadu (600040)'),
                const SizedBox(height: 12),
                _buildInfoColumn('EMERGENCY PERSON', 'Vijay Kumar (Father) - +91 98765 99911'),
                const SizedBox(height: 12),
                _buildInfoColumn('PERSONAL INFO', '2026-09-29 (Male) • Blood group: O+'),
                const SizedBox(height: 12),
                _buildInfoColumn('CONTACT INFO', '+91 98765 43210 • ramaniteam123@bnxmail.com'),
              ],
            ),
          ] else ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 30,
                  child: _buildInfoColumn('RESIDENTIAL ADDRESS', 'Plot No. 12, Anna Nagar, Chennai, Tamil Nadu (600040)'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 25,
                  child: _buildInfoColumn('EMERGENCY PERSON', 'Vijay Kumar (Father) - +91 98765 99911'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 22,
                  child: _buildInfoColumn('PERSONAL INFO', '2026-09-29 (Male) • Blood group: O+'),
                ),
                const SizedBox(width: 14),
                Expanded(
                  flex: 23,
                  child: _buildInfoColumn('CONTACT INFO', '+91 98765 43210 • ramaniteam123@bnxmail.com'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // 6. Disbursed Payslips Card (Screenshot 5)
  Widget _buildDisbursedPayslipsCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Row(
                  children: [
                    Icon(LucideIcons.fileText, color: Color(0xFF2563EB), size: 18),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'DISBURSED PAYSLIPS',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  'Generated by santhoshhhhh(HR)',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            )
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Row(
                  children: [
                    Icon(LucideIcons.fileText, color: Color(0xFF2563EB), size: 18),
                    SizedBox(width: 8),
                    Text(
                      'DISBURSED PAYSLIPS',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
                Text(
                  'Generated by santhoshhhhh(HR)',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // August 2026 Payslip
          _buildPayslipItem(
            'August 2026 Payslip',
            'Credited on 31 Aug 2026 • ₹25,000',
            'August 2026',
            '31 Aug 2026',
            '₹25,000',
          ),

          const SizedBox(height: 12),

          // July 2026 Payslip
          _buildPayslipItem(
            'July 2026 Payslip',
            'Credited on 31 Jul 2026 • ₹25,000',
            'July 2026',
            '31 Jul 2026',
            '₹25,000',
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipItem(String title, String subtitle, String month, String date, String amount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => _showPayslipModal(month, date, amount),
            icon: const Icon(LucideIcons.download, size: 14, color: Color(0xFF0F172A)),
            label: const Text('Slip', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFCBD5E1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value, {bool isGreen = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isGreen ? const Color(0xFF16A34A) : const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }
}
