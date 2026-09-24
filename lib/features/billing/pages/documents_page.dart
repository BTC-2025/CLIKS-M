import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/app_ui_kit.dart';

class DocumentsPage extends StatefulWidget {
  const DocumentsPage({super.key});

  @override
  State<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends State<DocumentsPage> {
  String? _selectedFolderId; // null = All
  int _activeCategoryFilter = 0; // 0: All, 1: Bills, 2: Challans, 3: Tax, 4: Medical
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // State: Folders List
  final List<Map<String, dynamic>> _folders = [
    {
      'id': 'fold_1',
      'name': 'Expense Bills & Invoices',
      'category': 'bills',
      'count': 6,
      'size': '3.2 MB',
      'color': const Color(0xFF059669),
      'bgColor': const Color(0xFFECFDF5),
      'icon': LucideIcons.receipt,
    },
    {
      'id': 'fold_2',
      'name': 'Traffic Challans & Fines',
      'category': 'challans',
      'count': 3,
      'size': '1.1 MB',
      'color': const Color(0xFFD97706),
      'bgColor': const Color(0xFFFFFBEB),
      'icon': LucideIcons.fileWarning,
    },
    {
      'id': 'fold_3',
      'name': 'Tax & Investment Proofs',
      'category': 'tax',
      'count': 2,
      'size': '850 KB',
      'color': const Color(0xFF2563EB),
      'bgColor': const Color(0xFFEFF6FF),
      'icon': LucideIcons.shieldCheck,
    },
    {
      'id': 'fold_4',
      'name': 'Medical Receipts',
      'category': 'medical',
      'count': 1,
      'size': '420 KB',
      'color': const Color(0xFF9333EA),
      'bgColor': const Color(0xFFF3E8FF),
      'icon': LucideIcons.heartPulse,
    },
  ];

  // State: Documents List
  final List<Map<String, dynamic>> _documents = [
    {
      'id': 'doc_1',
      'name': 'Uber_Cab_Invoice_July.pdf',
      'folderId': 'fold_1',
      'folderName': 'Expense Bills & Invoices',
      'category': 'BILL',
      'size': '1.2 MB',
      'date': '8/5/2026',
      'type': 'PDF',
    },
    {
      'id': 'doc_2',
      'name': 'Amazon_Electronics_Bill.pdf',
      'folderId': 'fold_1',
      'folderName': 'Expense Bills & Invoices',
      'category': 'BILL',
      'size': '850 KB',
      'date': '8/2/2026',
      'type': 'PDF',
    },
    {
      'id': 'doc_3',
      'name': 'Traffic_Speeding_Challan_DL04.pdf',
      'folderId': 'fold_2',
      'folderName': 'Traffic Challans & Fines',
      'category': 'CHALLAN',
      'size': '450 KB',
      'date': '7/28/2026',
      'type': 'PDF',
    },
    {
      'id': 'doc_4',
      'name': 'Section_80C_LIC_Receipt.pdf',
      'folderId': 'fold_3',
      'folderName': 'Tax & Investment Proofs',
      'category': 'TAX',
      'size': '620 KB',
      'date': '7/15/2026',
      'type': 'PDF',
    },
    {
      'id': 'doc_5',
      'name': 'Apollo_Pharmacy_Medicine_Bill.jpg',
      'folderId': 'fold_4',
      'folderName': 'Medical Receipts',
      'category': 'MEDICAL',
      'size': '420 KB',
      'date': '7/10/2026',
      'type': 'JPG',
    },
    {
      'id': 'doc_6',
      'name': 'Electricity_Bill_Bescom_June.pdf',
      'folderId': 'fold_1',
      'folderName': 'Expense Bills & Invoices',
      'category': 'BILL',
      'size': '710 KB',
      'date': '6/28/2026',
      'type': 'PDF',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Calculated Aggregates
  int get _totalDocs => _documents.length;
  int get _totalFolders => _folders.length;
  double get _totalStorageMb => 5.57; // MB

  List<Map<String, dynamic>> get _filteredDocs {
    return _documents.where((d) {
      if (_selectedFolderId != null && d['folderId'] != _selectedFolderId) {
        return false;
      }

      final categoryMatch = () {
        if (_activeCategoryFilter == 1) return d['category'] == 'BILL';
        if (_activeCategoryFilter == 2) return d['category'] == 'CHALLAN';
        if (_activeCategoryFilter == 3) return d['category'] == 'TAX';
        if (_activeCategoryFilter == 4) return d['category'] == 'MEDICAL';
        if (_activeCategoryFilter == 5) return d['category'] != 'BILL' && d['category'] != 'CHALLAN' && d['category'] != 'TAX' && d['category'] != 'MEDICAL';
        return true;
      }();
      if (!categoryMatch) return false;

      if (_searchQuery.trim().isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      final name = (d['name'] as String).toLowerCase();
      final folderName = (d['folderName'] as String).toLowerCase();
      final cat = (d['category'] as String).toLowerCase();

      return name.contains(q) || folderName.contains(q) || cat.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 950;
    final paddingVal = isMobile ? 16.0 : 32.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(paddingVal, 20, paddingVal, isMobile ? 90 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header Bar
            _buildHeader(context, isMobile).animate().fadeIn(duration: 400.ms).slideY(begin: -0.05, end: 0),
            const SizedBox(height: 24),

            // Top Metric Summary Cards
            _buildMetricCards(context, isMobile).animate().fadeIn(duration: 450.ms, delay: 50.ms),
            const SizedBox(height: 28),

            // Folders Section
            _buildFoldersSection(context, isMobile).animate().fadeIn(duration: 450.ms, delay: 100.ms),
            const SizedBox(height: 28),

            // Tabs & Search Bar
            _buildTabsAndSearchRow(isMobile).animate().fadeIn(duration: 400.ms, delay: 150.ms),
            const SizedBox(height: 20),

            // Documents List / Empty View
            if (_filteredDocs.isEmpty)
              _buildEmptyStateCard(context, isMobile).animate().fadeIn(duration: 450.ms)
            else
              _buildDocumentsList(context, isMobile).animate().fadeIn(duration: 500.ms),
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
          'Document Vault',
          style: TextStyle(fontSize: isMobile ? 20 : 26, fontWeight: FontWeight.bold, color: AppColors.darkText),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        const Text(
          'Store and organize personal bills, challans, tax proofs & expense receipts.',
          style: TextStyle(fontSize: 13, color: AppColors.secondaryText, height: 1.4),
        ),
      ],
    );

    final actionsRow = Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => _openCreateFolderModal(isMobile),
          icon: const Icon(LucideIcons.folderPlus, size: 15, color: AppColors.primaryGreen),
          label: const Text('New Folder', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen, fontSize: 13)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            side: const BorderSide(color: AppColors.primaryGreen),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () => _openUploadDocumentModal(isMobile),
          icon: const Icon(LucideIcons.uploadCloud, size: 16),
          label: const Text('Upload File', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 0,
          ),
        ),
      ],
    );

    if (isMobile) {
      return Container(
        padding: const EdgeInsets.all(14),
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
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.hoverBackground,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(LucideIcons.folderArchive, color: AppColors.primaryGreen, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(child: titleCol),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, child: actionsRow),
          ],
        ),
      );
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.hoverBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(LucideIcons.folderArchive, color: AppColors.primaryGreen, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(child: titleCol),
        const SizedBox(width: 24),
        actionsRow,
      ],
    );
  }

