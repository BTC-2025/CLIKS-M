import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clicks_business_frontend/core/navigation/navigation_provider.dart';
import 'package:clicks_business_frontend/data/income_provider.dart';
import 'package:clicks_business_frontend/features/billing/pages/income_page.dart';
import 'package:clicks_business_frontend/features/navigation/shell_layout.dart';
import 'package:clicks_business_frontend/features/navigation/widgets/sidebar.dart';
import 'package:clicks_business_frontend/widgets/modals/add_transaction_modal.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Income Page & Sidebar Transaction Flow Tests', () {
    testWidgets('IncomePage renders stat cards, search, filter and empty table on desktop without overflow', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: IncomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Track and manage your revenue streams'), findsOneWidget);
      expect(find.text('Record Income'), findsOneWidget);
      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Recurring Revenue'), findsOneWidget);
      expect(find.text('Active Sources'), findsOneWidget);
      expect(find.text('Search income sources...'), findsOneWidget);
      expect(find.text('SOURCE NAME'), findsOneWidget);
      expect(find.text('CATEGORY'), findsOneWidget);
      expect(find.text('DATE'), findsOneWidget);
      expect(find.text('AMOUNT'), findsOneWidget);
      expect(find.text('ACTION'), findsOneWidget);
      expect(find.text('No income records found.'), findsOneWidget);

      expect(tester.takeException(), isNull);
    });

    testWidgets('IncomePage renders correctly on mobile screen sizes (360x700, 320x600)', (tester) async {
      for (final size in [const Size(360, 700), const Size(320, 600)]) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;

        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: IncomePage(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Track and manage your revenue streams'), findsOneWidget);
        expect(find.text('Total Income'), findsOneWidget);
        expect(find.text('Recurring Revenue'), findsOneWidget);
        expect(find.text('Active Sources'), findsOneWidget);
        expect(find.text('No income records found.'), findsOneWidget);
        expect(tester.takeException(), isNull);
      }

      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    testWidgets('Desktop Sidebar renders + Add Income & + Add Expense buttons and opens modal', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: Row(
                children: [
                  Sidebar(),
                  Expanded(child: IncomePage()),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Add Income'), findsOneWidget);
      expect(find.text('Add Expense'), findsOneWidget);
      expect(find.text('Income'), findsWidgets);

      // Tap Add Income
      await tester.tap(find.text('Add Income'));
      await tester.pumpAndSettle();

      // Verify modal is open with 'Add Income' title
      expect(find.byType(AddTransactionModal), findsOneWidget);
      expect(find.text('Save Income Entry'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AddTransactionModal), findsNothing);

      // Tap Add Expense
      await tester.tap(find.text('Add Expense'));
      await tester.pumpAndSettle();

      // Verify modal is open with 'Add Expense' title
      expect(find.byType(AddTransactionModal), findsOneWidget);
      expect(find.text('Save Expense Entry'), findsOneWidget);

      // Close modal
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AddTransactionModal), findsNothing);
    });

    testWidgets('Recording an income entry updates the income table and stat cards', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: Scaffold(
              body: IncomePage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initially 0
      expect(find.text('No income records found.'), findsOneWidget);

      // Add a record directly via provider
      container.read(incomeEntriesProvider.notifier).addRecord(
        IncomeRecord(
          id: 'test_1',
          sourceName: 'Acme Client Retainer',
          amount: 50000,
          category: 'Client Retainer',
          date: DateTime(2026, 11, 21),
          paymentMode: 'Bank Transfer',
          isRecurring: true,
        ),
      );
      await tester.pumpAndSettle();

      // Empty state should be gone
      expect(find.text('No income records found.'), findsNothing);
      expect(find.text('Acme Client Retainer'), findsOneWidget);
      expect(find.text('₹50,000'), findsWidgets);
      expect(find.text('Client Retainer'), findsWidgets);
    });

    testWidgets('ShellLayout navigates to IncomePage when AppRoute.income is set', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(navigationProvider.notifier).setRoute(AppRoute.income);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            home: ShellLayout(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(IncomePage), findsOneWidget);
      expect(find.text('Track and manage your revenue streams'), findsOneWidget);
    });
  });
}
