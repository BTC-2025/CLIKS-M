import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clicks_business_frontend/features/billing/pages/subscription_vault_page.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

void main() {
  group('SubscriptionVaultPage - Mobile OS Alignment & macOS Preservation', () {
    testWidgets('macOS (1200x800): Preserves desktop layout untouched', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.macOS),
          home: const SubscriptionVaultPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify desktop header
      expect(find.text('Subscription Vault'), findsOneWidget);
      expect(find.text('Manage personal recurring bills & fixed monthly burn rate.'), findsOneWidget);
      expect(find.text('Add New Subscription'), findsOneWidget);

      // Verify burn rate banner
      expect(find.text('FIXED MONTHLY BURN RATE'), findsOneWidget);
      expect(find.text('6 Active Vaults'), findsOneWidget);
      expect(find.text(' / month'), findsOneWidget);

      // Verify filter pills
      expect(find.text('All Vaults'), findsOneWidget);
      expect(find.text('Entertainment'), findsOneWidget);
      expect(find.text('Utilities'), findsOneWidget);
      expect(find.text('Housing'), findsOneWidget);
      expect(find.text('Fitness'), findsOneWidget);

      // Verify subscriptions
      expect(find.text('House Rent'), findsOneWidget);
      expect(find.text('Netflix 4K Ultra'), findsOneWidget);

      // No overflow exceptions
      expect(tester.takeException(), isNull);
    });

    testWidgets('Standard Mobile (390x844, Android/iOS): Sections align correctly', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.android),
          home: const SubscriptionVaultPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify mobile header
      expect(find.text('Subscription Vault'), findsOneWidget);
      expect(find.text('Add New Subscription'), findsOneWidget);

      // Verify banner
      expect(find.text('FIXED MONTHLY BURN RATE'), findsOneWidget);
      expect(find.text('6 Active Vaults'), findsOneWidget);

      // Verify Mark as Paid interaction
      final markPaidBtn = find.text('Mark as Paid').first;
      await tester.tap(markPaidBtn);
      await tester.pumpAndSettle();

      // Verify status updated to Paid This Month
      expect(find.text('Paid This Month'), findsWidgets);

      // Open Add Subscription BottomSheet on mobile
      final addBtn = find.text('Add New Subscription');
      await tester.tap(addBtn);
      await tester.pumpAndSettle();

      expect(find.text('Add Subscription Vault'), findsOneWidget);
      expect(find.text('Save Subscription'), findsOneWidget);

      // Close modal
      final closeBtn = find.byIcon(LucideIcons.x);
      await tester.tap(closeBtn);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('Narrow Mobile (320x640): Zero overflow and compact card alignment', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(platform: TargetPlatform.iOS),
          home: const SubscriptionVaultPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Subscription Vault'), findsOneWidget);
      expect(find.text('FIXED MONTHLY BURN RATE'), findsOneWidget);
      expect(find.text('House Rent'), findsOneWidget);

      // Verify filter filtering works on narrow mobile
      await tester.tap(find.text('Entertainment'));
      await tester.pumpAndSettle();

      expect(find.text('Netflix 4K Ultra'), findsOneWidget);
      expect(find.text('House Rent'), findsNothing);

      expect(tester.takeException(), isNull);
    });
  });
}
