import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// AppPalette — Raw Tokyo-inspired theme colors.
// Source references:
// - PureLightTheme.ts
// - NebulaFighterTheme.ts
// Colors stay centralized here, then map into Material 3 roles elsewhere.
// ---------------------------------------------------------------------------
@immutable
abstract final class AppPalette {
  // ── Light primary: Royal Blue #5569FF ───────────────────────────────────
  static const Color primary10 = Color(0xFF00114F);
  static const Color primary20 = Color(0xFF192B82);
  static const Color primary30 = Color(0xFF3345B8);
  static const Color primary40 = Color(0xFF5569FF);
  static const Color primary70 = Color(0xFFA3B0FF);
  static const Color primary80 = Color(0xFFC3CBFF);
  static const Color primary90 = Color(0xFFE1E6FF);
  static const Color primary95 = Color(0xFFF0F3FF);
  static const Color primary99 = Color(0xFFFBFCFF);

  // ── Light secondary: Slate Indigo #6E759F ───────────────────────────────
  static const Color secondary10 = Color(0xFF171A33);
  static const Color secondary20 = Color(0xFF2D3354);
  static const Color secondary30 = Color(0xFF444A74);
  static const Color secondary40 = Color(0xFF6E759F);
  static const Color secondary70 = Color(0xFFA1A8CA);
  static const Color secondary80 = Color(0xFFC0C6E0);
  static const Color secondary90 = Color(0xFFE0E4F4);
  static const Color secondary95 = Color(0xFFF0F2FA);
  static const Color secondary99 = Color(0xFFFBFBFF);

  // ── Tertiary accent: Deep Navy #242E6F ──────────────────────────────────
  static const Color tertiary10 = Color(0xFF0A1031);
  static const Color tertiary20 = Color(0xFF151F45);
  static const Color tertiary30 = Color(0xFF1C2658);
  static const Color tertiary40 = Color(0xFF242E6F);
  static const Color tertiary70 = Color(0xFF8F99D9);
  static const Color tertiary80 = Color(0xFFB4BEF2);
  static const Color tertiary90 = Color(0xFFDDE2FF);
  static const Color tertiary95 = Color(0xFFF0F2FF);
  static const Color tertiary99 = Color(0xFFFCFCFF);

  // ── Dark primary: Nebula Violet #8C7CF0 ─────────────────────────────────
  static const Color violet10 = Color(0xFF1A1242);
  static const Color violet20 = Color(0xFF2F2366);
  static const Color violet30 = Color(0xFF4B3992);
  static const Color violet40 = Color(0xFF8C7CF0);
  static const Color violet70 = Color(0xFFC1B7FF);
  static const Color violet80 = Color(0xFFD8D1FF);
  static const Color violet90 = Color(0xFFEEE9FF);
  static const Color violet95 = Color(0xFFF7F4FF);

  // ── Surface family: Midnight Navy ───────────────────────────────────────
  static const Color midnight10 = Color(0xFF070C27);
  static const Color midnight20 = Color(0xFF111633);
  static const Color midnight30 = Color(0xFF171D3D);
  static const Color midnight40 = Color(0xFF242C48);
  static const Color midnight50 = Color(0xFF2B304D);
  static const Color midnight60 = Color(0xFF3D4365);
  static const Color midnight70 = Color(0xFF6A7199);
  static const Color midnight80 = Color(0xFF9EA4C1);
  static const Color midnight90 = Color(0xFFCBCCD2);
  static const Color midnight95 = Color(0xFFE8EAF2);

  // ── Neutral family for light surfaces and text ──────────────────────────
  static const Color neutral0 = Color(0xFF000000);
  static const Color neutral10 = Color(0xFF151A2A);
  static const Color neutral20 = Color(0xFF223354);
  static const Color neutral30 = Color(0xFF334361);
  static const Color neutral40 = Color(0xFF4A5573);
  static const Color neutral70 = Color(0xFF7E89A2);
  static const Color neutral80 = Color(0xFFA1A9BB);
  static const Color neutral90 = Color(0xFFD4DAE7);
  static const Color neutral95 = Color(0xFFF2F5F9);
  static const Color neutral98 = Color(0xFFF8FAFD);
  static const Color neutral99 = Color(0xFFFFFFFF);
  static const Color neutral100 = Color(0xFFFFFFFF);

  // ── Error #FF1943 ───────────────────────────────────────────────────────
  static const Color error10 = Color(0xFF41000F);
  static const Color error20 = Color(0xFF69001A);
  static const Color error30 = Color(0xFF930028);
  static const Color error40 = Color(0xFFFF1943);
  static const Color error80 = Color(0xFFFF9AB0);
  static const Color error90 = Color(0xFFFFD9E0);

  // ── Success #57CA22 ─────────────────────────────────────────────────────
  static const Color success10 = Color(0xFF062100);
  static const Color success20 = Color(0xFF113A00);
  static const Color success30 = Color(0xFF1F5A00);
  static const Color success40 = Color(0xFF57CA22);
  static const Color success80 = Color(0xFF96F36D);
  static const Color success90 = Color(0xFFCFF6BF);

  // ── Warning #FFA319 ─────────────────────────────────────────────────────
  static const Color warning10 = Color(0xFF2A1600);
  static const Color warning20 = Color(0xFF4A2800);
  static const Color warning30 = Color(0xFF6D3D00);
  static const Color warning40 = Color(0xFFFFA319);
  static const Color warning80 = Color(0xFFFFD08C);
  static const Color warning90 = Color(0xFFFFE6C2);

  // ── Info #33C2FF ────────────────────────────────────────────────────────
  static const Color info10 = Color(0xFF001B28);
  static const Color info20 = Color(0xFF003149);
  static const Color info30 = Color(0xFF004A69);
  static const Color info40 = Color(0xFF33C2FF);
  static const Color info80 = Color(0xFF7EDCFF);
  static const Color info90 = Color(0xFFC5F0FF);
}
