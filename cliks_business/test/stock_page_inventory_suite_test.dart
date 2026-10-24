import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clicks_business_frontend/features/billing/pages/stock_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  group('Inventory Suite - StockPage Functional & Responsive Tests', () {
    testWidgets('Desktop (1440x900): Renders empty state matching Screenshot 1 without overflow', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.macOS),
            home: const Scaffold(
              body: StockPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(StockPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Verify Header & Subtitle
      expect(find.text('Inventory Suite'), findsOneWidget);
      expect(find.text('Precision stock management for enterprise growth.'), findsOneWidget);

      // Verify Action Buttons
      expect(find.text('Export Report'), findsOneWidget);
      expect(find.text('Add New Product'), findsOneWidget);

      // Verify 5 Top Stat Cards initial state
      expect(find.text('Total Inventory Value'), findsOneWidget);
      expect(find.text('₹0'), findsOneWidget);
      expect(find.text('Active Items'), findsOneWidget);
      expect(find.text('Total Units'), findsOneWidget);
      expect(find.text('Low Stock Alerts'), findsOneWidget);
      expect(find.text('Out of Stock'), findsOneWidget);

      // Verify Search & Filters
      expect(find.text('Search by product name or category...'), findsOneWidget);
      expect(find.text('All Categories'), findsOneWidget);
      expect(find.text('All Statuses'), findsOneWidget);
      expect(find.text('All Stock'), findsOneWidget);
      expect(find.text('Low Stock'), findsOneWidget);

      // Verify Empty State Text
      expect(
        find.text('No inventory items found. Click "Add New Product" to initialize your stock.'),
        findsOneWidget,
      );
    });

    testWidgets('Narrow Mobile (320x640) & Standard Mobile (390x844): Renders cleanly without overflow', (tester) async {
      for (final size in [const Size(320, 640), const Size(390, 844)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          ProviderScope(
            child: MaterialApp(
              theme: ThemeData(platform: TargetPlatform.android),
              home: const Scaffold(
                body: StockPage(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(StockPage), findsOneWidget);
        expect(tester.takeException(), isNull, reason: 'Failed with overflow on $size');
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('Full Product Registration, Dynamic Valuations, Quick Adjustments & Audit Trail (Screenshot 2 & 3)', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.macOS),
            home: const Scaffold(
              body: StockPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Open Register Product modal (Screenshot 2)
      final addBtn = find.text('Add New Product');
      await tester.ensureVisible(addBtn);
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      expect(find.text('Register Product'), findsOneWidget);
      expect(find.text('Enter product specifications and initial stock levels.'), findsOneWidget);

      // 2. Fill product form fields (matching Screenshot 3: macbook, air 9, electronics, 50 pcs, ₹40)
      final textFields = find.byType(TextField);
      // TextField 0 is the search box in background, fields 1..7 are in dialog
      expect(textFields, findsNWidgets(8));

      await tester.enterText(textFields.at(1), 'macbook'); // Product Name
      await tester.enterText(textFields.at(2), 'air 9'); // Sub Name
      await tester.enterText(textFields.at(3), 'electronics'); // Category
      await tester.enterText(textFields.at(4), 'pcs'); // Unit Label
      await tester.enterText(textFields.at(5), '50'); // Initial Quantity
      await tester.enterText(textFields.at(6), '40'); // Unit Valuation
      await tester.enterText(textFields.at(7), '10'); // Low Stock Alert Level

      // Tap 'Initialize Product' button
      final initBtn = find.text('Initialize Product');
      await tester.ensureVisible(initBtn);
      await tester.tap(initBtn);
      await tester.pumpAndSettle();

      // 3. Verify dialog is dismissed and dynamic Bento metrics updated (Screenshot 3)
      expect(find.text('Register Product'), findsNothing);
      expect(find.text('₹2,000'), findsOneWidget); // 50 * ₹40 = ₹2,000 Total Inventory Value
      expect(find.text('50'), findsWidgets); // Total Units

      // 4. Verify table row values (Screenshot 3)
      expect(find.text('macbook'), findsOneWidget);
      expect(find.text('air 9'), findsOneWidget);
      expect(find.text('electronics'), findsWidgets);
      expect(
        find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().trim() == '50 pcs'),
        findsOneWidget,
      );
      expect(find.text('₹40'), findsOneWidget);
      expect(find.text('IN STOCK'), findsWidgets);

      // 5. Test Quick Stock Dispatch (-1)
      final dispatchBtn = find.byIcon(LucideIcons.arrowDownRight);
      expect(dispatchBtn, findsOneWidget);
      await tester.tap(dispatchBtn);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().trim() == '49 pcs'),
        findsOneWidget,
      );
      expect(find.text('₹1,960'), findsOneWidget); // 49 * 40 = 1960

      // 6. Test Quick Stock Add (+1)
      final addStockBtn = find.byIcon(LucideIcons.arrowUpRight);
      expect(addStockBtn, findsOneWidget);
      await tester.tap(addStockBtn);
      await tester.pumpAndSettle();

      expect(
        find.byWidgetPredicate((w) => w is RichText && w.text.toPlainText().trim() == '50 pcs'),
        findsOneWidget,
      );
      expect(find.text('₹2,000'), findsOneWidget);

      // 7. Test Audit Trail Modal
      final historyBtn = find.byIcon(LucideIcons.history);
      expect(historyBtn, findsOneWidget);
      await tester.tap(historyBtn);
      await tester.pumpAndSettle();

      expect(find.text('macbook - Stock Audit Trail'), findsOneWidget);
      expect(find.text('Initial Product Registration'), findsOneWidget);
      expect(find.text('Current Available Stock'), findsOneWidget);

      final closeAuditBtn = find.text('Close Audit Log');
      await tester.ensureVisible(closeAuditBtn);
      await tester.tap(closeAuditBtn);
      await tester.pumpAndSettle();
      expect(find.text('macbook - Stock Audit Trail'), findsNothing);

      // 8. Test Export Report Button
      final exportBtn = find.text('Export Report');
      await tester.ensureVisible(exportBtn);
      await tester.tap(exportBtn);
      await tester.pumpAndSettle();

      expect(find.text('Inventory Suite summary report exported successfully!'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
