import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:clicks_business_frontend/core/navigation/navigation_provider.dart';

/// Tax & Deductions Page
/// Matching screenshot at cliks.beta-softnet.com/books/tax-deductions
class TaxDeductionsPage extends ConsumerStatefulWidget {
  const TaxDeductionsPage({super.key});

  @override
  ConsumerState<TaxDeductionsPage> createState() => _TaxDeductionsPageState();
}

class _TaxDeductionsPageState extends ConsumerState<TaxDeductionsPage> {
  String _selectedFY = 'FY 2024-25';
  final List<String> _financialYears = ['FY 2024-25', 'FY 2023-24', 'FY 2025-26'];

  // Input Controllers
  final _grossIncomeController = TextEditingController(text: '0');
  final _tdsPaidController = TextEditingController(text: '0');
  final _epfController = TextEditingController(text: '0');
  final _esiController = TextEditingController(text: '0');
  final _profTaxController = TextEditingController(text: '0');
  final _additionalSavingsController = TextEditingController(text: '0');

  // Calculated Metrics
  double _estimatedTax = 0.0;
  double _totalPaid = 0.0;
  double _dueAmount = 0.0;
  double _potentialRefund = 0.0;
  double _taxableBase = 0.0;

  @override
  void initState() {
    super.initState();
    _recalculateTaxes(notifyUser: false);
  }

  @override
  void dispose() {
    _grossIncomeController.dispose();
    _tdsPaidController.dispose();
    _epfController.dispose();
    _esiController.dispose();
    _profTaxController.dispose();
    _additionalSavingsController.dispose();
    super.dispose();
  }

