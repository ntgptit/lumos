import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// AppPalette — Raw brand color tokens (Ocean Depth)
// Source palette: Cadet Blue → Independence → Charcoal → Gunmetal → Eigengrau
// All tonal values derived from the 5 seed colors using M3 tonal convention:
//   10 = very dark, 20 = dark, 30, 40 = base, 70, 80 = light, 90 = container, 95, 99 = near-white
// ---------------------------------------------------------------------------
@immutable
abstract final class AppPalette {
  // ── Cadet Blue #6A7E84 ──────────────────────────────────────────────────
  static const Color cadetBlue10 = Color(0xFF0D1E22);
  static const Color cadetBlue20 = Color(0xFF1E3840);
  static const Color cadetBlue30 = Color(0xFF2E525C);
  static const Color cadetBlue40 = Color(0xFF4A6870); // adjusted base
  static const Color cadetBlue70 = Color(0xFF94AEB4);
  static const Color cadetBlue80 = Color(0xFFB0C6CC);
  static const Color cadetBlue90 = Color(0xFFC8D8DC);
  static const Color cadetBlue95 = Color(0xFFE0EAEC);
  static const Color cadetBlue99 = Color(0xFFF4F8F9);

  // ── Independence #4D5D6D ────────────────────────────────────────────────
  static const Color independence10 = Color(0xFF0D1520);
  static const Color independence20 = Color(0xFF1E2A38);
  static const Color independence30 = Color(0xFF2E3F50);
  static const Color independence40 = Color(0xFF4D5D6D); // base
  static const Color independence70 = Color(0xFF8090A0);
  static const Color independence80 = Color(0xFF9AAAB8);
  static const Color independence90 = Color(0xFFBCC8D4);
  static const Color independence95 = Color(0xFFD6DFE8);
  static const Color independence99 = Color(0xFFF2F5F8);

  // ── Charcoal #36454F ────────────────────────────────────────────────────
  static const Color charcoal10 = Color(0xFF080F14);
  static const Color charcoal20 = Color(0xFF1A2830);
  static const Color charcoal30 = Color(0xFF263540);
  static const Color charcoal40 = Color(0xFF36454F); // base
  static const Color charcoal70 = Color(0xFF6A8090);
  static const Color charcoal80 = Color(0xFF8A9EAC);
  static const Color charcoal90 = Color(0xFFA8B8C4);
  static const Color charcoal95 = Color(0xFFCCD8E0);
  static const Color charcoal99 = Color(0xFFEFF4F6);

  // ── Gunmetal #2C3539 ────────────────────────────────────────────────────
  static const Color gunmetal10 = Color(0xFF060C10);
  static const Color gunmetal20 = Color(0xFF1A2226);
  static const Color gunmetal30 = Color(0xFF242E32);
  static const Color gunmetal40 = Color(0xFF2C3539); // base
  static const Color gunmetal70 = Color(0xFF5A6E78);
  static const Color gunmetal80 = Color(0xFF7A8E98);
  static const Color gunmetal90 = Color(0xFF9AAAB4);
  static const Color gunmetal95 = Color(0xFFBECCD4);
  static const Color gunmetal99 = Color(0xFFECF0F2);

  // ── Eigengrau #16161D ───────────────────────────────────────────────────
  static const Color eigengrau10 = Color(0xFF16161D); // base (very dark)
  static const Color eigengrau20 = Color(0xFF1E1E28);
  static const Color eigengrau30 = Color(0xFF28283A);
  static const Color eigengrau40 = Color(0xFF383848);

  // ── Neutral (derived from Eigengrau/Gunmetal blend) ─────────────────────
  static const Color neutral10 = Color(0xFF14181C);
  static const Color neutral20 = Color(0xFF1E2428);
  static const Color neutral30 = Color(0xFF2A3238);
  static const Color neutral40 = Color(0xFF3C4850);
  static const Color neutral70 = Color(0xFF8090A0);
  static const Color neutral80 = Color(0xFFA0AEB8);
  static const Color neutral90 = Color(0xFFBCC8D4);
  static const Color neutral92 = Color(0xFFCDD7E0);
  static const Color neutral95 = Color(0xFFD8E0E8);
  static const Color neutral97 = Color(0xFFE8EEF2);
  static const Color neutral99 = Color(0xFFF4F6F8);

