import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';

class SubscriptionVaultPage extends StatefulWidget {
  const SubscriptionVaultPage({super.key});

  @override
  State<SubscriptionVaultPage> createState() => _SubscriptionVaultPageState();
}

class _SubscriptionVaultPageState extends State<SubscriptionVaultPage> {
  int _selectedFilter = 0; // 0: All, 1: Entertainment, 2: Utilities, 3: Housing, 4: Fitness

  final List<Map<String, dynamic>> _subscriptions = [
    {
      'name': 'House Rent',
      'category': 'Housing',
      'amount': 22000,
      'cycle': 'Monthly',
      'dueDate': '1st of month',
      'status': 'PAYMENT DUE',
      'statusColor': const Color(0xFFEF4444),
      'icon': LucideIcons.home,
      'isPaid': false,
    },
    {
      'name': 'Star Health Insurance',
      'category': 'Utilities',
      'amount': 7974,
      'cycle': 'Monthly',
      'dueDate': '28th of month',
      'status': 'UPCOMING',
      'statusColor': const Color(0xFFF59E0B),
      'icon': LucideIcons.shieldAlert,
      'isPaid': false,
    },
    {
      'name': 'Cult.fit Gym Membership',
      'category': 'Fitness',
      'amount': 2499,
      'cycle': 'Monthly',
      'dueDate': '22nd of month',
      'status': 'UPCOMING',
      'statusColor': const Color(0xFFF59E0B),
      'icon': LucideIcons.dumbbell,
      'isPaid': false,
    },
    {
      'name': 'Airtel Fiber 1Gbps',
      'category': 'Utilities',
      'amount': 1199,
      'cycle': 'Monthly',
      'dueDate': '25th of month',
      'status': 'PAID THIS MONTH',
      'statusColor': const Color(0xFF10B981),
      'icon': LucideIcons.wifi,
      'isPaid': true,
    },
    {
      'name': 'Netflix 4K Ultra',
      'category': 'Entertainment',
      'amount': 649,
      'cycle': 'Monthly',
      'dueDate': '15th of month',
      'status': 'AUTO-DEBIT ACTIVE',
      'statusColor': const Color(0xFF2563EB),
      'icon': LucideIcons.tv,
      'isPaid': true,
    },
    {
      'name': 'Spotify Family Plan',
      'category': 'Entertainment',
      'amount': 179,
      'cycle': 'Monthly',
      'dueDate': '18th of month',
      'status': 'PAID THIS MONTH',
      'statusColor': const Color(0xFF10B981),
      'icon': LucideIcons.music,
      'isPaid': true,
    },
  ];