  Widget _buildMetricCards(BuildContext context, bool isMobile) {
    final metrics = [
      {
        'label': 'TOTAL DOCUMENTS',
        'value': '$_totalDocs Files',
        'icon': LucideIcons.fileText,
        'color': const Color(0xFF059669),
        'bgColor': const Color(0xFFECFDF5),
      },
      {
        'label': 'FOLDERS CREATED',
        'value': '$_totalFolders Folders',
        'icon': LucideIcons.folder,
        'color': const Color(0xFF2563EB),
        'bgColor': const Color(0xFFEFF6FF),
      },
      {
        'label': 'STORAGE USED',
        'value': '${_totalStorageMb.toStringAsFixed(1)} MB / 50 MB',
        'icon': LucideIcons.hardDrive,
        'color': const Color(0xFFD97706),
        'bgColor': const Color(0xFFFFFBEB),
      },
    ];

    final cardWidgets = metrics.map((m) {
      final color = m['color'] as Color;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.015), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: m['bgColor'] as Color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(m['icon'] as IconData, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    m['label'] as String,
                    style: const TextStyle(color: AppColors.secondaryText, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Text(
                      m['value'] as String,
                      style: const TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
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
              const SizedBox(width: 10),
              Expanded(child: cardWidgets[1]),
            ],
          ),
          const SizedBox(height: 10),
          cardWidgets[2],
        ],
      );
    }

