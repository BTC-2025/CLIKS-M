import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppColors {
  // ─── Core Exported Palette ───
  static const Color primaryGreen = Color(0xFF0F5B2E);
  static const Color darkGreen = Color(0xFF084421);
  static const Color accentGreen = Color(0xFF1F7A46);
  static const Color success = Color(0xFF27AE60);

  static const Color background = Color(0xFFF5F7F9);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE6EBEF);

  static const Color darkText = Color(0xFF132238);
  static const Color secondaryText = Color(0xFF6B7280);

  static const Color blue = Color(0xFF0D5BD7);
  static const Color purpleAccent = Color(0xFF7B61FF);
  static const Color red = Color(0xFFE74C3C);
  static const Color yellow = Color(0xFFF2C94C);

  static const Color hoverBackground = Color(0xFFEEF7F0);
  static const Color sidebarBackground = Color(0xFFEAF6EC);

  // ─── Brand & Header Aliases ───
  static const Color headerBackground = Color(0xFF0F5B2E);
  static const Color deepGreen = Color(0xFF084421);
  static const Color primaryText = primaryGreen;
  static const Color scaffoldBackground = background;
  static const Color backgroundLightGreen = sidebarBackground;
  static const Color lightGreenBackground = sidebarBackground;

  // ─── Surface & Slate Aliases ───
  static const Color surface = cardBackground;
  static const Color surfaceWhite = cardBackground;
  static const Color footerArea = cardBackground;
  static const Color secondaryArea = cardBackground;
  static const Color white = Colors.white;

  static const Color textSlateDark = darkText;
  static const Color textSlateSecondary = secondaryText;

  static const Color borderSlate = border;
  static const Color defaultBorder = border;
  static const Color tableBorder = border;

  static const Color borderGreenLight = Color(0xFFD6EFE0);
  static const Color borderGreen = Color(0xFFD0ECDB);
  static const Color accentLightGreen = Color(0xFFD6EFE0);
  static const Color accentLightBlue = Color(0xFFEFF6FF);
  static const Color accentDarkNavy = Color(0xFF0B1329);
  static const Color actionBlue = blue;
  static const Color contrastText = Colors.white;

  // macOS-specific palette tokens
  static const Color macosDarkGreen = darkGreen;
  static const Color macosLightGreen = Color(0xFFD6EFE0);

  static bool get isMacOS => !kIsWeb && defaultTargetPlatform == TargetPlatform.macOS;

  /// Returns stylish dark green on macOS
  static Color get stylishDarkGreen => isMacOS ? macosDarkGreen : primaryGreen;

  /// Returns light green highlight on macOS
  static Color get lightGreenHighlight => isMacOS ? macosLightGreen : accentLightGreen;

  /// Colors for statistics hero cards across sections
  static List<Color> get heroGradientColors => const [primaryGreen, darkGreen];

  /// Shadow color for statistics hero cards across sections
  static Color get heroShadowColor => primaryGreen.withValues(alpha: 0.25);
}
