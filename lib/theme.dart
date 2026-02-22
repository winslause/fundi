import 'package:flutter/material.dart';

class AppTheme {
  // Color palette with rich, warm tones for skeumorphic design
  static const Color primaryBrown = Color(0xFF8B4513); // Saddle brown
  static const Color secondaryBrown = Color(0xFFD2691E); // Chocolate
  static const Color accentAmber = Color(0xFFFFBF00); // Amber
  static const Color deepOrange = Color(0xFFCC5500); // Burnt orange
  static const Color creamWhite = Color(0xFFFFF8E7); // Cosmic latte
  static const Color leatherBrown = Color(0xFF964B00); // Dark brown
  
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    
    // Color scheme with rich, warm colors
    colorScheme: const ColorScheme.light(
      primary: primaryBrown,
      secondary: secondaryBrown,
      tertiary: accentAmber,
      surface: creamWhite,
      background: Color(0xFFF5F0E6), // Warm off-white
      error: Color(0xFFBA2D2D), // Rich red
    ),
    
    // Typography with elegant, readable fonts
    fontFamily: 'Georgia', // Will fall back to default if not available
    
    // Text themes with skeumorphic styling (embossing/debossing effects)
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: primaryBrown,
        shadows: [
          Shadow(
            color: Colors.white,
            offset: Offset(1, 1),
            blurRadius: 2,
          ),
          Shadow(
            color: Colors.black12,
            offset: Offset(2, 2),
            blurRadius: 4,
          ),
        ],
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: leatherBrown,
      ),
    ).apply(
      bodyColor: leatherBrown,
      displayColor: primaryBrown,
    ),
    
    // Card theme with skeumorphic styling - Using CardThemeData factory
    cardTheme: CardThemeData(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      color: creamWhite,
      shadowColor: Colors.brown.withOpacity(0.3),
    ),
    
    // Elevated button theme with 3D effect
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: secondaryBrown,
        elevation: 8,
        shadowColor: deepOrange.withOpacity(0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ),
      ),
    ),
    
    // Input decoration with skeumorphic inset effect
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: Color(0xFFD2691E), // secondaryBrown
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(
          color: accentAmber,
          width: 2,
        ),
      ),
      contentPadding: EdgeInsets.all(16),
    ),
    
    // App bar theme with leather-like appearance
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBrown,
      foregroundColor: creamWhite,
      elevation: 4,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: creamWhite,
        letterSpacing: 1.5,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
    ),
    
    // Icon theme with depth
    iconTheme: IconThemeData(
      color: secondaryBrown,
      size: 24,
      shadows: const [
        Shadow(
          color: Colors.white,
          offset: Offset(0.5, 0.5),
          blurRadius: 1,
        ),
        Shadow(
          color: Colors.black12,
          offset: Offset(1, 1),
          blurRadius: 2,
        ),
      ],
    ),
    
    // Divider with engraved effect
    dividerTheme: DividerThemeData(
      color: Colors.brown.shade200,
      thickness: 1,
      space: 24,
    ),
  );
  
  // We'll add dark theme later if needed
}