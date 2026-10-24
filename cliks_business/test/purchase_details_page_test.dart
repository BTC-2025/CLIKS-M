import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:clicks_business_frontend/features/billing/pages/purchase_details_page.dart';

void main() {
  group('Purchase Details Page (cliks.beta-softnet.com/books/purchase-details) Tests', () {
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
              body: PurchaseDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Header
      expect(find.text('Purchase Details'), findsOneWidget);
      expect(find.text('Connected commerce tracking, customer loyalty rewards & supplier purchase workflow.'), findsOneWidget);
      expect(find.text('Sync Data'), findsOneWidget);

      // 2. Active Integrations & Loyalty Rewards Overview
      expect(find.text('Active Integrations'), findsOneWidget);
      expect(find.text('0 Connected'), findsOneWidget);
      expect(find.text('Loyalty & Rewards Overview'), findsOneWidget);
      expect(find.text('Points Rules & Ratio'), findsOneWidget);
      expect(find.text('AVAILABLE BALANCE'), findsOneWidget);
      expect(find.textContaining('140,184'), findsOneWidget);
      expect(find.text('Calculator'), findsOneWidget);

      // 3. Customer Purchase History
      expect(find.text('Customer Purchase History'), findsOneWidget);
      expect(find.text('LINK EXTERNAL STORE'), findsOneWidget);
      expect(find.text('Connected Shops & Purchases'), findsOneWidget);
      expect(find.text('All Shops'), findsOneWidget);

      // 4. POS Transaction Card
      expect(find.text('POS-696314'), findsOneWidget);
      expect(find.text('CONNECTED SHOP'), findsOneWidget);
      expect(find.textContaining('Merchant: ravinew2004'), findsOneWidget);
      expect(find.textContaining('141,600'), findsOneWidget);
      expect(find.text('PAID'), findsOneWidget);
      expect(find.text('View Items >'), findsOneWidget);

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
              body: PurchaseDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Purchase Details'), findsOneWidget);
      expect(find.text('Active Integrations'), findsOneWidget);
      expect(find.text('Loyalty & Rewards Overview'), findsOneWidget);
      expect(find.text('Customer Purchase History'), findsOneWidget);
      expect(find.text('POS-696314'), findsOneWidget);

      // Zero exceptions / overflows on mobile
      final exc = tester.takeException();
      if (exc is FlutterError) {
        for (final d in exc.diagnostics) {
          debugPrint('DIAG: ${d.toStringDeep()}');
        }
      }
      expect(exc, isNull);
    });

    testWidgets('Points Rules and Calculator dialogs open and function',
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
              body: PurchaseDetailsPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open Points Rules Dialog
      await tester.tap(find.text('Points Rules & Ratio'));
      await tester.pumpAndSettle();

      expect(find.text('Base Earning Rate'), findsOneWidget);
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();

      // Open View Items modal
      await tester.tap(find.text('View Items >'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Purchased Items Breakdown'), findsOneWidget);
      expect(find.text('Commercial POS Terminal Hardware'), findsOneWidget);
      await tester.tap(find.byIcon(LucideIcons.x));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
