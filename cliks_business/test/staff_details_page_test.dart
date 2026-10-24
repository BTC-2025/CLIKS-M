import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:clicks_business_frontend/features/billing/pages/staff_details_page.dart';

void main() {
  group('Staff Details Page (cliks.beta-softnet.com/books/finance/staff-details) Tests', () {
    testWidgets('Renders Pending & Locked state on Desktop (1440x900) without any overflow',
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
              body: StaffDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Header
      expect(find.text('Staff Details'), findsOneWidget);
      expect(find.text('PENDING INVITATION'), findsOneWidget);
      expect(find.text('Workforce integrations, organization linkage & salary structure.'), findsOneWidget);
      expect(find.text('ramaniteam123@bnxmail.com'), findsWidgets);

      // Active Integrations Card
      expect(find.text('Active Integrations'), findsOneWidget);
      expect(find.text('Incoming organization & HR linkages'), findsOneWidget);
      expect(find.text('1 Invite'), findsOneWidget);
      expect(find.text('santhoshhhhh(HR)'), findsOneWidget);
      expect(find.text('Cliks Business'), findsOneWidget);
      expect(find.text('Organization: Welton Consignor'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);
      expect(find.text('Sales Executive'), findsOneWidget);
      expect(find.text('Operations'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
      expect(find.text('Direct HR Sync Protection'), findsOneWidget);

      // Locked Salary History
      expect(find.text('YOUR SALARY History & Details'), findsOneWidget);
      expect(find.text('Employment & Salary Details Locked'), findsOneWidget);
      expect(find.text('Accept Invitation to Unlock'), findsOneWidget);
      expect(find.text('••••••••••••'), findsWidgets);

      // Zero exceptions / overflows
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
              body: StaffDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Staff Details'), findsOneWidget);
      expect(find.text('PENDING INVITATION'), findsOneWidget);
      expect(find.text('Active Integrations'), findsOneWidget);
      expect(find.text('Accept'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);

      // Zero exceptions / overflows on mobile
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
              body: StaffDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Staff Details'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('Accepting invitation unlocks salary records and displays all Bento cards',
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
              body: StaffDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Accept button
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      // 1. Check Header Badge changed
      expect(find.text('INTEGRATION ACTIVE'), findsOneWidget);

      // 2. Check Success Banner
      expect(
        find.text('Invitation accepted! Salary details for ramaniteam123@bnxmail.com are now live.'),
        findsWidgets,
      );

      // 3. Check Active Integration status
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Integration active & verified'), findsOneWidget);
      expect(find.text('Reset Status'), findsOneWidget);

      // 4. Check Unlocked Salary Cards (Screenshots 4 & 5)
      expect(find.text('✓ VERIFIED UNLOCKED'), findsOneWidget);
      expect(find.text('vincent ffjd'), findsOneWidget);
      expect(find.textContaining('CLK-0040'), findsWidgets);
      expect(find.text('FULL TIME ACTIVE'), findsOneWidget);

      // Basic Monthly Salary Card
      expect(find.text('₹25,000'), findsWidgets);
      expect(find.text('ANNUAL CTC'), findsOneWidget);
      expect(find.text('₹3,00,000'), findsOneWidget);
      expect(find.text('₹17,500'), findsOneWidget);
      expect(find.text('₹5,000'), findsOneWidget);
      expect(find.text('₹2,500'), findsOneWidget);
      expect(find.text('₹23,500'), findsOneWidget);

      // Bank Disbursement Card
      expect(find.text('BANK DISBURSEMENT DETAILS'), findsOneWidget);
      expect(find.text('HDFC Bank'), findsOneWidget);
      expect(find.text('•••• •••• 5678'), findsOneWidget);
      expect(find.text('HDFC0001234'), findsOneWidget);
      expect(find.text('Auto Direct Credit (NEFT)'), findsOneWidget);

      // PAN, PF & Compliance Records Card
      expect(find.text('PAN, PF & COMPLIANCE RECORDS'), findsOneWidget);
      expect(find.text('ABCDE1234F'), findsOneWidget);
      expect(find.text('VERIFIED'), findsOneWidget);
      expect(find.text('101234567890'), findsOneWidget);
      expect(find.text('31009876540001'), findsOneWidget);

      // Residential Address & Emergency Contacts Card
      expect(find.text('RESIDENTIAL ADDRESS & EMERGENCY CONTACTS'), findsOneWidget);
      expect(find.text('HR SUBMITTED RECORD'), findsOneWidget);
      expect(find.text('Plot No. 12, Anna Nagar, Chennai, Tamil Nadu (600040)'), findsOneWidget);
      expect(find.text('Vijay Kumar (Father) - +91 98765 99911'), findsOneWidget);

      // Disbursed Payslips Card (Screenshot 5)
      expect(find.text('DISBURSED PAYSLIPS'), findsOneWidget);
      expect(find.text('August 2026 Payslip'), findsOneWidget);
      expect(find.text('July 2026 Payslip'), findsOneWidget);
      expect(find.text('Slip'), findsWidgets);

      // Zero exceptions / overflows
      expect(tester.takeException(), isNull);
    });

    testWidgets('Payslip modal opens on Slip tap and displays breakdown',
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
              body: StaffDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Accept to unlock
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();

      // Scroll to Slip button and tap
      await tester.ensureVisible(find.text('Slip').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Slip').first);
      await tester.pumpAndSettle();

      // Verify modal content
      expect(find.text('August 2026 (31 Aug 2026)'), findsOneWidget);
      expect(find.text('Employer'), findsOneWidget);
      expect(find.text('Gross Earnings'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);
      expect(find.text('Print Payslip'), findsOneWidget);

      // Close modal
      await tester.tap(find.byIcon(LucideIcons.x).last);
      await tester.pumpAndSettle();
      expect(find.text('Gross Earnings'), findsNothing);
    });

    testWidgets('Reset Status returns back to Pending & Locked state',
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
              body: StaffDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Accept
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();
      expect(find.text('INTEGRATION ACTIVE'), findsOneWidget);

      // Reset
      await tester.tap(find.text('Reset Status'));
      await tester.pumpAndSettle();

      expect(find.text('PENDING INVITATION'), findsOneWidget);
      expect(find.text('Employment & Salary Details Locked'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