    return Row(
      children: cardWidgets.map((c) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: c,
        ),
      )).toList(),
    );
  }

  Widget _buildFoldersSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'CATEGORIZED FOLDERS',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.darkText, letterSpacing: 0.5),
            ),
            if (_selectedFolderId != null)
              GestureDetector(
                onTap: () => setState(() => _selectedFolderId = null),
                child: const Text(
                  'Clear Folder Filter',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primaryGreen),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),

        LayoutBuilder(builder: (context, constraints) {
          final count = isMobile ? 2 : 4;
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _folders.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: count,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: isMobile ? 1.4 : 1.7,
            ),
            itemBuilder: (context, index) {
              final folder = _folders[index];
              final isSelected = _selectedFolderId == folder['id'];
              final color = folder['color'] as Color;
              final bgColor = folder['bgColor'] as Color;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedFolderId = isSelected ? null : folder['id'];
                  });
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withValues(alpha: 0.08) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? color : AppColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.015), blurRadius: 8, offset: const Offset(0, 3)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(folder['icon'] as IconData, color: color, size: 18),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${folder['count']} files',
                              style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        folder['name'] as String,
                        style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: AppColors.darkText),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        'Size: ${folder['size']}',
                        style: const TextStyle(fontSize: 10, color: AppColors.secondaryText),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildTabsAndSearchRow(bool isMobile) {
    final categories = ['All Files', 'Bills & Invoices', 'Traffic Challans', 'Tax Proofs', 'Medical', 'Custom'];

    final tabsRow = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(categories.length, (index) {
          final isActive = _activeCategoryFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(
                categories[index],
                style: TextStyle(
                  color: isActive ? Colors.white : AppColors.secondaryText,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.5,
                ),
              ),
              selected: isActive,
              onSelected: (selected) {
                if (selected) setState(() => _activeCategoryFilter = index);
              },
              selectedColor: AppColors.primaryGreen,
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: isActive ? AppColors.primaryGreen : AppColors.border),
              ),
              showCheckmark: false,
            ),
          );
        }),
      ),
    );

    final searchBar = Container(
      width: isMobile ? double.infinity : 280,
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.search, color: AppColors.secondaryText, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: const InputDecoration(
                hintText: 'Search documents...',
                hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 12.5),
                border: InputBorder.none,
                isDense: true,
              ),
              style: const TextStyle(fontSize: 12.5),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            GestureDetector(
              onTap: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
              child: const Icon(LucideIcons.x, size: 14, color: AppColors.secondaryText),
            ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tabsRow,
          const SizedBox(height: 12),
          searchBar,
        ],
      );
    }

    return Row(
      children: [
        Expanded(child: tabsRow),
        const SizedBox(width: 16),
        searchBar,
      ],
    );
  }

  Widget _buildDocumentsList(BuildContext context, bool isMobile) {
    return Column(
      children: _filteredDocs.map((doc) {
        final cat = doc['category'] as String;
        final color = () {
          if (cat == 'BILL') return const Color(0xFF059669);
          if (cat == 'CHALLAN') return const Color(0xFFD97706);
          if (cat == 'TAX') return const Color(0xFF2563EB);
          return const Color(0xFF9333EA);
        }();
        final bgColor = () {
          if (cat == 'BILL') return const Color(0xFFECFDF5);
          if (cat == 'CHALLAN') return const Color(0xFFFFFBEB);
          if (cat == 'TAX') return const Color(0xFFEFF6FF);
          return const Color(0xFFF3E8FF);
        }();

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(isMobile ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.012), blurRadius: 8, offset: const Offset(0, 3)),
            ],
          ),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(LucideIcons.fileText, color: color, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc['name'] as String,
                                style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: AppColors.darkText),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${doc['folderName']} • ${doc['date']}',
                                style: const TextStyle(fontSize: 10.5, color: AppColors.secondaryText),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
                          child: Text(
                            cat,
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Size: ${doc['size']}',
                          style: const TextStyle(fontSize: 10.5, color: AppColors.secondaryText, fontWeight: FontWeight.w500),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () => _previewDocument(doc),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEFF6FF),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFBFDBFE)),
                                ),
                                child: const Row(
                                  children: [
                                    Icon(LucideIcons.eye, size: 12, color: Color(0xFF2563EB)),
                                    SizedBox(width: 4),
                                    Text('View', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                AppSnackbar.show(context, "Downloading '${doc['name']}'...", type: SnackType.info);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(LucideIcons.download, size: 13, color: AppColors.secondaryText),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                final name = doc['name'];
                                setState(() => _documents.removeWhere((d) => d['id'] == doc['id']));
                                AppSnackbar.show(context, "Document '$name' deleted.", type: SnackType.info);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF2F2),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFFCA5A5)),
                                ),
                                child: const Icon(LucideIcons.trash2, size: 13, color: Color(0xFFEF4444)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: bgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(LucideIcons.fileText, color: color, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doc['name'] as String,
                            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: AppColors.darkText),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                doc['folderName'] as String,
                                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              ),
                              const SizedBox(width: 8),
                              const Text('•', style: TextStyle(color: Colors.grey)),
                              const SizedBox(width: 8),
                              Text(
                                doc['date'] as String,
                                style: const TextStyle(fontSize: 11, color: AppColors.secondaryText),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(6)),
                      child: Text(
                        cat,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: color),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      doc['size'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondaryText),
                    ),
                    const SizedBox(width: 16),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(LucideIcons.eye, size: 16, color: Color(0xFF2563EB)),
                          onPressed: () => _previewDocument(doc),
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.download, size: 16, color: AppColors.secondaryText),
                          onPressed: () {
                            AppSnackbar.show(context, "Downloading '${doc['name']}'...", type: SnackType.info);
                          },
                        ),
                        IconButton(
                          icon: const Icon(LucideIcons.trash2, size: 16, color: Color(0xFFEF4444)),
                          onPressed: () {
                            final name = doc['name'];
                            setState(() => _documents.removeWhere((d) => d['id'] == doc['id']));
                            AppSnackbar.show(context, "Document '$name' deleted.", type: SnackType.info);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
        );
      }).toList(),
    );
  }

  void _previewDocument(Map<String, dynamic> doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(LucideIcons.fileText, color: AppColors.primaryGreen, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                doc['name'] as String,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LucideIcons.fileCheck, size: 48, color: AppColors.primaryGreen),
                  SizedBox(height: 8),
                  Text('Document Preview Ready', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text('Encrypted Vault File • Verified', style: TextStyle(fontSize: 11, color: AppColors.secondaryText)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildMetaRow('Folder:', doc['folderName'] as String),
            _buildMetaRow('Category:', doc['category'] as String),
            _buildMetaRow('Uploaded Date:', doc['date'] as String),
            _buildMetaRow('File Size:', doc['size'] as String),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              AppSnackbar.show(context, "Downloading '${doc['name']}'...", type: SnackType.success);
            },
            icon: const Icon(LucideIcons.download, size: 14),
            label: const Text('Download File'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 11.5, color: AppColors.secondaryText)),
          Text(value, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: AppColors.darkText)),
        ],
      ),
    );
  }

  Widget _buildEmptyStateCard(BuildContext context, bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 24 : 40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(color: AppColors.hoverBackground, shape: BoxShape.circle),
            child: const Icon(LucideIcons.folderOpen, color: AppColors.secondaryText, size: 36),
          ),
          const SizedBox(height: 16),
          const Text('No Documents Found', style: TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          const Text('Upload bills, challans, or tax proofs to save them in this vault.', style: TextStyle(color: AppColors.secondaryText, fontSize: 12)),
        ],
      ),
    );
  }

  void _openCreateFolderModal(bool isMobile) {
    final folderCtrl = TextEditingController();
    void submit() {
      final name = folderCtrl.text.trim();
      if (name.isEmpty) return;

      setState(() {
        _folders.add({
          'id': 'fold_${DateTime.now().millisecondsSinceEpoch}',
          'name': name,
          'category': 'custom',
          'count': 0,
          'size': '0 KB',
          'color': const Color(0xFF059669),
          'bgColor': const Color(0xFFECFDF5),
          'icon': LucideIcons.folder,
        });
      });
      Navigator.pop(context);
      AppSnackbar.show(context, "Folder '$name' created successfully!", type: SnackType.success);
    }

    final content = SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(LucideIcons.folderPlus, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Create New Document Folder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text('FOLDER NAME *', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
          const SizedBox(height: 6),
          TextField(
            controller: folderCtrl,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'e.g. Vehicle Insurance & Maintenance',
              filled: true,
              fillColor: const Color(0xFFFAFAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Create Folder', style: TextStyle(fontWeight: FontWeight.bold)),
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
        builder: (context) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: content,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(width: 420, padding: const EdgeInsets.all(24), child: content),
        ),
      );
    }
  }

  void _openUploadDocumentModal(bool isMobile) {
    final titleCtrl = TextEditingController();
    final customCategoryCtrl = TextEditingController();
    String selectedCat = 'BILL';
    String selectedFolderId = _folders.first['id'];
    String? fetchedFileName;
    String fetchedFileSize = '1.2 MB';

    void submit() {
      final title = titleCtrl.text.trim().isEmpty 
          ? (fetchedFileName ?? 'Scanned_Bill_Doc.pdf') 
          : titleCtrl.text.trim();
      final folderObj = _folders.firstWhere((f) => f['id'] == selectedFolderId, orElse: () => _folders.first);

      final categoryTag = (selectedCat == 'CUSTOM' && customCategoryCtrl.text.trim().isNotEmpty)
          ? customCategoryCtrl.text.trim().toUpperCase()
          : selectedCat;

      setState(() {
        _documents.add({
          'id': 'doc_${DateTime.now().millisecondsSinceEpoch}',
          'name': title.contains('.') ? title : '$title.pdf',
          'folderId': selectedFolderId,
          'folderName': folderObj['name'],
          'category': categoryTag,
          'size': fetchedFileSize,
          'date': '8/7/2026',
          'type': title.toLowerCase().endsWith('.jpg') || title.toLowerCase().endsWith('.png') ? 'IMG' : 'PDF',
        });
        folderObj['count'] = (folderObj['count'] as int) + 1;
      });

      Navigator.pop(context);
      AppSnackbar.show(context, "Document '$title' uploaded to vault!", type: SnackType.success);
    }

    final content = StatefulBuilder(builder: (context, setModalState) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(LucideIcons.uploadCloud, color: AppColors.primaryGreen, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text('Upload Document to Vault', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.darkText)),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(LucideIcons.x, size: 16, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Document Upload / Fetch File Box
            const Text('SELECT / FETCH DOCUMENT FILE *', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
            const SizedBox(height: 6),
            InkWell(
              onTap: () {
                setModalState(() {
                  fetchedFileName = "Expense_Receipt_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.pdf";
                  fetchedFileSize = "1.4 MB";
                  if (titleCtrl.text.trim().isEmpty) {
                    titleCtrl.text = "Expense_Receipt_Aug7";
                  }
                });
                AppSnackbar.show(context, "Document file fetched: $fetchedFileName", type: SnackType.info);
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(LucideIcons.fileUp, color: AppColors.primaryGreen, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fetchedFileName ?? 'Tap to Fetch Document from Device',
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.bold,
                              color: fetchedFileName != null ? AppColors.darkText : AppColors.primaryGreen,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            fetchedFileName != null ? 'Size: $fetchedFileSize • PDF/JPG Ready' : 'Browse bills, challans & receipts (PDF/JPG/PNG)',
                            style: const TextStyle(fontSize: 10.5, color: AppColors.secondaryText),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(LucideIcons.arrowUpRight, color: AppColors.primaryGreen, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 14),

            const Text('DOCUMENT TITLE *', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
            const SizedBox(height: 6),
            TextField(
              controller: titleCtrl,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'e.g. Fuel Receipt July, Speeding Challan',
                filled: true,
                fillColor: const Color(0xFFFAFAFB),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
            const SizedBox(height: 12),
            const Text('SELECT FOLDER *', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
            const SizedBox(height: 6),
            DropdownButtonFormField<String>(
              initialValue: selectedFolderId,
              items: _folders.map((f) {
                return DropdownMenuItem<String>(
                  value: f['id'] as String,
                  child: Text(f['name'] as String, style: const TextStyle(fontSize: 12.5)),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) setModalState(() => selectedFolderId = val);
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFFAFAFB),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
              ),
            ),
            const SizedBox(height: 12),
            const Text('DOCUMENT CATEGORY', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['BILL', 'CHALLAN', 'TAX', 'MEDICAL', 'CUSTOM'].map((cat) {
                  final isSel = selectedCat == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(cat, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? Colors.white : AppColors.secondaryText)),
                      selected: isSel,
                      onSelected: (s) {
                        if (s) setModalState(() => selectedCat = cat);
                      },
                      selectedColor: AppColors.primaryGreen,
                      backgroundColor: Colors.white,
                      showCheckmark: false,
                    ),
                  );
                }).toList(),
              ),
            ),

            if (selectedCat == 'CUSTOM') ...[
              const SizedBox(height: 12),
              const Text('CUSTOM CATEGORY NAME *', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold, color: AppColors.secondaryText)),
              const SizedBox(height: 6),
              TextField(
                controller: customCategoryCtrl,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. INSURANCE, WARRANTY, VEHICLE',
                  filled: true,
                  fillColor: const Color(0xFFFAFAFB),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFFE2E8F0))),
                ),
              ),
            ],

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Save to Document Vault', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      );
    });

    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        builder: (context) => Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: content,
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(width: 440, padding: const EdgeInsets.all(24), child: content),
        ),
      );
    }
  }
}
