import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clicks_business_frontend/core/navigation/navigation_provider.dart';
import 'package:clicks_business_frontend/features/billing/pages/accounting_page.dart';

void main() {
  group('Finance / Accounting Page (cliks.beta-softnet.com) Responsive & Functional Tests', () {
    testWidgets('Renders all Bento sections on Desktop (1440x900) without any overflow',
        (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccountingPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('Finance'), findsOneWidget);
      expect(find.text('Track your income, fixed costs, and daily spending in one place.'), findsOneWidget);
      expect(find.text('Tax & Deductions'), findsOneWidget);

      // 2. Bento Stat Cards
      expect(find.text('TOTAL INCOME'), findsOneWidget);
      expect(find.text('TOTAL EXPENSES'), findsOneWidget);
      expect(find.text('MONTHLY SAVINGS'), findsOneWidget);
      expect(find.text('NET WORTH'), findsOneWidget);

      // 3. Investment Portfolio & Estimated Tax Due cards
      expect(find.text('INVESTMENT PORTFOLIO'), findsOneWidget);
      expect(find.text('ESTIMATED TAX DUE'), findsOneWidget);
      expect(find.text('+% All-time'), findsOneWidget);
      expect(find.text('Monthly P/L  +₹0'), findsOneWidget);
      expect(find.text('Due by July 31st'), findsOneWidget);
      expect(find.text('TDS Paid  ₹0'), findsOneWidget);

      // 4. My Wallet & Budget Planner
      expect(find.text('My Wallet'), findsOneWidget);
      expect(find.text('Budget Planner'), findsOneWidget);
      expect(find.text('AVAILABLE BALANCE'), findsOneWidget);
      expect(find.text('MONTHLY BUDGET LIMIT'), findsOneWidget);
      expect(find.text('EXPENSES'), findsOneWidget);
      expect(find.text('REMAINING'), findsOneWidget);

      // 5. Financial Goals
      expect(find.text('Financial Goals'), findsOneWidget);
      expect(find.text('Track your long-term milestones'), findsOneWidget);

      // 6. Investment Portfolio Asset Allocation
      expect(find.text('Investment Portfolio'), findsOneWidget);
      expect(find.text('Real-time asset allocation & performance'), findsOneWidget);
      expect(find.text('MARKET VALUE'), findsOneWidget);
      expect(find.text('COST BASIS'), findsOneWidget);
      expect(find.text('Add Investment'), findsOneWidget);

      // 7. Additional Source Section
      expect(find.text('Additional Source'), findsWidgets);
      expect(find.text('ADDITIONAL INCOME'), findsOneWidget);

      // 8. Bills & Reminders
      expect(find.text('Bills & Reminders'), findsOneWidget);
      expect(find.text('Add Bill'), findsOneWidget);

      // 9. Fixed Source Section
      expect(find.text('Fixed Source'), findsWidgets);
      expect(find.text('FIXED INCOME'), findsOneWidget);

      // Zero exceptions / overflows
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on Mobile (360x780) with zero overflow errors',
        (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccountingPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Finance'), findsOneWidget);
      expect(find.text('Tax & Deductions'), findsOneWidget);
      expect(find.text('TOTAL INCOME'), findsOneWidget);
      expect(find.text('TOTAL EXPENSES'), findsOneWidget);
      expect(find.text('MONTHLY SAVINGS'), findsOneWidget);
      expect(find.text('NET WORTH'), findsOneWidget);

      // Zero exceptions / overflows on mobile
      expect(tester.takeException(), isNull);
    });

    testWidgets('Tax & Deductions button routes to AppRoute.taxDeductions',
        (tester) async {
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
              body: AccountingPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Tax & Deductions button
      await tester.tap(find.text('Tax & Deductions').first);
      await tester.pumpAndSettle();

      expect(container.read(navigationProvider).currentRoute, AppRoute.taxDeductions);
    });

    testWidgets('Add Funds to Wallet dialog increases balance',
        (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccountingPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('₹0.00'), findsWidgets);

      // Ensure visible and Tap Add Funds
      await tester.ensureVisible(find.text('Add Funds'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Add Funds'));
      await tester.pumpAndSettle();

      expect(find.text('Add Funds to Wallet'), findsOneWidget);
      await tester.tap(find.text('+ ₹5,000'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Deposit Funds'));
      await tester.pumpAndSettle();

      // Verify wallet updated
      expect(find.text('₹5000.00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 320px narrow mobile with zero overflow errors',
        (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: AccountingPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AccountingPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
