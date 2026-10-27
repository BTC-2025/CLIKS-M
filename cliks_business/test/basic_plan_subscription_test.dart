import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clicks_business_frontend/features/billing/pages/subscription_page.dart';

void main() {
  group('Basic Plan Subscription Tab & Checklist Tests', () {
    testWidgets('Renders all 10 Basic Plan features and comparison table on Desktop', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SubscriptionPage(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Tap on BASIC PLAN tab pill
      final basicPlanTab = find.text('BASIC PLAN');
      expect(basicPlanTab, findsOneWidget);
      await tester.tap(basicPlanTab);
      await tester.pumpAndSettle();

      // Check header and plan title
      expect(find.text('Basic Plan Details'), findsOneWidget);
      expect(find.text('Basic Plan'), findsOneWidget);
      expect(find.text("WHAT'S INCLUDED"), findsOneWidget);

      // Verify the 10 Ready-to-Use UI Checklist strings in the card
      final expectedChecklist = [
        '100% Ad-Free Workspace & Watermark-Free Bills (1-Yr Validity)',
        'Generate up to 500 Simple Bills/mo + 365-Day Billing Archive',
        '1,000 Finance Entries/mo, 5 Wallets & Full Tax/TDS Calculator',
        'Track up to 25 Investment Portfolio Assets with Live Monthly P/L',
        'Inventory Suite: Up to 2,500 Active Stock Items & Low-Stock Alerts',
        'Up to 30 Active Splitwise Group Tickets (15 Members per Group)',
        '500 People Network Contacts + Automated Loan Repayment Alerts',
        'Link 10 Connected Stores + Full Loyalty Points & Cashback Calculator',
        'Direct Employer HR Sync + 3-Year Verified Payslip & Tax PDF Vault',
        '10 Purpose Wallets, 50 Scheduled Payments & Unlimited CSV/PDF Exports',
      ];

      for (final item in expectedChecklist) {
        expect(find.text(item), findsWidgets);
      }

      // Verify the Free vs Basic Plan Feature Comparison section
      expect(find.text('Free vs. Basic Plan Feature Comparison'), findsOneWidget);
      expect(find.text('FEATURE CATEGORY'), findsOneWidget);
      expect(find.text('GENERAL USER (FREE — RESTRICTED)'), findsOneWidget);
      expect(find.text('SUBSCRIBED USER (BASIC PLAN — ₹249/YR)'), findsOneWidget);

      // Check a sample of restricted vs subscribed text in comparison table
      expect(find.textContaining('Contains in-app ads & "Powered by CLIKS"'), findsOneWidget);
      expect(find.textContaining('100% Ad-Free Experience + Clean, unbranded'), findsOneWidget);
    });

    testWidgets('Renders Basic Plan tab on Mobile (360x780) without overflow', (tester) async {
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
              body: SubscriptionPage(),
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final basicPlanTab = find.text('BASIC PLAN');
      expect(basicPlanTab, findsOneWidget);
      await tester.tap(basicPlanTab);
      await tester.pumpAndSettle();

      expect(find.text('Basic Plan Details'), findsOneWidget);
      expect(find.text('100% Ad-Free Workspace & Watermark-Free Bills (1-Yr Validity)'), findsWidgets);
    });
  });
}
