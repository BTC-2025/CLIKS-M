import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clicks_business_frontend/core/navigation/navigation_provider.dart';
import 'package:clicks_business_frontend/features/payments/pages/cash_flow_heatmap_page.dart';
import 'package:clicks_business_frontend/features/social/pages/trading_docs_page.dart';

void main() {
  group('Trading Docs Navigation Tests', () {
    test('Navigating to tradingDocs correctly sets AppModule.social', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final navNotifier = container.read(navigationProvider.notifier);
      navNotifier.setRoute(AppRoute.tradingDocs);

      final state = container.read(navigationProvider);
      expect(state.currentRoute, AppRoute.tradingDocs);
      expect(state.currentModule, AppModule.social);
    });

    test('Navigating to social routes maintains AppModule.social', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final navNotifier = container.read(navigationProvider.notifier);
      navNotifier.setRoute(AppRoute.betaClub);
      expect(container.read(navigationProvider).currentModule, AppModule.social);

      navNotifier.setRoute(AppRoute.tradingDocs);
      expect(container.read(navigationProvider).currentModule, AppModule.social);

      navNotifier.setRoute(AppRoute.referral);
      expect(container.read(navigationProvider).currentModule, AppModule.social);
    });

    testWidgets('TradingDocsPage renders without errors', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1200, 900));
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TradingDocsPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(TradingDocsPage), findsOneWidget);
    });
  });

  group('Cash Flow Heatmap RenderFlex Overflow Tests', () {
    testWidgets('CashFlowHeatmapPage bar chart does not overflow on narrow mobile or desktop', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1066, 800));
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CashFlowHeatmapPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });

    testWidgets('CashFlowHeatmapPage does not overflow on 360px mobile', (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: CashFlowHeatmapPage(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
