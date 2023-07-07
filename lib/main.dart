// Dart
import 'dart:io';
// Flutter packages
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:hive_flutter/hive_flutter.dart';
// Firebase
import '/controllers/firebase_controller.dart';
import 'firebase_options.dart';
// Screens
import '/screens/splash_screen.dart';
// Services
import '/services/secure_storage.dart';
import '/services/connectivity_service.dart';
// Styles
import '/styles/style_config.dart';
// Utils
// import '/utils/logger.dart';

// Flutter Platform Channels - To make my own plugins
// https://medium.com/flutter/flutter-platform-channels-ce7f540a104e
// https://www.kodeco.com/30342553-platform-specific-code-with-flutter-method-channel-getting-started

void main() async {
  // Flutter initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Enviroment Variables - https://pub.dev/packages/flutter_config - https://www.youtube.com/watch?v=l_nLqPK7K6Q
  await FlutterConfig.loadEnvVariables();

  // *** FIREBASE ***
  // Firebase initial configuration
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Firebase catch erros
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
  };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };

  if (kDebugMode) {
    // Force disable Crashlytics collection while doing every day development.
    // Temporarily toggle this to true if you want to test crash reporting in your app.
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  // Initialize Hive
  await Hive.initFlutter();

  await Hive.openLazyBox("airsoft");

  // *** RIVERPOD ***
  // State management with Riverpod (https://codewithandrea.com/articles/flutter-state-management-riverpod/)

  // Startup (https://codewithandrea.com/articles/riverpod-initialize-listener-app-startup/)
  // 1. Create a ProviderContainer
  final container = ProviderContainer(observers: [/*Logger()*/]);
  // 2. Use it to read the provider

  // This starts the firebase messaging listener
  container.read(firebaseMessagingProvider.notifier).firebaseInitialization();
  // This starts the Connectivity listener
  container.read(connectivityServiceProvider.notifier).initialize();

  // Dark Mode
  bool isDark = await container.read(secureStorageProvider).readString("dark_mode") == "true";

  // Analytics - app Open
  FirebaseAnalytics.instance.logAppOpen();

  if (Platform.isIOS) {
    // Show tracking authorization dialog and ask for permission
    TrackingStatus status = await AppTrackingTransparency.requestTrackingAuthorization();

    if (status == TrackingStatus.denied) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(false);

      container.read(secureStorageProvider).saveString("is_firebase_analytics", "false");
      container.read(secureStorageProvider).saveString("is_firebase_crashlytics", "false");
    }
  }

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: MyApp(
        isDark: isDark,
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({required this.isDark, super.key});

  final bool isDark;

  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Theme Provider - Package for the animate the switching between themes
    return ThemeProvider(
      initTheme: isDark ? dark() : light(),
      duration: const Duration(milliseconds: 500),
      // GetX package - adds useful funcionalities
      builder: (_, theme) => GetMaterialApp(
        title: 'AirSoft',
        onGenerateTitle: (context) => "AirSoft",
        debugShowCheckedModeBanner: false,
        theme: theme,
        // Always start at Splash Screen
        home: const SplashScreen(),
        // Firebase Analytics
        navigatorObservers: <NavigatorObserver>[observer],
        // Support PT-BR in dates
        localizationsDelegates: const [
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate
        ],
        supportedLocales: const [Locale('pt', 'BR')],
      ),
    );
  }
}