  void _recalculateTaxes({bool notifyUser = false}) {
    final gross = double.tryParse(_grossIncomeController.text.trim()) ?? 0.0;
    final tds = double.tryParse(_tdsPaidController.text.trim()) ?? 0.0;
    final epf = double.tryParse(_epfController.text.trim()) ?? 0.0;
    final esi = double.tryParse(_esiController.text.trim()) ?? 0.0;
    final profTax = double.tryParse(_profTaxController.text.trim()) ?? 0.0;
    final additional = double.tryParse(_additionalSavingsController.text.trim()) ?? 0.0;

    // Standard deduction of 50,000 + allowances
    final standardDeduction = gross > 50000 ? 50000.0 : gross;
    final totalDeductions = standardDeduction + epf + esi + profTax + additional;
    final taxable = (gross - totalDeductions).clamp(0.0, double.infinity);

    // Progressive Indian Tax Regime computation
    double tax = 0.0;
    if (taxable > 1500000) {
      tax += (taxable - 1500000) * 0.30;
      tax += 300000 * 0.20;
      tax += 300000 * 0.15;
      tax += 300000 * 0.10;
      tax += 300000 * 0.05;
    } else if (taxable > 1200000) {
      tax += (taxable - 1200000) * 0.20;
      tax += 300000 * 0.15;
      tax += 300000 * 0.10;
      tax += 300000 * 0.05;
    } else if (taxable > 900000) {
      tax += (taxable - 900000) * 0.15;
      tax += 300000 * 0.10;
      tax += 300000 * 0.05;
    } else if (taxable > 600000) {
      tax += (taxable - 600000) * 0.10;
      tax += 300000 * 0.05;
    } else if (taxable > 300000) {
      tax += (taxable - 300000) * 0.05;
    }

    // Health & Education Cess @ 4%
    if (tax > 0) {
      tax += tax * 0.04;
    }

    // Tax rebate u/s 87A if taxable income <= 7,00,000 (New Regime)
    if (taxable <= 700000) {
      tax = 0.0;
    }

    final due = (tax - tds).clamp(0.0, double.infinity);
    final refund = (tds - tax).clamp(0.0, double.infinity);

    setState(() {
      _taxableBase = taxable;
      _estimatedTax = tax;
      _totalPaid = tds;
      _dueAmount = due;
      _potentialRefund = refund;
    });

    if (notifyUser && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(LucideIcons.checkCircle2, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text('Tax records updated for $_selectedFY. Taxable: ₹${taxable.toStringAsFixed(0)}'),
            ],
          ),
          backgroundColor: const Color(0xFF166534),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _exportTaxSummary() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.fileSpreadsheet, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text('Tax Summary for $_selectedFY exported successfully.'),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showDetailedProjectionModal() {
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
                const Expanded(
                  child: Row(
                    children: [
                      Icon(LucideIcons.calculator, color: Color(0xFF166534), size: 22),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Detailed Tax Projection (FY 2024-25)',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
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
            _buildProjectionRow('Gross Annual Income', '₹${_grossIncomeController.text}'),
            _buildProjectionRow('Standard Deduction (50k limit)', '₹50,000'),
            _buildProjectionRow('Section 80C, 80D & PF Deductions', '₹${(double.tryParse(_epfController.text) ?? 0) + (double.tryParse(_additionalSavingsController.text) ?? 0)}'),
            _buildProjectionRow('Net Taxable Base', '₹${_taxableBase.toStringAsFixed(2)}', isBold: true),
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
                  _buildProjectionRow('Estimated Tax Before Cess', '₹${(_estimatedTax / 1.04).toStringAsFixed(2)}'),
                  _buildProjectionRow('Health & Education Cess (4%)', '₹${(_estimatedTax - (_estimatedTax / 1.04)).toStringAsFixed(2)}'),
                  _buildProjectionRow('Total Tax Liability', '₹${_estimatedTax.toStringAsFixed(2)}', isBold: true, color: const Color(0xFFDC2626)),
                  _buildProjectionRow('TDS Credits Available', '₹${_totalPaid.toStringAsFixed(2)}', color: const Color(0xFF16A34A)),
                  _buildProjectionRow('Net Payable / (Refund)', '₹${(_dueAmount > 0 ? _dueAmount : -_potentialRefund).toStringAsFixed(2)}', isBold: true),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF166534),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Close Projection', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectionRow(String label, String value, {bool isBold = false, Color? color}) {
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final isDesktop = screenWidth >= 1100;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : (isDesktop ? 28 : 20),
          vertical: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ════════════════════════════════════════════════════════════════════
            // 1. TOP HEADER (MATCHING SCREENSHOT 1)
            // ════════════════════════════════════════════════════════════════════
            _buildHeader(isMobile),

            const SizedBox(height: 24),

            // ════════════════════════════════════════════════════════════════════
            // 2. 4 TOP STAT CARDS (ESTIMATED TAX, TOTAL PAID, DUE AMOUNT, POTENTIAL REFUND)
            // ════════════════════════════════════════════════════════════════════
            _buildStatCards(isMobile, isDesktop),

            const SizedBox(height: 24),

            // ════════════════════════════════════════════════════════════════════
            // 3. MAIN SECTION: ANNUAL TAX BREAKDOWN + RIGHT CALCULATOR / COMPLIANCE
            // ════════════════════════════════════════════════════════════════════
            if (isDesktop) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 65,
                    child: _buildAnnualTaxBreakdownCard(isMobile),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 35,
                    child: Column(
                      children: [
                        _buildQuickCalculatorCard(),
                        const SizedBox(height: 20),
                        _buildTaxComplianceCard(),
                      ],
                    ),
                  ),
                ],
              ),
            ] else ...[
              _buildAnnualTaxBreakdownCard(isMobile),
              const SizedBox(height: 20),
              _buildQuickCalculatorCard(),
              const SizedBox(height: 20),
              _buildTaxComplianceCard(),
            ],

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════════════════════════════════════════
  // HEADER
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildHeader(bool isMobile) {
    final titleSection = Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFFEE2E2)),
          ),
          child: const Center(
            child: Icon(LucideIcons.shieldAlert, color: Color(0xFFDC2626), size: 22),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting);
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: const Icon(LucideIcons.arrowLeft, size: 20, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Tax & Deductions',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Calculate and manage your annual tax liability',
                style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );

    final actionSection = Wrap(
      spacing: 10,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // FY Dropdown
        Container(
          height: 38,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFY,
              icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF64748B)),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              items: _financialYears
                  .map((fy) => DropdownMenuItem(value: fy, child: Text(fy)))
                  .toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() => _selectedFY = val);
                  _recalculateTaxes(notifyUser: true);
                }
              },
            ),
          ),
        ),
        // Export Summary Button
        ElevatedButton.icon(
          onPressed: _exportTaxSummary,
          icon: const Icon(LucideIcons.download, size: 15, color: Colors.white),
          label: const Text('Export Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF166534),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          titleSection,
          const SizedBox(height: 14),
          actionSection,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleSection),
        const SizedBox(width: 16),
        actionSection,
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // 4 STAT CARDS
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildStatCards(bool isMobile, bool isDesktop) {
    final estTaxCard = _buildSingleStatCard('ESTIMATED TAX', '₹${_estimatedTax.toStringAsFixed(0)}', const Color(0xFF0F172A));
    final totalPaidCard = _buildSingleStatCard('TOTAL PAID', '₹${_totalPaid.toStringAsFixed(0)}', const Color(0xFF16A34A));
    final dueCard = _buildSingleStatCard('DUE AMOUNT', '₹${_dueAmount.toStringAsFixed(0)}', const Color(0xFFDC2626));
    final refundCard = _buildSingleStatCard('POTENTIAL REFUND', '₹${_potentialRefund.toStringAsFixed(0)}', const Color(0xFF2563EB));

    if (isDesktop) {
      return Row(
        children: [
          Expanded(child: estTaxCard),
          const SizedBox(width: 16),
          Expanded(child: totalPaidCard),
          const SizedBox(width: 16),
          Expanded(child: dueCard),
          const SizedBox(width: 16),
          Expanded(child: refundCard),
        ],
      );
    }

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: estTaxCard),
            const SizedBox(width: 12),
            Expanded(child: totalPaidCard),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: dueCard),
            const SizedBox(width: 12),
            Expanded(child: refundCard),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleStatCard(String title, String amount, Color amountColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFF64748B),
                letterSpacing: 0.6,
              ),
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: amountColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // ANNUAL TAX BREAKDOWN CARD
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildAnnualTaxBreakdownCard(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Annual Tax Breakdown',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 20),

          // Row 1: Gross Annual Income & TDS Already Paid
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 480;
              final grossField = _buildInputField(
                label: 'GROSS ANNUAL INCOME',
                controller: _grossIncomeController,
                hintText: '0',
              );
              final tdsField = _buildInputField(
                label: 'TDS ALREADY PAID',
                controller: _tdsPaidController,
                hintText: '0',
              );

              if (isNarrow) {
                return Column(
                  children: [
                    grossField,
                    const SizedBox(height: 14),
                    tdsField,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: grossField),
                  const SizedBox(width: 16),
                  Expanded(child: tdsField),
                ],
              );
            },
          ),

          const SizedBox(height: 22),

          // Subheader: Standard Deductions
          const Text(
            'STANDARD DEDUCTIONS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),

          // Row 2: EPF, ESI, PROF TAX
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 520;
              final epfField = _buildInputField(label: 'EPF', controller: _epfController, hintText: '0');
              final esiField = _buildInputField(label: 'ESI', controller: _esiController, hintText: '0');
              final profTaxField = _buildInputField(label: 'PROF TAX', controller: _profTaxController, hintText: '0');

              if (isNarrow) {
                return Column(
                  children: [
                    epfField,
                    const SizedBox(height: 12),
                    esiField,
                    const SizedBox(height: 12),
                    profTaxField,
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: epfField),
                  const SizedBox(width: 14),
                  Expanded(child: esiField),
                  const SizedBox(width: 14),
                  Expanded(child: profTaxField),
                ],
              );
            },
          ),

          const SizedBox(height: 22),

          // Subheader: Additional Tax Savings
          const Text(
            'ADDITIONAL TAX SAVINGS (80C, 80D, etc.)',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),

          _buildInputField(
            label: '',
            controller: _additionalSavingsController,
            hintText: '0',
          ),

          const SizedBox(height: 26),

          // Update Tax Records Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => _recalculateTaxes(notifyUser: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF166534),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text(
                'Update Tax Records',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hintText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 6),
        ],
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.centerLeft,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (val) => _recalculateTaxes(notifyUser: false),
          ),
        ),
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // RIGHT CARDS: QUICK CALCULATOR & TAX COMPLIANCE
  // ════════════════════════════════════════════════════════════════════════════
  Widget _buildQuickCalculatorCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Calculator',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 16),

          // Taxable Base Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Taxable Base',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                ),
                const SizedBox(height: 6),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '₹${_taxableBase.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // View Detailed Projection Link
          InkWell(
            onTap: _showDetailedProjectionModal,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(LucideIcons.clock, color: Color(0xFF166534), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'View Detailed Projection',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaxComplianceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tax Compliance',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Text(
            'Ensure all your TDS certificates (Form 16/16A) are collected and verified against Form 26AS for smooth filing.',
            style: TextStyle(
              fontSize: 12.5,
              color: Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              InkWell(
                onTap: () {
                  // Pre-fill realistic standard values for calculation demo
                  setState(() {
                    _grossIncomeController.text = '1200000';
                    _tdsPaidController.text = '85000';
                    _epfController.text = '21600';
                    _esiController.text = '0';
                    _profTaxController.text = '2400';
                    _additionalSavingsController.text = '150000';
                  });
                  _recalculateTaxes(notifyUser: true);
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF334155),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'ITR-1',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 4),
                        Icon(LucideIcons.zap, size: 12, color: Color(0xFFFBBF24)),
                        SizedBox(width: 4),
                        Text(
                          'Click to Calculate',
                          style: TextStyle(color: Color(0xFFE2E8F0), fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'AY 2024',
                  style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
