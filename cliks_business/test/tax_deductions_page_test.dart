import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clicks_business_frontend/features/billing/pages/tax_deductions_page.dart';

void main() {
  group('Tax & Deductions Page (cliks.beta-softnet.com/books/tax-deductions) Tests', () {
    testWidgets('Renders all sections on Desktop (1440x900) without any overflow',
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
              body: TaxDeductionsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Tax & Deductions'), findsOneWidget);
      expect(find.text('Calculate and manage your annual tax liability'), findsOneWidget);
      expect(find.text('FY 2024-25'), findsOneWidget);
      expect(find.text('Export Summary'), findsOneWidget);

      // Stat Cards
      expect(find.text('ESTIMATED TAX'), findsOneWidget);
      expect(find.text('TOTAL PAID'), findsOneWidget);
      expect(find.text('DUE AMOUNT'), findsOneWidget);
      expect(find.text('POTENTIAL REFUND'), findsOneWidget);

      // Annual Tax Breakdown Card
      expect(find.text('Annual Tax Breakdown'), findsOneWidget);
      expect(find.text('GROSS ANNUAL INCOME'), findsOneWidget);
      expect(find.text('TDS ALREADY PAID'), findsOneWidget);
      expect(find.text('STANDARD DEDUCTIONS'), findsOneWidget);
      expect(find.text('EPF'), findsOneWidget);
      expect(find.text('ESI'), findsOneWidget);
      expect(find.text('PROF TAX'), findsOneWidget);
      expect(find.text('ADDITIONAL TAX SAVINGS (80C, 80D, etc.)'), findsOneWidget);
      expect(find.text('Update Tax Records'), findsOneWidget);

      // Quick Calculator
      expect(find.text('Quick Calculator'), findsOneWidget);
      expect(find.text('Taxable Base'), findsOneWidget);
      expect(find.text('View Detailed Projection'), findsOneWidget);

      // Tax Compliance
      expect(find.text('Tax Compliance'), findsOneWidget);
      expect(find.text('ITR-1'), findsOneWidget);
      expect(find.text('Click to Calculate'), findsOneWidget);
      expect(find.text('AY 2024'), findsOneWidget);

      // Ensure no exceptions or overflows
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on Mobile (360x780) without overflow',
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
              body: TaxDeductionsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tax & Deductions'), findsOneWidget);
      expect(find.text('ESTIMATED TAX'), findsOneWidget);
      expect(find.text('Update Tax Records'), findsOneWidget);
      expect(find.text('Quick Calculator'), findsOneWidget);
      expect(find.text('Tax Compliance'), findsOneWidget);

      // Ensure zero overflow on mobile
      expect(tester.takeException(), isNull);
    });

    testWidgets('Renders cleanly on 320px narrow mobile without overflow',
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
              body: TaxDeductionsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Tax & Deductions'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Export Summary and Detailed Projection dialogs open and function',
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
              body: TaxDeductionsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Export Summary
      await tester.tap(find.text('Export Summary'));
      await tester.pumpAndSettle();

      expect(find.text('Tax Summary for FY 2024-25 exported successfully.'), findsOneWidget);

      // Tap View Detailed Projection
      await tester.tap(find.text('View Detailed Projection'));
      await tester.pumpAndSettle();

      expect(find.text('Detailed Tax Projection (FY 2024-25)'), findsOneWidget);
      expect(find.text('Net Taxable Base'), findsOneWidget);

      // Dismiss projection dialog
      await tester.tap(find.text('Close Projection'));
      await tester.pumpAndSettle();
      expect(find.text('Detailed Tax Projection (FY 2024-25)'), findsNothing);
    });

    testWidgets('Tax calculation updates on ITR-1 Click to Calculate',
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
              body: TaxDeductionsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap ITR-1 Click to Calculate
      await tester.tap(find.text('Click to Calculate'));
      await tester.pumpAndSettle();

      // Check snackbar
      expect(find.textContaining('Tax records updated for FY 2024-25'), findsOneWidget);

      // Check taxable base and estimated tax are now calculated and displayed
      expect(find.text('₹976000'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  });
}
