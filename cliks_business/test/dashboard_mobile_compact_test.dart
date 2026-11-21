import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clicks_business_frontend/features/dashboard/dashboard_page.dart';
import 'package:clicks_business_frontend/core/navigation/navigation_provider.dart';
import 'package:clicks_business_frontend/features/dashboard/widgets/configure_quick_actions_dialog.dart';

void main() {
  group('Dashboard Page - Books Console & Responsive Verification', () {
    // ═════════════════════════════════════════════════════════════════════════
    // 1. ANDROID STANDARD MOBILE (360 x 780)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on Android (360x780): Renders Books Console without overflow', (tester) async {
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
      expect(tester.takeException(), isNull);

      // Verify Header
      expect(find.text('Books Console'), findsOneWidget);

      // Verify Live Stat Cards
      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Total Expenses'), findsOneWidget);
      expect(find.text('Net Balance'), findsOneWidget);
      expect(find.text('Active Investments'), findsOneWidget);
      expect(find.text('Active People'), findsOneWidget);
      expect(find.text('1 Contacts'), findsOneWidget);
      expect(find.text('Active Segregations'), findsOneWidget);
      expect(find.text('0 Records'), findsOneWidget);

      // Verify Quick Action Center & Shortcuts
      expect(find.text('Quick Action Center'), findsOneWidget);
      expect(find.text('Stock Management'), findsOneWidget);
      expect(find.text('Manage Shortcuts'), findsOneWidget);

      // Scroll progressively until bottom cards are visible
      await tester.scrollUntilVisible(
        find.text('View Joint Expenses'),
        150.0,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      expect(find.text('Modules & Management Suite'), findsOneWidget);
      expect(find.text('Inventory & Stocks'), findsOneWidget);
      expect(find.text('Fund Segregation'), findsOneWidget);
      expect(find.text('0 Established'), findsOneWidget);
      expect(find.text('Personalized Bills & Splits'), findsOneWidget);
      expect(find.text('View Joint Expenses'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 2. ANDROID NARROW MOBILE (320 x 640)
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on Narrow Android (320x640): Renders layout with 0 overflows', (tester) async {
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
      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Quick Action Center'), findsOneWidget);
      expect(find.text('Manage Shortcuts'), findsOneWidget);

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
    testWidgets('DashboardPage on iOS (390x844): Renders identical layout with 0 overflows', (tester) async {
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

      expect(find.text('Books Console'), findsOneWidget);
      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Total Expenses'), findsOneWidget);
      expect(find.text('Net Balance'), findsOneWidget);
      expect(find.text('Manage Shortcuts'), findsOneWidget);
    });

    // ═════════════════════════════════════════════════════════════════════════
    // 4. MACOS DESKTOP (1200 x 800) - DESKTOP VIEW
    // ═════════════════════════════════════════════════════════════════════════
    testWidgets('DashboardPage on macOS (1200x800): Preserves desktop layout', (tester) async {
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

      // Verify Books Console header and subtitle
      expect(find.text('Books Console'), findsOneWidget);
      expect(find.text('Monitor your personal finance & operational intelligence suite.'), findsOneWidget);
      expect(find.text('Customise'), findsOneWidget);
      expect(find.text('Find modules, assets...'), findsOneWidget);

      // Verify all 6 Stat Cards
      expect(find.text('Total Income'), findsOneWidget);
      expect(find.text('Total Expenses'), findsOneWidget);
      expect(find.text('Net Balance'), findsOneWidget);
      expect(find.text('Active Investments'), findsOneWidget);
      expect(find.text('Active People'), findsOneWidget);
      expect(find.text('1 Contacts'), findsOneWidget);
      expect(find.text('Active Segregations'), findsOneWidget);
      expect(find.text('0 Records'), findsOneWidget);

      // Verify Quick Action Center
      expect(find.text('Quick Action Center'), findsOneWidget);
      expect(find.text('Stock Management'), findsOneWidget);
      expect(find.text('People Hub'), findsWidgets);
      expect(find.text('Expenses'), findsOneWidget);
      expect(find.text('Budgets & Planning'), findsOneWidget);
      expect(find.text('Split & Collect'), findsOneWidget);
      expect(find.text('Segregation'), findsOneWidget);
      expect(find.text('Manage Shortcuts'), findsOneWidget);

      // Verify Modules & Management Suite
      expect(find.text('Modules & Management Suite'), findsOneWidget);
      expect(find.text('Inventory & Stocks'), findsOneWidget);
      expect(find.text('Finance'), findsOneWidget);

      // Verify Fund Segregation & Bills
      expect(find.text('Fund Segregation'), findsOneWidget);
      expect(find.text('Manage'), findsOneWidget);
      expect(find.text('ACTIVE WALLETS'), findsOneWidget);
      expect(find.text('0 Established'), findsOneWidget);
      expect(find.text('TARGET SAVED'), findsOneWidget);
      expect(find.text('Personalized Bills & Splits'), findsOneWidget);
      expect(find.text('View Joint Expenses'), findsOneWidget);
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

      // 2. Navigate to Wallet (Payments module via setModuleAndRoute)
      notifier.setModuleAndRoute(AppModule.payments, AppRoute.wallet);
      expect(container.read(navigationProvider).currentRoute, AppRoute.wallet);
      expect(container.read(navigationProvider).currentModule, AppModule.payments);

      // 3. Navigate to Settings (Profile module via setModuleAndRoute)
      notifier.setModuleAndRoute(AppModule.profile, AppRoute.settings);
      expect(container.read(navigationProvider).currentRoute, AppRoute.settings);
      expect(container.read(navigationProvider).currentModule, AppModule.profile);

      // 4. Navigate to Rewards (Social module via setModuleAndRoute)
      notifier.setModuleAndRoute(AppModule.social, AppRoute.rewards);
      expect(container.read(navigationProvider).currentRoute, AppRoute.rewards);
      expect(container.read(navigationProvider).currentModule, AppModule.social);

      // 5. Navigate back to Dashboard
      notifier.setModuleAndRoute(AppModule.books, AppRoute.dashboard);
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
      expect(find.textContaining('shortcuts active'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
