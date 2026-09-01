import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/navigation/navigation_provider.dart';

class RecordExpenseModal extends ConsumerWidget {
  const RecordExpenseModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ModalWrapper(
      title: 'Record Business Expense',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel('Expense Category'),
          _buildDropdown(
            value: 'Rent',
            items: ['Rent', 'Utilities', 'Office Supplies', 'Marketing', 'Travel', 'Software / SaaS', 'Others'],
            onChanged: (val) {},
          ),
          const SizedBox(height: 16),
          _buildLabel('Subcategory / Spares description'),
          _buildTextField(hintText: 'Office space rent'),
          const SizedBox(height: 16),
          _buildLabel('Payee / Merchant Merchant Profile'),
          _buildTextField(hintText: 'e.g. Landmark Properties Ltd'),
          const SizedBox(height: 16),
          _buildResponsiveRow(
            context,
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Expense Amount (INR)'),
                  _buildTextField(hintText: 'Enter amount', keyboardType: TextInputType.number),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('GST % Percentage'),
                  _buildDropdown(
                    value: '0% Excluded',
                    items: ['0% Excluded', '5% GST', '12% GST', '18% GST', '28% GST'],
                    onChanged: (val) {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResponsiveRow(
            context,
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Payment Mode'),
                  _buildDropdown(
                    value: 'UPI',
                    items: ['UPI', 'Cash', 'Bank Transfer', 'Credit Card', 'Debit Card'],
                    onChanged: (val) {},
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Ref / UPI reference'),
                  _buildTextField(hintText: 'e.g. txn_9812401824'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettleButton(
            text: 'Settle & Post Expense',
            onPressed: () {
              ref.read(navigationProvider.notifier).setRoute(AppRoute.expenses);
            },
          ),
        ],
      ),
    );
  }
}

class LodgeStaffClaimModal extends ConsumerWidget {
  const LodgeStaffClaimModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ModalWrapper(
      title: 'Lodge Staff Claim',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel('Employee Profile Name'),
          _buildTextField(hintText: 'Karan Mehra (Inventory)'),
          const SizedBox(height: 16),
          _buildLabel('Travel / Out-of-pocket Description'),
          _buildTextField(hintText: 'Client Sample Box Dispatches'),
          const SizedBox(height: 16),
          _buildLabel('Claim Amount (INR)'),
          _buildTextField(hintText: 'Enter amount', keyboardType: TextInputType.number),
          const SizedBox(height: 24),
          _buildSettleButton(
            text: 'Lodge Reimbursement Claim',
            onPressed: () {
              ref.read(navigationProvider.notifier).setRoute(AppRoute.expenses);
            },
          ),
        ],
      ),
    );
  }
}

class GenerateEWayBillModal extends ConsumerWidget {
  const GenerateEWayBillModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ModalWrapper(
      title: 'Create Government e-Way Bill',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLabel('Transporter Company Name'),
          _buildTextField(hintText: 'Bluedart Cargo'),
          const SizedBox(height: 16),
          _buildResponsiveRow(
            context,
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Vehicle Number'),
                  _buildTextField(hintText: 'MH-02-EH-9081'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Distance (Kms)'),
                  _buildTextField(hintText: 'e.g. 350', keyboardType: TextInputType.number),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildResponsiveRow(
            context,
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Dispatch Location'),
                  _buildTextField(hintText: 'e.g. Warehouse A'),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Delivery Destination'),
                  _buildTextField(hintText: 'e.g. Client Office'),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettleButton(
            text: 'Settle Government e-Way Bill',
            onPressed: () {
              ref.read(navigationProvider.notifier).setRoute(AppRoute.gst);
            },
          ),
        ],
      ),
    );
  }
}

