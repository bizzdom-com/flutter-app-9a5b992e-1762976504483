import 'package:flutter/material.dart';

/// Centralized brand color configuration derived from template placeholders.
///
/// Base hues (primary, secondary, accent, neutral) can be replaced during
/// templating. The remaining tones are generated from those bases so only a
/// handful of values need to change per branded build.
class BrandColors {
  BrandColors._();

  // --- Base brand hues (templated) ---
  static const Color primary = Color(0xFF812A83);
  static const Color secondary = Color(0xFF03DD50);
  static const Color accent = Color(0xFF03DD50);
  static const Color neutralBase = Color(0xFF0A0A0F);
  static const Color neutralVariantBase = Color(0xFF15151E);

  // --- Optional overrides for semantic states ---
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF00C2FF);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFFA0A0B5);

  // --- Derived structural tones ---
  static final Color scaffold = _lighten(neutralBase, 0.02);
  static final Color background = _lighten(neutralBase, 0.05);
  static final Color backgroundAlt = _blend(neutralBase, accent, 0.08);
  static final Color surface = _lighten(neutralVariantBase, 0.08);
  static final Color surfaceAlt = _lighten(neutralVariantBase, 0.14);
  static final Color surfaceMuted = _blend(neutralVariantBase, primary, 0.05);
  static final Color surfaceElevated = _blend(neutralVariantBase, Colors.white, 0.18);
  static final Color surfaceOverlay = _blend(neutralBase, primary, 0.06);
  static final Color border = _lighten(neutralBase, 0.13);
  static final Color divider = _lighten(neutralBase, 0.18);
  static final Color outline = _lighten(neutralBase, 0.24);

  // --- Derived brand accents ---
  static final Color primaryBright = _lighten(primary, 0.14);
  static final Color primaryDeep = _blend(primary, Colors.black, 0.15);
  static final Color primarySoft = primary.withOpacity(0.15);
  static final Color primaryBorder = primary.withOpacity(0.35);

  static final Color secondaryBright = _lighten(secondary, 0.12);
  static final Color secondaryDark = _blend(secondary, Colors.black, 0.16);
  static final Color secondarySoft = secondary.withOpacity(0.16);
  static final Color secondaryBorder = secondary.withOpacity(0.32);

  static final Color accentBright = _lighten(accent, 0.18);
  static final Color accentDeep = _blend(accent, primary, 0.28);
  static final Color accentSoft = accent.withOpacity(0.18);
  static final Color accentBorder = accent.withOpacity(0.28);

  static final Color successBright = _lighten(success, 0.18);
  static final Color successDeep = _blend(success, Colors.black, 0.18);
  static final Color successSoft = success.withOpacity(0.16);

  static final Color warningBright = _lighten(warning, 0.18);
  static final Color warningGlow = _lighten(warning, 0.28);
  static final Color warningSoft = warning.withOpacity(0.16);

  static final Color errorBright = _lighten(error, 0.16);
  static final Color errorDeep = _blend(error, Colors.black, 0.22);
  static final Color errorContainer = _blend(error, neutralBase, 0.18);
  static final Color errorTint = _lighten(error, 0.45);
  static final Color errorSoft = error.withOpacity(0.16);

  static final Color infoBright = _lighten(info, 0.14);
  static final Color infoDeep = _blend(info, primary, 0.22);
  static final Color infoSoft = info.withOpacity(0.16);
  static final Color infoMuted = _blend(info, neutralBase, 0.12);

  static final Color pink = _blend(error, Colors.pinkAccent, 0.35);
  static final Color pinkDeep = _blend(error, Colors.pinkAccent, 0.55);
  static final Color gold = _lighten(warning, 0.22);
  static final Color neutralHighlight = _blend(neutralVariantBase, accent, 0.12);
  static final Color mutedSlate = _blend(neutralVariantBase, Colors.white, 0.25);

  static final LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryBright],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient secondaryGradient = LinearGradient(
    colors: [secondary, secondaryBright],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static final LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentBright],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static Color _lighten(Color color, double amount) {
    return Color.lerp(color, Colors.white, amount.clamp(0.0, 1.0)) ?? color;
  }

  static Color _blend(Color base, Color blend, double amount) {
    return Color.lerp(base, blend, amount.clamp(0.0, 1.0)) ?? base;
  }
}