  // ── Primary tonal scale (anchored to Cadet Blue #6A7E84) ────────────────
  static const Color primary10 = Color(0xFF0A1A20);
  static const Color primary20 = Color(0xFF1A3040);
  static const Color primary30 = Color(0xFF2A4858);
  static const Color primary40 = Color(
    0xFF6A7E84,
  ); // = Cadet Blue (brand primary)
  static const Color primary70 = Color(0xFF94AEB4);
  static const Color primary80 = Color(0xFFB0C6CC);
  static const Color primary90 = Color(0xFFC8D8DC); // primaryContainer light
  static const Color primary95 = Color(0xFFE0EAEC);
  static const Color primary99 = Color(0xFFF4F8F9);

  // ── Secondary tonal scale (anchored to Independence #4D5D6D) ────────────
  static const Color secondary10 = Color(0xFF0A1420);
  static const Color secondary20 = Color(0xFF1A2838);
  static const Color secondary30 = Color(0xFF2A3C50);
  static const Color secondary40 = Color(
    0xFF4D5D6D,
  ); // = Independence (brand secondary)
  static const Color secondary70 = Color(0xFF8090A0);
  static const Color secondary80 = Color(0xFF9AAAB8);
  static const Color secondary90 = Color(
    0xFFBCC8D4,
  ); // secondaryContainer light
  static const Color secondary95 = Color(0xFFD6DFE8);
  static const Color secondary99 = Color(0xFFF2F5F8);

  // ── Tertiary tonal scale (anchored to Charcoal #36454F) ─────────────────
  static const Color tertiary10 = Color(0xFF080E14);
  static const Color tertiary20 = Color(0xFF182430);
  static const Color tertiary30 = Color(0xFF263540);
  static const Color tertiary40 = Color(
    0xFF36454F,
  ); // = Charcoal (brand tertiary)
  static const Color tertiary70 = Color(0xFF6A8090);
  static const Color tertiary80 = Color(0xFF8A9EAC);
  static const Color tertiary90 = Color(0xFFA8B8C4); // tertiaryContainer light
  static const Color tertiary95 = Color(0xFFCCD8E0);
  static const Color tertiary99 = Color(0xFFEFF4F6);

  // ── Dark theme specifics ─────────────────────────────────────────────────
  // Elevated primary/secondary for dark surfaces (must contrast on dark bg)
  static const Color darkPrimary80 = Color(0xFFB0C6CC); // light cadet blue tone
  static const Color darkSecondary70 = Color(
    0xFF8090A0,
  ); // light independence tone

  // ── Error scale ──────────────────────────────────────────────────────────
  static const Color error40 = Color(0xFFBA1A1A);
  static const Color error90 = Color(0xFFFFDAD6);

  // ── Success — Teal Green (harmonized with Ocean Depth cool tones) ─────────
  // Seed: #2E7D6A
  static const Color success10 = Color(0xFF00201A);
  static const Color success20 = Color(0xFF00382E);
  static const Color success30 = Color(0xFF005143);
  static const Color success40 = Color(0xFF2E7D6A); // base
  static const Color success70 = Color(0xFF52B09A);
  static const Color success80 = Color(0xFF74CBB4);
  static const Color success90 = Color(0xFFB0E8DA); // container
  static const Color success95 = Color(0xFFD4F5EE);
  static const Color success99 = Color(0xFFF2FFFB);

  // ── Warning — Amber (warm anchor, sufficient contrast on dark surfaces) ───
  // Seed: #B06000
  static const Color warning10 = Color(0xFF221200);
  static const Color warning20 = Color(0xFF3D2200);
  static const Color warning30 = Color(0xFF5C3500);
  static const Color warning40 = Color(0xFFB06000); // base
  static const Color warning70 = Color(0xFFE8953A);
  static const Color warning80 = Color(0xFFFFB870);
  static const Color warning90 = Color(0xFFFFDDB8); // container
  static const Color warning95 = Color(0xFFFFEEDA);
  static const Color warning99 = Color(0xFFFFF8F3);

  // ── Info — Steel Blue (blends naturally with primary cool-blue palette) ───
  // Seed: #1A6080
  static const Color info10 = Color(0xFF001828);
  static const Color info20 = Color(0xFF003048);
  static const Color info30 = Color(0xFF004A6A);
  static const Color info40 = Color(0xFF1A6080); // base
  static const Color info70 = Color(0xFF4A9EC0);
  static const Color info80 = Color(0xFF78BCD8);
  static const Color info90 = Color(0xFFBCDEF0); // container
  static const Color info95 = Color(0xFFDCEFF8);
  static const Color info99 = Color(0xFFF2F9FD);
}