class GenerateEInvoiceModal extends ConsumerWidget {
  const GenerateEInvoiceModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ModalWrapper(
      title: 'Generate GST e-Invoice',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildResponsiveRow(
            context,
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Invoice Type'),
                  _buildDropdown(
                    value: 'B2B Tax Invoice',
                    items: ['B2B Tax Invoice', 'B2C Small', 'B2C Large', 'Export Tax Invoice', 'Credit Note', 'Debit Note'],
                    onChanged: (val) {},
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Place of supply'),
                  _buildDropdown(
                    value: '27-Maharashtra',
                    items: ['27-Maharashtra', '07-Delhi', '29-Karnataka', '33-Tamil Nadu', '09-Uttar Pradesh', '19-West Bengal'],
                    onChanged: (val) {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildLabel('Taxable Value (Before GST)'),
          _buildTextField(hintText: 'Enter amount', keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          _buildResponsiveRow(
            context,
            [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('GST % Percentage'),
                  _buildDropdown(
                    value: '18% GST',
                    items: ['5% GST', '12% GST', '18% GST', '28% GST'],
                    onChanged: (val) {},
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Reverse Charge'),
                  _buildDropdown(
                    value: 'No',
                    items: ['No', 'Yes'],
                    onChanged: (val) {},
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSettleButton(
            text: 'Settle e-Invoice Authentication',
            onPressed: () {
              ref.read(navigationProvider.notifier).setRoute(AppRoute.gst);
            },
          ),
        ],
      ),
    );
  }
}

class _ModalWrapper extends ConsumerWidget {
  final String title;
  final Widget child;

  const _ModalWrapper({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: isMobile ? double.infinity : 420,
          maxHeight: screenHeight * 0.65,
        ),
        margin: EdgeInsets.zero,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag Handle
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 8, bottom: 4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      final currentRoute = ref.read(navigationProvider).currentRoute;
                      if (currentRoute == AppRoute.recordExpense || currentRoute == AppRoute.lodgeStaffClaim) {
                        ref.read(navigationProvider.notifier).setRoute(AppRoute.expenses);
                      } else {
                        ref.read(navigationProvider.notifier).setRoute(AppRoute.gst);
                      }
                    },
                    icon: const Icon(LucideIcons.x, size: 18, color: Colors.black54),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(8),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildResponsiveRow(BuildContext context, List<Widget> children) {
  final isSmall = MediaQuery.of(context).size.width < 450;
  if (isSmall) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        children[0],
        const SizedBox(height: 16),
        children[1],
      ],
    );
  }
  return Row(
    children: [
      Expanded(child: children[0]),
      const SizedBox(width: 12),
      Expanded(child: children[1]),
    ],
  );
}

Widget _buildLabel(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 11.5,
        fontWeight: FontWeight.bold,
        color: Color(0xFF374151),
      ),
    ),
  );
}

class SecureAuditExportModal extends ConsumerStatefulWidget {
  const SecureAuditExportModal({super.key});

  @override
  ConsumerState<SecureAuditExportModal> createState() => _SecureAuditExportModalState();
}

class _SecureAuditExportModalState extends ConsumerState<SecureAuditExportModal> {
  int selectedFormat = 0; // 0: Tally/Excel, 1: Raw CSV

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 800,
            maxHeight: screenHeight * 0.65,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'Secure FIN-PRO Audit Export',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
                      icon: const Icon(LucideIcons.x, size: 18, color: AppColors.secondaryText),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16, color: AppColors.border),
              
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 0, isMobile ? 16 : 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFFFDE8E8), borderRadius: BorderRadius.circular(8)),
                            child: const Icon(LucideIcons.downloadCloud, color: Color(0xFFDC3545), size: 20),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(child: Text('Select your timeline and format options.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('SET DATE LIMITS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildDateField('FROM', '11-06-2026')),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDateField('TO', '11-07-2026')),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('SELECT FILE FORMAT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildFormatCard('Tally/Excel Doc', '.xlsx Spreadsheet', selectedFormat == 0, () => setState(() => selectedFormat = 0))),
                          const SizedBox(width: 12),
                          Expanded(child: _buildFormatCard('Raw Flat Data', '.csv File', selectedFormat == 1, () => setState(() => selectedFormat = 1))),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: const Color(0xFFE6F4EA), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF198754).withValues(alpha: 0.12))),
                        child: const Row(
                          children: [
                            Icon(LucideIcons.shieldCheck, color: Color(0xFF198754), size: 16),
                            SizedBox(width: 10),
                            Expanded(child: Text('Audit ready structures generated according to accounting principles.', style: TextStyle(fontSize: 11, color: Color(0xFF198754), fontWeight: FontWeight.w500))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton.icon(
                          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
                          icon: const Icon(LucideIcons.download, size: 16),
                          label: const Text('EXPORT LEDGER NOW', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD63384), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(LucideIcons.calendar, size: 10, color: Color(0xFFD63384)),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              const Icon(LucideIcons.calendar, size: 14, color: AppColors.secondaryText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFormatCard(String title, String subtitle, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF10B981) : AppColors.border, width: isSelected ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                if (isSelected) Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
              ],
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 10, color: AppColors.secondaryText)),
          ],
        ),
      ),
    );
  }
}

