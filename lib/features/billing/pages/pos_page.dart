import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../widgets/quick_register_item_dialog.dart';
import '../../../widgets/app_ui_kit.dart';

class PosPage extends StatefulWidget {
  const PosPage({super.key});

  @override
  State<PosPage> createState() => _PosPageState();
}

class _PosPageState extends State<PosPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: isMobile
          ? SingleChildScrollView(
              padding: EdgeInsets.all(paddingVal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 20),
                  _buildLeftCatalog(isMobile),
                  const SizedBox(height: 20),
                  _buildRightCart(isMobile),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(paddingVal),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(isMobile),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildLeftCatalog(isMobile),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 2,
                          child: _buildRightCart(isMobile),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    final titleInfo = Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: const Color(0xFFE289F2).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(LucideIcons.monitor, color: Color(0xFF198754), size: 20),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Retail POS System',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
              Text(
                'Speed Checkout Terminal #1',
                style: TextStyle(fontSize: 11, color: AppColors.secondaryText),
              ),
            ],
          ),
        ),
      ],
    );

    final actionsWidget = Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const QuickRegisterItemDialog(),
            );
          },
          icon: const Icon(LucideIcons.plus, size: 14),
          label: const Text('Add Product', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF198754),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4EA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Text('TODAY ORDERS', style: TextStyle(color: Color(0xFF137333), fontSize: 9, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text('0', style: TextStyle(color: Color(0xFF137333), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFE6F4EA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Text('TOTAL SALES', style: TextStyle(color: Color(0xFF137333), fontSize: 9, fontWeight: FontWeight.bold)),
              SizedBox(width: 4),
              Text('₹0', style: TextStyle(color: Color(0xFF137333), fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        OutlinedButton.icon(
          onPressed: () {
            AppSnackbar.show(
              context,
              "Opening POS Transaction History Logs...",
              type: SnackType.info,
            );
          },
          icon: const Icon(LucideIcons.history, size: 14),
          label: const Text('History', style: TextStyle(fontSize: 11)),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkText,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          titleInfo,
          const SizedBox(height: 12),
          actionsWidget,
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: titleInfo),
        const SizedBox(width: 12),
        actionsWidget,
      ],
    );
  }

  Widget _buildLeftCatalog(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search & Filter
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Row(
                    children: [
                      SizedBox(width: 8),
                      Icon(LucideIcons.search, size: 14, color: AppColors.secondaryText),
                      SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          style: TextStyle(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: 'Search item name, category or barcode SKU...',
                            hintStyle: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('All'),
                selected: true,
                selectedColor: const Color(0xFF198754).withValues(alpha: 0.12),
                labelStyle: const TextStyle(color: Color(0xFF198754), fontSize: 12, fontWeight: FontWeight.bold),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Color(0xFF198754)),
                ),
                onSelected: (val) {},
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Catalog Content Placeholder
          Container(
            height: isMobile ? 180 : 250,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.shoppingBag, size: 48, color: AppColors.secondaryText.withValues(alpha: 0.4)),
                const SizedBox(height: 12),
                const Text(
                  'No products matching selection',
                  style: TextStyle(fontSize: 12, color: AppColors.secondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightCart(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Customer Select
          Container(
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              children: [
                SizedBox(width: 8),
                Icon(LucideIcons.userPlus, size: 14, color: AppColors.secondaryText),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: TextStyle(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Assign Customer (e.g., Walk-in / Search CRM...)',
                      hintStyle: TextStyle(fontSize: 11, color: AppColors.secondaryText),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Empty state cart placeholder
          Container(
            height: 140,
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.calculator, size: 40, color: AppColors.secondaryText.withValues(alpha: 0.4)),
                const SizedBox(height: 10),
                const Text(
                  'Cart is Empty\nSelect products from catalog to begin billing.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: AppColors.secondaryText, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),

          // Pricing Summary
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('DISCOUNT', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                    const SizedBox(height: 4),
                    Container(
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      alignment: Alignment.centerLeft,
                      child: const Text('0', style: TextStyle(fontSize: 12, color: AppColors.darkText)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GST TAX (%)', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
                    const SizedBox(height: 4),
                    Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('18%', style: TextStyle(fontSize: 12, color: AppColors.darkText)),
                          Icon(LucideIcons.chevronDown, size: 12, color: AppColors.secondaryText),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
              Text('₹0', style: TextStyle(fontSize: 12, color: AppColors.darkText, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('GST (18%)', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
              Text('₹0', style: TextStyle(fontSize: 12, color: AppColors.darkText, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.border),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Payable Amount', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText)),
              Text('₹0', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF198754))),
            ],
          ),
          const SizedBox(height: 20),

          // Payout methods
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppSnackbar.show(
                      context,
                      "Cash payment received successfully. Printing receipt...",
                      type: SnackType.success,
                    );
                  },
                  icon: const Icon(LucideIcons.banknote, size: 14),
                  label: const Text('Cash (F1)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF198754),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppSnackbar.show(
                      context,
                      "UPI QR code generated. Awaiting customer scan...",
                      type: SnackType.info,
                    );
                  },
                  icon: const Icon(LucideIcons.qrCode, size: 14),
                  label: const Text('UPI (F2)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8A2BE2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    AppSnackbar.show(
                      context,
                      "Processing credit/debit card transaction...",
                      type: SnackType.info,
                    );
                  },
                  icon: const Icon(LucideIcons.creditCard, size: 14),
                  label: const Text('Card (F3)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF2994A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
