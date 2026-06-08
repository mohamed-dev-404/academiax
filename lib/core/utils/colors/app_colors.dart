import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  //! ───────────────────────── Primary ─────────────────────────

  static const Color primaryLight = Color(0xFFE6F3F6);
  static const Color primaryLightHover = Color(0xFFD9EDF1);
  static const Color primaryLightActive = Color(0xFFBEE2E8);

  static const Color primary = Color(0xFF0087A2);
  static const Color primaryHover = Color(0xFF007A92);
  static const Color primaryActive = Color(0xFF006C82);

  static const Color primaryDark = Color(0xFF00557A);
  static const Color primaryDarkHover = Color(0xFF005161);
  static const Color primaryDarkActive = Color(0xFF003D49);
  static const Color primaryDarker = Color(0xFF002F39);

  //! ───────────────────────── Secondary ─────────────────────────

  static const Color secondaryLight = Color(0xFFF8FFFD);
  static const Color secondaryLightHover = Color(0xFFDCF0EF);
  static const Color secondaryLightActive = Color(0xFFBEE6DE);

  static const Color secondary = Color(0xFF13AE94);
  static const Color secondaryHover = Color(0xFF119B85);
  static const Color secondaryActive = Color(0xFF0F8B78);

  static const Color secondaryDark = Color(0xFF0E836F);
  static const Color secondaryDarkHover = Color(0xFF0B6E59);
  static const Color secondaryDarkActive = Color(0xFF094C43);
  static const Color secondaryDarker = Color(0xFF073D34);

  //! ───────────────────────── White / Neutral ─────────────────────────

  static const Color whiteLight = Color(0xFFFEFEFE);
  static const Color white = Color(0xFFF5F7F9);
  static const Color whiteHover = Color(0xFFDDDEE0);
  static const Color whiteActive = Color(0xFFC4C6C7);
  static const Color whiteDark = Color(0xFFB8BBBD);
  static const Color whiteDarkHover = Color(0xFF939495);
  static const Color whiteDarkActive = Color(0xFF6E6F70);
  static const Color whiteDarker = Color(0xFF565657);

  //! ───────────────────────── Black ─────────────────────────

  static const Color blackLight = Color(0xFFE6E6E6);
  static const Color blackLightHover = Color(0xFFD9D9D9);
  static const Color blackLightActive = Color(0xFFB0B0B0);

  static const Color black = Color(0xFF000000);
  static const Color blackHover = Color(0xFF000000);
  static const Color blackActive = Color(0xFF000000);
  static const Color blackDark = Color(0xFF000000);
  static const Color blackDarkHover = Color(0xFF000000);
  static const Color blackDarkActive = Color(0xFF000000);
  static const Color blackDarker = Color(0xFF000000);

  //! ───────────────────────── Red (Error) ─────────────────────────

  static const Color redLight = Color(0xFFF9EAED);
  static const Color redLightHover = Color(0xFFF6E0E4);
  static const Color redLightActive = Color(0xFFEDC6CC);

  static const Color red = Color(0xFFC5304E);
  static const Color redHover = Color(0xFFB12A46);
  static const Color redActive = Color(0xFF9E263E);

  static const Color redDark = Color(0xFF94243B);
  static const Color redDarkHover = Color(0xFF7B1E2F);
  static const Color redDarkActive = Color(0xFF591623);
  static const Color redDarker = Color(0xFF4B111B);

  //! ───────────────────────── Green (Success) ─────────────────────────

  static const Color greenLight = Color(0xFFE8F6F6);
  static const Color greenLightHover = Color(0xFFDCF2F1);
  static const Color greenLightActive = Color(0xFFBEECE3);

  static const Color green = Color(0xFF15C1A4);
  static const Color greenHover = Color(0xFF13AE94);
  static const Color greenActive = Color(0xFF119A83);

  static const Color greenDark = Color(0xFF0F917B);
  static const Color greenDarkHover = Color(0xFF0C7462);
  static const Color greenDarkActive = Color(0xFF09574A);
  static const Color greenDarker = Color(0xFF074439);
}

//! ───────────────────────── Status Colors ─────────────────────────

class StatusColors {
  StatusColors._();

  //? Grey (Neutral / Missing Data)
  static const Color greyLight = Color(0xFFF2F2F2);
  static const Color grey = Color(0xFF9E9E9E); // Colors.grey
  static const Color greyDark = Color(0xFF616161);
  static final Color greyTransparent = const Color(0xFF9E9E9E).withAlpha(20);

  //? Orange (Warning / Pending)
  static const Color orangeLight = Color(0xFFFFF3E0);
  static const Color orange = Color(0xFFFF9800); // Colors.orange
  static const Color orangeDark = Color(0xFFF57C00);
  static final Color orangeTransparent = const Color(0xFFFF9800).withAlpha(20);

  //? Green (Success / Done)
  static const Color greenLight = AppColors.greenLight;
  static const Color green = Color(0xFF4CAF50); // Colors.green
  static const Color greenDark = AppColors.greenDark;
  static final Color greenTransparent = const Color(0xFF4CAF50).withAlpha(20);

  //? Red (Error / Exceeded)
  static const Color redLight = AppColors.redLight;
  static const Color red = Color(0xFFF44336); // Colors.red
  static const Color redDark = AppColors.redDark;
  static final Color redTransparent = const Color(0xFFF44336).withAlpha(20);

  //? Blue (Info / Active)
  static const Color blueLight = Color(0xFFE3F2FD);
  static const Color blue = Color(0xFF2196F3);
  static const Color blueDark = Color(0xFF1976D2);
  static final Color blueTransparent = const Color(0xFF2196F3).withAlpha(20);

  //? Yellow (Attention / Note)
  static const Color yellowLight = Color(0xFFFFFDE7);
  static const Color yellow = Color(0xFFFFEB3B);
  static const Color yellowDark = Color(0xFFFBC02D);
  static final Color yellowTransparent = const Color(0xFFFFEB3B).withAlpha(20);
}