class RecordAccountingEntryModal extends ConsumerStatefulWidget {
  const RecordAccountingEntryModal({super.key});

  @override
  ConsumerState<RecordAccountingEntryModal> createState() => _RecordAccountingEntryModalState();
}

class _RecordAccountingEntryModalState extends ConsumerState<RecordAccountingEntryModal> {
  String entryType = 'Income / Sales';
  String category = 'Sales Revenue';
  String accountMode = 'Cash in Hand';

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 500;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: isMobile ? double.infinity : 800,
            maxHeight: screenHeight * 0.65,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Expanded(
                      child: Text(
                        'New Financial Entry',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.darkText),
                      ),
                    ),
                    IconButton(
                      onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
                      icon: const Icon(LucideIcons.x, size: 18, color: AppColors.secondaryText),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.grey.shade100,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 16, color: AppColors.border),
              
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(isMobile ? 16 : 24, 0, isMobile ? 16 : 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (isMobile) ...[
                        _buildDropdownField('Entry Type', entryType, ['Income / Sales', 'Expense', 'Asset Purchase', 'Liability Payment'], (val) => setState(() => entryType = val!)),
                        const SizedBox(height: 16),
                        _buildDateField('Date', '11-07-2026'),
                      ] else
                        Row(
                          children: [
                            Expanded(child: _buildDropdownField('Entry Type', entryType, ['Income / Sales', 'Expense', 'Asset Purchase', 'Liability Payment'], (val) => setState(() => entryType = val!))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildDateField('Date', '11-07-2026')),
                          ],
                        ),
                      const SizedBox(height: 20),
                      _buildLabel('Amount (₹)'),
                      Container(
                        height: 52,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                        child: const Text('0.00', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.secondaryText, letterSpacing: 1)),
                      ),
                      const SizedBox(height: 20),
                      if (isMobile) ...[
                        _buildDropdownField('Category', category, ['Sales Revenue', 'Consultancy', 'Other Income'], (val) => setState(() => category = val!)),
                        const SizedBox(height: 16),
                        _buildDropdownField('Account / Mode', accountMode, ['Cash in Hand', 'Bank Account', 'Credit'], (val) => setState(() => accountMode = val!)),
                      ] else
                        Row(
                          children: [
                            Expanded(child: _buildDropdownField('Category', category, ['Sales Revenue', 'Consultancy', 'Other Income'], (val) => setState(() => category = val!))),
                            const SizedBox(width: 12),
                            Expanded(child: _buildDropdownField('Account / Mode', accountMode, ['Cash in Hand', 'Bank Account', 'Credit'], (val) => setState(() => accountMode = val!))),
                          ],
                        ),
                      const SizedBox(height: 20),
                      _buildInputField('Notes / Reference', 'e.g. Inv #123 or Bill Reference'),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () => ref.read(navigationProvider.notifier).setRoute(AppRoute.accounting),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B61FF), foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
                          child: const Text('Save Financial Entry', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(String label, String date) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(date, style: const TextStyle(fontSize: 12, color: AppColors.darkText)),
              const Icon(LucideIcons.calendar, size: 16, color: AppColors.secondaryText),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
    );
  }

  Widget _buildInputField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(
          height: 40,
          child: TextField(
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 12),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        SizedBox(
          height: 40,
          child: DropdownButtonFormField<String>(
            initialValue: value,
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item, style: const TextStyle(fontSize: 12)))).toList(),
            onChanged: onChanged,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
            ),
          ),
        ),
      ],
    );
  }
}

Widget _buildTextField({required String hintText, TextInputType keyboardType = TextInputType.text}) {
  return SizedBox(
    height: 42,
    child: TextField(
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
        ),
      ),
    ),
  );
}

Widget _buildDropdown({
  required String value,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return SizedBox(
    height: 42,
    child: DropdownButtonFormField<String>(
      initialValue: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: const TextStyle(fontSize: 13, color: Color(0xFF1F2937))),
        );
      }).toList(),
      onChanged: onChanged,
      icon: const Icon(LucideIcons.chevronDown, size: 16, color: Color(0xFF6B7280)),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const Color(0xFF7C3AED) == Colors.white ? const BorderSide(color: Color(0xFFE5E7EB)) : const BorderSide(color: Color(0xFF7C3AED), width: 1.5),
        ),
      ),
    ),
  );
}

Widget _buildSettleButton({required String text, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    height: 44,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF7C3AED),
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
