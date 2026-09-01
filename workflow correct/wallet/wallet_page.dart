import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import 'add_money_dialog.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
            const SizedBox(height: 32),

            // Current Stored Balance Card
            _buildBalanceCard(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // Wallet History Table Card
            _buildHistoryCard(isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(LucideIcons.wallet, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Beta Wallet',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
              SizedBox(height: 4),
              Text(
                'Manage stored value balances and load funds securely.',
                style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBalanceCard(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CURRENT STORED BALANCE',
                  style: TextStyle(color: AppColors.secondaryText, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
                const SizedBox(height: 8),
                const Text(
                  '₹ 0',
                  style: TextStyle(color: AppColors.darkText, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: _buildAddMoneyButton(),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CURRENT STORED BALANCE',
                      style: TextStyle(color: AppColors.secondaryText, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '₹ 0',
                      style: TextStyle(color: AppColors.darkText, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                _buildAddMoneyButton(),
              ],
            ),
    );
  }

  Widget _buildAddMoneyButton() {
    return Builder(
      builder: (context) => ElevatedButton.icon(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddMoneyDialog(),
          );
        },
        icon: const Icon(LucideIcons.plus, size: 14),
        label: const Text('Add Money', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildHistoryCard(bool isMobile) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Search bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Text(
                  'Wallet History',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText),
                ),
                if (!isMobile) const Spacer(),
                Container(
                  width: isMobile ? double.infinity : 200,
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      Icon(LucideIcons.search, color: AppColors.secondaryText, size: 14),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search descriptions or IDs...',
                            hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 12),
                            border: InputBorder.none,
                            isDense: true,
                          ),
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),

          // Scrollable table to avoid horizontal overflow on mobile
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: isMobile ? 600 : 800),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(AppColors.hoverBackground),
                headingRowHeight: 36,
                columns: const [
                  DataColumn(label: Text('TRANSACTION ID', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                  DataColumn(label: Text('DATE & TIME', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                  DataColumn(label: Text('DESCRIPTION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                  DataColumn(label: Text('DIRECTION', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                  DataColumn(label: Text('AMOUNT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText))),
                ],
                rows: const [],
              ),
            ),
          ),

          // No records indicator
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: const Center(
              child: Text(
                'No transaction matching records found.',
                style: TextStyle(color: AppColors.secondaryText, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
