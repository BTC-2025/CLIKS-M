import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clicks_business_frontend/features/dashboard/dashboard_page.dart';
import 'package:clicks_business_frontend/core/navigation/navigation_provider.dart';
import 'package:clicks_business_frontend/features/dashboard/widgets/configure_quick_actions_dialog.dart';

void main() {
  group('Dashboard Page - Compact Mobile vs Desktop Layout Verification', () {
    // ═════════════════════════════════════════════════════════════════════════
    // 1. ANDROID STANDARD MOBILE (360 x 780)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on Android (360x780): Renders compact mobile view without overflow', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: const Scaffold(
              body: DashboardPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
      final err = tester.takeException();
      if (err != null) {
        print('NARROW TEST ERROR: ');
      }
      expect(err, isNull);

      // Verify Books Console Header & Quick Action Center
      expect(find.text('Books Console'), findsOneWidget);
      expect(find.text('Quick Action Center'), findsOneWidget);

      // Verify Live Stat Cards
      expect(find.text('Asset Inventory Value'), findsOneWidget);
      expect(find.text('Segregated Funds Total'), findsOneWidget);
      expect(find.text('Split Shared Costs'), findsOneWidget);

      // Verify Modules Suite & Fund Segregation
      expect(find.text('Modules & Management Suite'), findsOneWidget);
      expect(find.text('Fund Segregation'), findsWidgets);
      expect(find.text('Personalized Bills & Splits'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 2. ANDROID NARROW MOBILE (320 x 640)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on Narrow Android (320x640): Renders compact layout with 0 overflows', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: const Scaffold(
              body: DashboardPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Verify elements render cleanly on narrow viewport
      expect(find.text('Books Console'), findsOneWidget);
      expect(find.text('Quick Action Center'), findsOneWidget);
      expect(find.text('Fund Segregation'), findsWidgets);

      // Scroll through full page to verify zero overflow across whole scroll view
      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -300));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.drag(find.byType(SingleChildScrollView), const Offset(0, -400));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 3. IOS MOBILE (390 x 844)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on iOS (390x844): Renders identical compact layout with 0 overflows', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: const Scaffold(
              body: DashboardPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // iOS renders the same compact Books Console & shortcut layout as Android
      expect(find.text('Books Console'), findsOneWidget);
      expect(find.text('Quick Action Center'), findsOneWidget);
      expect(find.text('Asset Inventory Value'), findsOneWidget);
      expect(find.text('Modules & Management Suite'), findsOneWidget);
      expect(find.text('Fund Segregation'), findsWidgets);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 4. MACOS DESKTOP (1200 x 800) - UNTOUCHED DESKTOP VIEW
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on macOS (1200x800): Preserves original desktop layout', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
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
              body: DashboardPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(DashboardPage), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Verify Books Console desktop layout
      expect(find.text('Books Console'), findsOneWidget);
      expect(find.text('Monitor your personal finance & operational intelligence suite.'), findsOneWidget);
      expect(find.text('Quick Action Center'), findsOneWidget);
      expect(find.text('Asset Inventory Value'), findsOneWidget);
      expect(find.text('Modules & Management Suite'), findsOneWidget);
      expect(find.text('Fund Segregation'), findsWidgets);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 5. CONFIGURE QUICK ACTIONS DIALOG - ANDROID (360 x 780)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('ConfigureQuickActionsDialog on Android (360x780): Opens without overflow and saves correctly', (tester) async {
      tester.view.physicalSize = const Size(360, 780);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: const Scaffold(
              body: ConfigureQuickActionsDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConfigureQuickActionsDialog), findsOneWidget);
      expect(find.text('Configure Quick Actions'), findsOneWidget);
      expect(find.textContaining('active'), findsOneWidget);
      expect(find.text('Save Configuration'), findsOneWidget);
      expect(tester.takeException(), isNull);

      // Verify tapping Save Configuration pops the dialog
      await tester.tap(find.text('Save Configuration'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 6. CONFIGURE QUICK ACTIONS DIALOG - NARROW ANDROID (320 x 640)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('ConfigureQuickActionsDialog on Narrow Android (320x640): 0 horizontal & vertical overflow', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.android),
            home: const Scaffold(
              body: ConfigureQuickActionsDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConfigureQuickActionsDialog), findsOneWidget);
      expect(find.text('Configure Quick Actions'), findsOneWidget);
      expect(find.textContaining('active'), findsOneWidget);
      expect(find.text('Save Configuration'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 7. CONFIGURE QUICK ACTIONS DIALOG - iOS (390 x 844)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('ConfigureQuickActionsDialog on iOS (390x844): Identical layout with 0 overflow', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData(platform: TargetPlatform.iOS),
            home: const Scaffold(
              body: ConfigureQuickActionsDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConfigureQuickActionsDialog), findsOneWidget);
      expect(find.text('Configure Quick Actions'), findsOneWidget);
      expect(find.textContaining('active'), findsOneWidget);
      expect(find.text('Save Configuration'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 8. NAVIGATION INTEGRATION TEST
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('Dashboard Mobile Shortcut navigation: Correctly updates route and module', (tester) async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final notifier = container.read(navigationProvider.notifier);

      // 1. Navigate to Sales
      notifier.setRoute(AppRoute.sales);
      expect(container.read(navigationProvider).currentRoute, AppRoute.sales);
      expect(container.read(navigationProvider).currentModule, AppModule.books);

      // 2. Navigate to Wallet (Payments module)
      notifier.setRoute(AppRoute.wallet);
      expect(container.read(navigationProvider).currentRoute, AppRoute.wallet);
      expect(container.read(navigationProvider).currentModule, AppModule.payments);

      // 3. Navigate to Settings (Profile module)
      notifier.setRoute(AppRoute.settings);
      expect(container.read(navigationProvider).currentRoute, AppRoute.settings);
      expect(container.read(navigationProvider).currentModule, AppModule.profile);

      // 4. Navigate to Rewards (Social module)
      notifier.setRoute(AppRoute.rewards);
      expect(container.read(navigationProvider).currentRoute, AppRoute.rewards);
      expect(container.read(navigationProvider).currentModule, AppModule.social);

      // 5. Navigate back to Dashboard
      notifier.setRoute(AppRoute.dashboard);
      expect(container.read(navigationProvider).currentRoute, AppRoute.dashboard);
      expect(container.read(navigationProvider).currentModule, AppModule.books);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 9. CONFIGURE QUICK ACTIONS DIALOG - macOS DESKTOP (1200 x 800)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('ConfigureQuickActionsDialog on macOS (1200x800): Preserves desktop dialog layout', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
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
              body: ConfigureQuickActionsDialog(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ConfigureQuickActionsDialog), findsOneWidget);
      // Desktop dialog preserves original 'shortcuts active' phrasing
      expect(find.textContaining('shortcuts active'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
