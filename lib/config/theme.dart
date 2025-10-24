import 'package:flutter/material.dart';

// ============================================
// APP COLORS
// ============================================
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF007BFF); // Tech Blue
  static const Color primaryDark = Color(0xFF0056b3); // Darker blue
  static const Color primaryLight = Color(0xFF3395FF); // Lighter blue

  // Accent colors
  static const Color success = Color(0xFF00C853); // Green
  static const Color warning = Color(0xFFFF9800); // Orange
  static const Color error = Color(0xFFDC3545); // Red
  static const Color info = Color(0xFF17A2B8); // Cyan

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF5F7FA); // Light gray background
  static const Color cardBg = Color(0xFFFFFFFF); // Card background

  // Text colors
  static const Color textPrimary = Color(0xFF333333); // Dark gray
  static const Color textSecondary = Color(0xFF666666); // Medium gray
  static const Color textHint = Color(0xFF999999); // Light gray
  static const Color textDisabled = Color(0xFFCCCCCC); // Very light gray

  // Border & divider
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFEEEEEE);

  // Status colors
  static const Color statusPending = Color(0xFFFFC107); // Yellow
  static const Color statusAssigned = Color(0xFF2196F3); // Blue
  static const Color statusInProgress = Color(0xFF03A9F4); // Light Blue
  static const Color statusResolved = Color(0xFF4CAF50); // Green
  static const Color statusClosed = Color(0xFF9E9E9E); // Gray

  // Priority colors
  static const Color priorityLow = Color(0xFF4CAF50); // Green
  static const Color priorityMedium = Color(0xFFFF9800); // Orange
  static const Color priorityHigh = Color(0xFFF44336); // Red

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF667eea), Color(0xFF764ba2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// ============================================
// TEXT STYLES
// ============================================
class AppTextStyles {
  // Headings
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  // Body text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    fontFamily: 'Poppins',
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );

  // Button text
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
    fontFamily: 'Poppins',
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    fontFamily: 'Poppins',
  );
}

// ============================================
// APP THEME
// ============================================
class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // Primary theme
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    brightness: Brightness.light,

    // App bar theme
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.white),
      titleTextStyle: TextStyle(
        color: AppColors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
    ),

    // Card theme
    // cardTheme: CardTheme(
    //   color: AppColors.cardBg,
    //   elevation: 2,
    //   shadowColor: Colors.black12,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(12),
    //   ),
    // ),

    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),

    // Button theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        textStyle: AppTextStyles.button,
      ),
    ),

    // Text button theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),

    // Input decoration theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      hintStyle: const TextStyle(
        color: AppColors.textHint,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
    ),

    // Icon theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimary,
      size: 24,
    ),

    // Text theme
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.h1,
      displayMedium: AppTextStyles.h2,
      displaySmall: AppTextStyles.h3,
      headlineMedium: AppTextStyles.h4,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.button,
    ),

    // Floating action button theme
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      elevation: 4,
    ),

    // Bottom navigation bar theme
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textHint,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
        fontFamily: 'Poppins',
      ),
    ),

    // Dialog theme
    // dialogTheme: DialogTheme(
    //   backgroundColor: AppColors.white,
    //   elevation: 8,
    //   shape: RoundedRectangleBorder(
    //     borderRadius: BorderRadius.circular(15),
    //   ),
    //   titleTextStyle: const TextStyle(
    //     color: AppColors.textPrimary,
    //     fontSize: 20,
    //     fontWeight: FontWeight.bold,
    //     fontFamily: 'Poppins',
    //   ),
    //   contentTextStyle: const TextStyle(
    //     color: AppColors.textSecondary,
    //     fontSize: 14,
    //     fontFamily: 'Poppins',
    //   ),
    // ),

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      titleTextStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
      ),
      contentTextStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
    ),

    // Font family
    fontFamily: 'Poppins',
  );
}

// ============================================
// COMMON DECORATIONS
// ============================================
class AppDecorations {
  // Card decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.cardBg,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  // Gradient card decoration
  static BoxDecoration gradientCardDecoration = BoxDecoration(
    gradient: AppColors.primaryGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 8),
      ),
    ],
  );
}

// ============================================
// SPACING & SIZING
// ============================================
class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  // Border radius
  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  // Icon sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Button height
  static const double buttonHeight = 50.0;
  static const double buttonHeightSmall = 40.0;
}
