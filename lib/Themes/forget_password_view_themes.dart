import 'package:flutter/material.dart';

final ThemeData elegantTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF0077FF), // Electric Blue
    secondary: Color(0xFFEFAEFF), // Soft Pink
    background: Color(0xFF0D1B2A), // Midnight Navy
    surface: Color(0xFFF3F0FF),    // Lavender tint
    onSurface: Colors.white,
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF3366FF),
    secondaryContainer: Color(0xFFFDD8FF),
    tertiaryContainer: Color(0xFFC6DEFF),
  ),
  scaffoldBackgroundColor: Color(0xFF0D1B2A),
  hintColor: Colors.white70,
  shadowColor: Colors.black87,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white10,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.white60),
    prefixIconColor: Colors.white60,
  ),
);
final ThemeData softEleganceTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF5F6CAF), // Soft Indigo
    secondary: Color(0xFFFFB6B9), // Blush Pink
    background: Color(0xFFF9FAFC), // Soft White
    surface: Color(0xFFE6E6FA), // Lavender Mist
    onSurface: Color(0xFF2C3E50), // Deep Charcoal (for text input)
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF7A89C2),
    secondaryContainer: Color(0xFFFFE1E3),
    tertiaryContainer: Color(0xFFD0D8F5),
  ),
  scaffoldBackgroundColor: Color(0xFFF9FAFC),
  hintColor: Color(0xFFA2A9B0), // Muted gray
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF2C3E50)), // Main text
    headlineSmall: TextStyle(
      color: Color(0xFF2C3E50),
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE6E6FA), // Light surface for input field
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFFA2A9B0)), // Muted hint text
    prefixIconColor: Color(0xFFA2A9B0),
  ),
);
final ThemeData royalTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF6C5CE7), // Royal Purple
    secondary: Color(0xFFFF7675), // Coral Pink
    background: Color(0xFF1B262C), // Space Blue
    surface: Color(0xFFF1F2F6), // Pale Silver
    onSurface: Colors.white,
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF8E7BEF),
    secondaryContainer: Color(0xFFFFB6B3),
    tertiaryContainer: Color(0xFF74B9FF), // Baby Blue
  ),
  scaffoldBackgroundColor: Color(0xFF1B262C),
  hintColor: Colors.white60,
  shadowColor: Colors.black54,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white12,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.white60),
    prefixIconColor: Colors.white60,
  ),
);
final ThemeData oceanBreezeTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF0077B6),
    secondary: Color(0xFF90E0EF),
    background: Color(0xFFF1FAFF),
    surface: Color(0xFFD0F0FF),
    onSurface: Color(0xFF002B3A),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF48CAE4),
    secondaryContainer: Color(0xFFCAF0F8),
    tertiaryContainer: Color(0xFFE0FBFC),
  ),
  scaffoldBackgroundColor: Color(0xFFF1FAFF),
  hintColor: Color(0xFF5E7682),
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF002B3A)),
    headlineSmall: TextStyle(color: Color(0xFF002B3A), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFD0F0FF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF5E7682)),
    prefixIconColor: Color(0xFF5E7682),
  ),
);
final ThemeData forestDewTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2C6E49),
    secondary: Color(0xFF90A955),
    background: Color(0xFFF1F6F2),
    surface: Color(0xFFE6EFE9),
    onSurface: Color(0xFF1A3C34),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF5E8C61),
    secondaryContainer: Color(0xFFD4E09B),
    tertiaryContainer: Color(0xFFB5EAD7),
  ),
  scaffoldBackgroundColor: Color(0xFFF1F6F2),
  hintColor: Color(0xFF708072),
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF1A3C34)),
    headlineSmall: TextStyle(color: Color(0xFF1A3C34), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE6EFE9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF708072)),
    prefixIconColor: Color(0xFF708072),
  ),
);
final ThemeData royalOrchidTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF8E44AD),
    secondary: Color(0xFFFFC2E2),
    background: Color(0xFFFAF6FF),
    surface: Color(0xFFE9DAFF),
    onSurface: Color(0xFF3A1C58),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFFA66DD4),
    secondaryContainer: Color(0xFFFFE6F7),
    tertiaryContainer: Color(0xFFE6CCE6),
  ),
  scaffoldBackgroundColor: Color(0xFFFAF6FF),
  hintColor: Color(0xFFA999C9),
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF3A1C58)),
    headlineSmall: TextStyle(color: Color(0xFF3A1C58), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE9DAFF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFFA999C9)),
    prefixIconColor: Color(0xFFA999C9),
  ),
);
final ThemeData sunsetFlameTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFF6B6B),
    secondary: Color(0xFFFFD93D),
    background: Color(0xFFFFF9F4),
    surface: Color(0xFFFFE8E0),
    onSurface: Color(0xFF3C1F1F),
    onPrimary: Colors.white,
    error: Colors.deepOrangeAccent,
    primaryContainer: Color(0xFFFF9F9F),
    secondaryContainer: Color(0xFFFFF4C2),
    tertiaryContainer: Color(0xFFFFD6C3),
  ),
  scaffoldBackgroundColor: Color(0xFFFFF9F4),
  hintColor: Color(0xFFA65A5A),
  shadowColor: Colors.black26,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF3C1F1F)),
    headlineSmall: TextStyle(color: Color(0xFF3C1F1F), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFFFE8E0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFFA65A5A)),
    prefixIconColor: Color(0xFFA65A5A),
  ),
);
final ThemeData moonlightOpalTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF00ADB5),
    secondary: Color(0xFF393E46),
    background: Color(0xFF222831),
    surface: Color(0xFF393E46),
    onSurface: Color(0xFFF8F8F8),
    onPrimary: Colors.black,
    error: Colors.deepOrange,
    primaryContainer: Color(0xFF73EEDC),
    secondaryContainer: Color(0xFF4A4E56),
    tertiaryContainer: Color(0xFF89D5D2),
  ),
  scaffoldBackgroundColor: Color(0xFF222831),
  hintColor: Color(0xFFA0B4BF),
  shadowColor: Colors.black87,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFFF8F8F8)),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF2C313A),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFFA0B4BF)),
    prefixIconColor: Color(0xFFA0B4BF),
  ),
);
final ThemeData sakuraWhisperTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFFB7C5),
    secondary: Color(0xFFA0D2DB),
    background: Color(0xFFFFFBFB),
    surface: Color(0xFFFFEFF2),
    onSurface: Color(0xFF5C4B4B),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFFFFC4D1),
    secondaryContainer: Color(0xFFDEF1F4),
    tertiaryContainer: Color(0xFFFDECEF),
  ),
  scaffoldBackgroundColor: Color(0xFFFFFBFB),
  hintColor: Color(0xFFB69CA5),
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF5C4B4B)),
    headlineSmall: TextStyle(color: Color(0xFF5C4B4B), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFFFEFF2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFFB69CA5)),
    prefixIconColor: Color(0xFFB69CA5),
  ),
);
final ThemeData emeraldGlowTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF2ECC71),
    secondary: Color(0xFFAED581),
    background: Color(0xFFF9FFF9),
    surface: Color(0xFFEAFBE7),
    onSurface: Color(0xFF223322),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF80E0A7),
    secondaryContainer: Color(0xFFE0F2C9),
    tertiaryContainer: Color(0xFFDEF7E0),
  ),
  scaffoldBackgroundColor: Color(0xFFF9FFF9),
  hintColor: Color(0xFF668A66),
  shadowColor: Colors.black26,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF223322)),
    headlineSmall: TextStyle(color: Color(0xFF223322), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFEAFBE7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF668A66)),
    prefixIconColor: Color(0xFF668A66),
  ),
);
final ThemeData arcticSkyTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF3E8EDE),
    secondary: Color(0xFF89CFF0),
    background: Color(0xFFF5FBFF),
    surface: Color(0xFFE1F0FF),
    onSurface: Color(0xFF23374D),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF5AA2E6),
    secondaryContainer: Color(0xFFD4EFFD),
    tertiaryContainer: Color(0xFFC2E2F7),
  ),
  scaffoldBackgroundColor: Color(0xFFF5FBFF),
  hintColor: Color(0xFF6B91B2),
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF23374D)),
    headlineSmall: TextStyle(color: Color(0xFF23374D), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE1F0FF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF6B91B2)),
    prefixIconColor: Color(0xFF6B91B2),
  ),
);
final ThemeData royalOrchidBloom = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF9B59B6),
    secondary: Color(0xFFFAD0C9),
    background: Color(0xFFFBF7FC),
    surface: Color(0xFFF3E5F5),
    onSurface: Color(0xFF3A2C3A),
    onPrimary: Colors.white,
    error: Colors.pinkAccent,
    primaryContainer: Color(0xFFCE93D8),
    secondaryContainer: Color(0xFFFFE4E1),
    tertiaryContainer: Color(0xFFEED8F7),
  ),
  scaffoldBackgroundColor: Color(0xFFFBF7FC),
  hintColor: Color(0xFFA782A9),
  shadowColor: Colors.black12,
  useMaterial3: true,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF3A2C3A)),
    headlineSmall: TextStyle(color: Color(0xFF3A2C3A), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF3E5F5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFFA782A9)),
    prefixIconColor: Color(0xFFA782A9),
  ),
);
//multicolored
final ThemeData sunsetFusionTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFF6B6B),
    secondary: Color(0xFFFFD93D),
    tertiary: Color(0xFF6BCB77),
    background: Color(0xFFFFF8F0),
    surface: Color(0xFFFFF2E2),
    onSurface: Color(0xFF403B3B),
    onPrimary: Colors.white,
    error: Colors.deepOrange,
    primaryContainer: Color(0xFFFF8B8B),
    secondaryContainer: Color(0xFFFFE98F),
    tertiaryContainer: Color(0xFFA8EFC3),
  ),
  scaffoldBackgroundColor: Color(0xFFFFF8F0),
  hintColor: Color(0xFF83776D),
  shadowColor: Colors.black12,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF403B3B)),
    headlineSmall: TextStyle(color: Color(0xFF403B3B), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFFFF2E2),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF83776D)),
    prefixIconColor: Color(0xFF83776D),
  ),
);
final ThemeData neonBreezeTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF00F0FF),
    secondary: Color(0xFFFF00C3),
    tertiary: Color(0xFFBFFF00),
    background: Color(0xFF080F0F),
    surface: Color(0xFF1A1F1F),
    onSurface: Color(0xFFEFEFEF),
    onPrimary: Colors.black,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF6FFAFF),
    secondaryContainer: Color(0xFFFFA3EC),
    tertiaryContainer: Color(0xFFE6FF90),
  ),
  scaffoldBackgroundColor: Color(0xFF080F0F),
  hintColor: Color(0xFF9EA9A9),
  shadowColor: Colors.black,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFFEFEFEF)),
    headlineSmall: TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1A1F1F),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF9EA9A9)),
    prefixIconColor: Color(0xFF00F0FF),
  ),
);
final ThemeData oceanAuroraTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF355C7D),
    secondary: Color(0xFF6C5B7B),
    tertiary: Color(0xFFC06C84),
    background: Color(0xFFF3F4F6),
    surface: Color(0xFFE0E4EC),
    onSurface: Color(0xFF2C3E50),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFF6A8BAF),
    secondaryContainer: Color(0xFF9988A3),
    tertiaryContainer: Color(0xFFE6A9BA),
  ),
  scaffoldBackgroundColor: Color(0xFFF3F4F6),
  hintColor: Color(0xFF7B8A97),
  shadowColor: Colors.black12,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF2C3E50)),
    headlineSmall: TextStyle(color: Color(0xFF2C3E50), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE0E4EC),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF7B8A97)),
    prefixIconColor: Color(0xFF7B8A97),
  ),
);
final ThemeData coralHorizonTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFFFF6F61),
    secondary: Color(0xFF6B4226),
    tertiary: Color(0xFFFFE66D),
    background: Color(0xFFFFF8F2),
    surface: Color(0xFFFDE8D5),
    onSurface: Color(0xFF2E1F1B),
    onPrimary: Colors.white,
    error: Colors.deepOrangeAccent,
    primaryContainer: Color(0xFFFFA194),
    secondaryContainer: Color(0xFF8C5A3A),
    tertiaryContainer: Color(0xFFFFF2A6),
  ),
  scaffoldBackgroundColor: Color(0xFFFFF8F2),
  hintColor: Color(0xFF8A7E77),
  shadowColor: Colors.black12,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF2E1F1B)),
    headlineSmall: TextStyle(color: Color(0xFF2E1F1B), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFFDE8D5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF8A7E77)),
    prefixIconColor: Color(0xFF8A7E77),
  ),
);
final ThemeData quantumPulseTheme = ThemeData(
  colorScheme: ColorScheme.dark(
    primary: Color(0xFF8E44AD),
    secondary: Color(0xFF00BCD4),
    tertiary: Color(0xFFE91E63),
    background: Color(0xFF121212),
    surface: Color(0xFF1F1F1F),
    onSurface: Colors.white,
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFFB27BD9),
    secondaryContainer: Color(0xFF74EAF5),
    tertiaryContainer: Color(0xFFFF7BAA),
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
  hintColor: Colors.white70,
  shadowColor: Colors.black54,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Colors.white70),
    headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFF1F1F1F),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.white54),
    prefixIconColor: Colors.white54,
  ),
);
final ThemeData botanicalCalmTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF4CAF50),
    secondary: Color(0xFFFF9800),
    tertiary: Color(0xFF00ACC1),
    background: Color(0xFFFAFAF9),
    surface: Color(0xFFE8F5E9),
    onSurface: Color(0xFF212121),
    onPrimary: Colors.white,
    error: Colors.red,
    primaryContainer: Color(0xFFA5D6A7),
    secondaryContainer: Color(0xFFFFCC80),
    tertiaryContainer: Color(0xFF80DEEA),
  ),
  scaffoldBackgroundColor: Color(0xFFFAFAF9),
  hintColor: Color(0xFF707070),
  shadowColor: Colors.black26,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF212121)),
    headlineSmall: TextStyle(color: Color(0xFF212121), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFE8F5E9),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Color(0xFF707070)),
    prefixIconColor: Color(0xFF707070),
  ),
);
final ThemeData auroraMistTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFFA770EF),
    secondary: Color(0xFFFDB99B),
    tertiary: Color(0xFFFFDEE9),
    background: Color(0xFFFDFBFB),
    surface: Color(0xFFF6F6F6),
    onSurface: Color(0xFF333333),
    onPrimary: Colors.white,
    error: Colors.redAccent,
    primaryContainer: Color(0xFFCFA1FF),
    secondaryContainer: Color(0xFFFFE0CA),
    tertiaryContainer: Color(0xFFFFEEF3),
  ),
  scaffoldBackgroundColor: Color(0xFFFDFBFB),
  hintColor: Color(0xFF888888),
  shadowColor: Colors.black12,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF333333)),
    headlineSmall: TextStyle(color: Color(0xFF111111), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF6F6F6),
    hintStyle: TextStyle(color: Color(0xFF999999)),
    prefixIconColor: Color(0xFF888888),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
);
final ThemeData mintRoseTheme = ThemeData(
  colorScheme: ColorScheme.light(
    primary: Color(0xFF72E1D1),
    secondary: Color(0xFFFFB5A7),
    tertiary: Color(0xFFF8EDEB),
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF9FAFB),
    onSurface: Color(0xFF333333),
    onPrimary: Colors.black,
    error: Colors.redAccent,
    primaryContainer: Color(0xFFACF4E8),
    secondaryContainer: Color(0xFFFFD9D1),
    tertiaryContainer: Color(0xFFFFF6F4),
  ),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  hintColor: Color(0xFF888888),
  shadowColor: Colors.black12,
  textTheme: const TextTheme(
    bodyMedium: TextStyle(color: Color(0xFF333333)),
    headlineSmall: TextStyle(color: Color(0xFF1A1A1A), fontWeight: FontWeight.bold),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Color(0xFFF8EDEB),
    hintStyle: TextStyle(color: Color(0xFF999999)),
    prefixIconColor: Color(0xFF888888),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  ),
);
