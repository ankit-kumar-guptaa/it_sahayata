import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'config/app_config.dart';
import 'config/theme.dart';
import 'config/routes.dart';

// ============================================
// MAIN FUNCTION
// ============================================
void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for local storage
  await GetStorage.init();

  // Set preferred orientations (portrait only)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style (status bar, navigation bar colors)
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppColors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Run app
  runApp(const ITSahayataApp());
}

// ============================================
// IT SAHAYATA APP
// ============================================
class ITSahayataApp extends StatelessWidget {
  const ITSahayataApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // App configuration
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme
      theme: AppTheme.lightTheme,

      // Routes
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,

      // Default transitions
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),

      // Locale & translations (future feature)
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
    );
  }
}