  double get _totalBurnRate {
    return _subscriptions.fold(0, (sum, item) => sum + (item['amount'] as num));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;
    final paddingVal = isMobile ? 16.0 : 24.0;

    final filteredList = _subscriptions.where((sub) {
      if (_selectedFilter == 1) return sub['category'] == 'Entertainment';
      if (_selectedFilter == 2) return sub['category'] == 'Utilities';
      if (_selectedFilter == 3) return sub['category'] == 'Housing';
      if (_selectedFilter == 4) return sub['category'] == 'Fitness';
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7F6),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, paddingVal),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header (Title + Add Button)
            _buildHeader(isMobile).animate().fadeIn(duration: 400.ms),
            const SizedBox(height: 24),

            // 2. Fixed Burn Rate Summary Banner
            _buildBurnRateBanner(isMobile, filteredList).animate().fadeIn(duration: 450.ms, delay: 50.ms),
            const SizedBox(height: 24),

            // 3. Category Filter Pills
            _buildFilterPills(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 20),

            // 4. Subscriptions List Cards
            _buildSubscriptionCardsGrid(filteredList, isMobile).animate().fadeIn(duration: 500.ms, delay: 150.ms),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Header
  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F5132),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(LucideIcons.repeat, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Subscription Vault', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    SizedBox(height: 2),
                    Text('Manage personal recurring bills & fixed monthly burn rate.', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openAddSubscriptionModal(isMobile),
              icon: const Icon(LucideIcons.plus, size: 16),
              label: const Text('Add New Subscription', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F5132),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(LucideIcons.repeat, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Subscription Vault', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                SizedBox(height: 4),
                Text('Manage personal recurring bills & fixed monthly burn rate.', style: TextStyle(fontSize: 13, color: AppColors.secondaryText)),
              ],
            ),
          ],
        ),
        ElevatedButton.icon(
          onPressed: () => _openAddSubscriptionModal(isMobile),
          icon: const Icon(LucideIcons.plus, size: 16),
          label: const Text('Add New Subscription', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F5132),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  // Burn Rate Summary Banner
  Widget _buildBurnRateBanner(bool isMobile, List<Map<String, dynamic>> filteredList) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F5132), Color(0xFF198754)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F5132).withValues(alpha: 0.2),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.flame, color: Colors.white, size: 18),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'FIXED MONTHLY BURN RATE',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white70, letterSpacing: 0.5),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
                child: Text('${filteredList.length} Active Vaults', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text('₹${_totalBurnRate.toStringAsFixed(0)}', style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white)),
              const Text(' / month', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: 8),
          Text('Automatic advance due-date notifications enabled for all active subscriptions.', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.85))),
        ],
      ),
    );
  }

  // Filter Pills
  Widget _buildFilterPills(bool isMobile) {
    final filters = ['All Vaults', 'Entertainment', 'Utilities', 'Housing', 'Fitness'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(filters.length, (index) {
          final isSelected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () => setState(() => _selectedFilter = index),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F172A) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? const Color(0xFF0F172A) : Colors.grey.shade200),
                ),
                child: Text(
                  filters[index],
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade700),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Subscriptions Cards Grid
  Widget _buildSubscriptionCardsGrid(List<Map<String, dynamic>> items, bool isMobile) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth > 900
            ? (constraints.maxWidth - 32) / 3
            : constraints.maxWidth > 600
                ? (constraints.maxWidth - 16) / 2
                : constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: items.map((sub) {
            return Container(
              width: cardWidth,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(sub['icon'] as IconData, color: const Color(0xFF059669), size: 20),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: (sub['statusColor'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              sub['status'] as String,
                              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: sub['statusColor'] as Color, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () {
                              final name = sub['name'];
                              setState(() {
                                _subscriptions.remove(sub);
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('$name deleted from Subscription Vault'),
                                  backgroundColor: const Color(0xFF0F5132),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF2F2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.trash2, color: Color(0xFFEF4444), size: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(sub['name'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.darkText), maxLines: 2, softWrap: true),
                  const SizedBox(height: 2),
                  Text('Due: ${sub['dueDate']}', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('₹${sub['amount']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.darkText)),
                      Text(' / ${sub['cycle']}', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: (sub['isPaid'] as bool)
                        ? OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(LucideIcons.check, size: 14, color: Color(0xFF10B981)),
                            label: const Text('Paid This Month', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFF10B981)),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                sub['isPaid'] = true;
                                sub['status'] = 'PAID THIS MONTH';
                                sub['statusColor'] = const Color(0xFF10B981);
                              });
                            },
                            icon: const Icon(LucideIcons.checkCircle2, size: 14),
                            label: const Text('Mark as Paid', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0F5132),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  // Add Subscription Modal
  void _openAddSubscriptionModal(bool isMobile) {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    String category = 'Housing';

    void submit() {
      if (nameCtrl.text.isNotEmpty && amountCtrl.text.isNotEmpty) {
        setState(() {
          _subscriptions.add({
            'name': nameCtrl.text,
            'category': category,
            'amount': int.tryParse(amountCtrl.text) ?? 500,
            'cycle': 'Monthly',
            'dueDate': dateCtrl.text.isEmpty ? '15th of month' : dateCtrl.text,
            'status': 'UPCOMING',
            'statusColor': const Color(0xFFF59E0B),
            'icon': LucideIcons.creditCard,
            'isPaid': false,
          });
        });
      }
      Navigator.pop(context);
    }

    final content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Subscription Vault', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                    SizedBox(height: 2),
                    Text('Track a new recurring bill or digital membership.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: const Icon(LucideIcons.x, size: 16, color: Colors.grey)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildInputField('SUBSCRIPTION NAME *', 'e.g. Disney+ Hotstar', nameCtrl),
          const SizedBox(height: 12),
          _buildInputField('MONTHLY COST (₹) *', 'e.g. 1499', amountCtrl),
          const SizedBox(height: 12),
          _buildInputField('DUE DAY *', 'e.g. 10th of month', dateCtrl),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F5132),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Save Subscription', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => FractionallySizedBox(heightFactor: 0.65, child: Padding(padding: const EdgeInsets.all(20), child: content)),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)), child: Container(width: 480, padding: const EdgeInsets.all(24), child: content)),
      );
    }
  }

  Widget _buildInputField(String label, String placeholder, TextEditingController ctrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey.shade600, letterSpacing: 0.5)),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            filled: true,
            fillColor: const Color(0xFFFAFAFB),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade200)),
          ),
        ),
      ],
    );
  }
}
