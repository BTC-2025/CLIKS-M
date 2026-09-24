import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class GratitudeJournalPage extends StatefulWidget {
  const GratitudeJournalPage({super.key});

  @override
  State<GratitudeJournalPage> createState() => _GratitudeJournalPageState();
}

class _GratitudeJournalPageState extends State<GratitudeJournalPage> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = ['All Wins', 'Cash Saved', 'Habit Shift', 'Mindful Refusal'];

  final List<Map<String, dynamic>> _journalEntries = [
    {
      'id': '1',
      'title': 'Cooked Meal at Home Instead of Swiggy',
      'date': 'Today, 2:30 PM',
      'story': 'Resisted ordering food delivery for dinner. Prepared a healthy home-cooked meal and saved significant cash!',
      'savedAmount': 450,
      'category': 'Food & Dining',
      'tagType': 'Cash Saved',
      'likes': 4,
      'isLiked': true,
    },
    {
      'id': '2',
      'title': 'Passed on Impulsive Sneaker Sale',
      'date': 'Yesterday, 6:15 PM',
      'story': 'Added shoes to cart during flash sale, but placed it in my 48-hr Cooling Vault instead of instant checkout.',
      'savedAmount': 3200,
      'category': 'Shopping',
      'tagType': 'Mindful Refusal',
      'likes': 8,
      'isLiked': false,
    },
    {
      'id': '3',
      'title': 'Cancelled Unused Cloud Subscription',
      'date': 'Aug 4, 2026',
      'story': 'Audited my monthly billing statements and cancelled an idle ₹699/mo cloud storage plan I hadn’t touched in 4 months.',
      'savedAmount': 699,
      'category': 'Subscriptions',
      'tagType': 'Habit Shift',
      'likes': 12,
      'isLiked': true,
    },
    {
      'id': '4',
      'title': 'Carpooled to Office',
      'date': 'Aug 3, 2026',
      'story': 'Shared ride with colleague instead of solo cab booking during peak surge hours.',
      'savedAmount': 350,
      'category': 'Commute',
      'tagType': 'Cash Saved',
      'likes': 6,
      'isLiked': false,
    },
  ];

  void _openAddWinDialog() {
    showDialog(
      context: context,
      builder: (context) => LogGratitudeDialog(
        onEntrySaved: (newEntry) {
          setState(() {
            _journalEntries.insert(0, newEntry);
          });
          AppSnackbar.show(
            context,
            'Daily financial win logged successfully!',
            type: SnackType.success,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    final filteredEntries = _selectedFilterIndex == 0
        ? _journalEntries
        : _journalEntries.where((e) => e['tagType'] == _filters[_selectedFilterIndex]).toList();

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
            _buildStatCards(isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 32),

            // Filter Chips Row
            _buildFilterRow(isMobile).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 20),

            // Journal Timeline Entries
            _buildEntriesList(filteredEntries, isMobile).animate().fadeIn(duration: 500.ms, delay: 200.ms),
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
          'Financial Gratitude & Win Journal',
          style: TextStyle(fontSize: isMobile ? 19 : 24, fontWeight: FontWeight.bold, color: AppColors.darkText),
        ),
        const SizedBox(height: 4),
        const Text(
          'Reflect on daily money wins, mindful spending choices, and financial gratitude.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionBtn = ElevatedButton.icon(
      onPressed: _openAddWinDialog,
      icon: const Icon(LucideIcons.plus, size: 16),
      label: const Text('Log Daily Win', style: TextStyle(fontWeight: FontWeight.bold)),
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
                    child: const Icon(LucideIcons.bookOpen, color: AppColors.primaryGreen, size: 18),
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
                child: const Icon(LucideIcons.bookOpen, color: AppColors.primaryGreen, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(child: titleCol),
              const SizedBox(width: 20),
              actionBtn,
            ],
          );
  }

  Widget _buildStatCards(bool isMobile) {
    final totalSaved = _journalEntries.fold<int>(0, (sum, item) => sum + (item['savedAmount'] as int));

    final cardsData = [
      {
        'label': 'TOTAL WINS LOGGED',
        'value': '${_journalEntries.length} Wins',
        'icon': LucideIcons.sparkles,
        'color': AppColors.primaryGreen,
      },
      {
        'label': 'TOTAL CASH SAVED',
        'value': '₹ $totalSaved',
        'icon': LucideIcons.banknote,
        'color': AppColors.blue,
      },
      {
        'label': 'CURRENT WIN STREAK',
        'value': '12 Days',
        'icon': LucideIcons.flame,
        'color': Colors.amber,
      },
      {
        'label': 'MINDFULNESS RATE',
        'value': '92%',
        'icon': LucideIcons.heart,
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

  Widget _buildFilterRow(bool isMobile) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedFilterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: ChoiceChip(
              label: Text(
                _filters[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.secondaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              selected: isSelected,
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.white,
              side: BorderSide(color: isSelected ? AppColors.primaryGreen : AppColors.border),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              onSelected: (val) {
                if (val) {
                  setState(() {
                    _selectedFilterIndex = index;
                  });
                }
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildEntriesList(List<Map<String, dynamic>> entries, bool isMobile) {
    if (entries.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: const Column(
          children: [
            Icon(LucideIcons.sparkles, color: AppColors.secondaryText, size: 36),
            SizedBox(height: 12),
            Text('No journal entries in this filter', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkText)),
            SizedBox(height: 4),
            Text('Log a daily win to build your financial growth journal!', style: TextStyle(fontSize: 12, color: AppColors.secondaryText)),
          ],
        ),
      );
    }

    return Column(
      children: entries.map((entry) {
        final isLiked = entry['isLiked'] as bool;
        final likes = entry['likes'] as int;
        final savedAmount = entry['savedAmount'] as int;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.01), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(LucideIcons.sparkles, color: AppColors.primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry['title'] as String,
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.darkText),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          entry['date'] as String,
                          style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                        ),
                      ],
                    ),
                  ),
                  if (savedAmount > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.hoverBackground,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
                      ),
                      child: Text(
                        'Saved ₹$savedAmount',
                        style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                entry['story'] as String,
                style: const TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    spacing: 8,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          entry['category'] as String,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          entry['tagType'] as String,
                          style: const TextStyle(fontSize: 10, color: AppColors.primaryGreen, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        entry['isLiked'] = !isLiked;
                        entry['likes'] = isLiked ? likes - 1 : likes + 1;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            isLiked ? LucideIcons.heart : LucideIcons.heart,
                            size: 16,
                            color: isLiked ? Colors.red : AppColors.secondaryText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${entry['likes']}',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isLiked ? Colors.red : AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class LogGratitudeDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onEntrySaved;

  const LogGratitudeDialog({super.key, required this.onEntrySaved});

  @override
  State<LogGratitudeDialog> createState() => _LogGratitudeDialogState();
}

class _LogGratitudeDialogState extends State<LogGratitudeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _storyController = TextEditingController();
  final _amountController = TextEditingController();

  String _selectedCategory = 'Food & Dining';
  String _selectedTagType = 'Cash Saved';

  final List<String> _categories = ['Food & Dining', 'Shopping', 'Subscriptions', 'Commute', 'Entertainment', 'Utilities'];
  final List<String> _tagTypes = ['Cash Saved', 'Habit Shift', 'Mindful Refusal'];

  @override
  void dispose() {
    _titleController.dispose();
    _storyController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final savedVal = int.tryParse(_amountController.text.trim()) ?? 0;
      final newEntry = {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'title': _titleController.text.trim(),
        'date': 'Just Now',
        'story': _storyController.text.trim(),
        'savedAmount': savedVal,
        'category': _selectedCategory,
        'tagType': _selectedTagType,
        'likes': 1,
        'isLiked': true,
      };
      widget.onEntrySaved(newEntry);
      Navigator.of(context).pop();
    }
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
          maxHeight: MediaQuery.of(context).size.height * 0.70,
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
                    child: const Icon(LucideIcons.sparkles, color: AppColors.primaryGreen, size: 18),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Log Daily Money Win',
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

            // Scrollable Form Body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Win Headline / Action',
                          hintText: 'e.g. Cooked meal at home, Skipped impulse buy',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a title' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _storyController,
                        maxLines: 2,
                        decoration: InputDecoration(
                          labelText: 'Reflection / Story Notes',
                          hintText: 'Describe how you felt or how much you saved...',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        validator: (val) => val == null || val.trim().isEmpty ? 'Please enter your reflection' : null,
                      ),
                      const SizedBox(height: 12),
                      isMobile
                          ? Column(
                              children: [
                                TextFormField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Cash Saved (₹)',
                                    hintText: '0',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                DropdownButtonFormField<String>(
                                  initialValue: _selectedCategory,
                                  decoration: InputDecoration(
                                    labelText: 'Category',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                                  onChanged: (val) => setState(() => _selectedCategory = val!),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _amountController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Cash Saved (₹)',
                                      hintText: '0',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: DropdownButtonFormField<String>(
                                    initialValue: _selectedCategory,
                                    decoration: InputDecoration(
                                      labelText: 'Category',
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                    ),
                                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12)))).toList(),
                                    onChanged: (val) => setState(() => _selectedCategory = val!),
                                  ),
                                ),
                              ],
                            ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedTagType,
                        decoration: InputDecoration(
                          labelText: 'Win Type Tag',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: _tagTypes.map((t) => DropdownMenuItem(value: t, child: Text(t, style: const TextStyle(fontSize: 12)))).toList(),
                        onChanged: (val) => setState(() => _selectedTagType = val!),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text('Save Journal Entry', style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
