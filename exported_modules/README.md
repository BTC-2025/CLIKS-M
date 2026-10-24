# Standalone Exported Modules

This package contains complete, self-contained, end-to-end Flutter UI screens and components exported from the **CLIKS-M** project, pre-configured with all necessary shared theme tokens, UI kits, and navigation providers.

---

## 📁 Directory Structure

```text
exported_modules/
├── books/
│   ├── money_tracker_page.dart    # Books: Money Tracker / Track Console
│   ├── goal_buckets_page.dart     # Books: Goal Buckets & Savings/Debt Planner
│   ├── documents_page.dart        # Books: Documents, Invoices & Vault
│   └── dashboard_page.dart        # Books: Core Financial Dashboard Console
├── payments/
│   └── cash_flow_heatmap_page.dart # Payments: Cashflow Heatmap & Daily Spend Intensity
├── subscription/
│   ├── subscription_page.dart     # Subscription: Tier Plans & Pricing Table
│   ├── subscription_vault_page.dart # Subscription: Active Subscriptions & Recurring Bills Vault
│   └── pricing_card.dart          # Subscription: Reusable Pricing Card Component
└── shared/
    ├── navigation/
    │   └── navigation_provider.dart # Riverpod Module & Route State Manager
    ├── theme/
    │   ├── app_colors.dart         # Color Palette & Tokens
    │   ├── app_radius.dart         # Border Radii
    │   ├── app_spacing.dart        # Spacing Grid Constants
    │   ├── app_theme.dart          # Global ThemeData Configuration
    │   ├── dimensions.dart         # Breakpoints & Layout Dimensions
    │   └── text_styles.dart        # Typography & Font Presets
    └── widgets/
        ├── app_ui_kit.dart         # AppCard, AppButton, AppBadge, AppSnackbar, etc.
        └── request_document_dialog.dart # Document Request Modal
```

---

## 📦 Required Dependencies

Add the following dependencies to your destination project's `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & Utilities
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # UI, Icons, Animations & Effects
  flutter_animate: ^4.5.0
  lucide_icons_flutter: ^3.1.14+2
  google_fonts: ^6.1.0
  shimmer: ^3.0.0
```

After updating `pubspec.yaml`, run:
```bash
flutter pub get
```

---

## 🚀 How to Integrate into Another Project

### Step 1: Copy Folder
Copy the `exported_modules/` folder into your new project's `lib/` directory (e.g., `lib/exported_modules/` or directly under `lib/features/`).

### Step 2: Ensure Riverpod ProviderScope is Initialized
If using `DashboardPage`, ensure your `main.dart` wraps the app in a `ProviderScope`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}
```

### Step 3: Use the Pages

You can directly push or route to any of the pages:

```dart
// 1. Books - Money Tracker
Navigator.push(context, MaterialPageRoute(builder: (_) => const MoneyTrackerPage()));

// 2. Books - Goal Buckets
Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalBucketsPage()));

// 3. Books - Documents
Navigator.push(context, MaterialPageRoute(builder: (_) => const DocumentsPage()));

// 4. Books - Dashboard
Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardPage()));

// 5. Payments - Cash Flow Heatmap
Navigator.push(context, MaterialPageRoute(builder: (_) => const CashFlowHeatmapPage()));

// 6. Subscription - Plans & Tiers
Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionPage()));

// 7. Subscription - Vault
Navigator.push(context, MaterialPageRoute(builder: (_) => const SubscriptionVaultPage()));
```
