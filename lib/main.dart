import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:pos_system/core/routes/app_router.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/core/services/push_notifications.dart';
import 'package:pos_system/core/services/service_locator.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_theme.dart';
import 'package:pos_system/firebase_options.dart';
import 'package:pos_system/providers/auth_provider.dart';
import 'package:pos_system/providers/cart_provider.dart';
import 'package:pos_system/providers/customer_provider.dart';
import 'package:pos_system/providers/inventory_provider.dart';
import 'package:pos_system/providers/language_provider.dart';
import 'package:pos_system/providers/navigation_provider.dart';
import 'package:pos_system/providers/notificatoin_provider.dart';
import 'package:pos_system/providers/order_provider.dart';
import 'package:pos_system/providers/product_provider.dart';
import 'package:pos_system/providers/register_provider.dart';
import 'package:pos_system/providers/setting_provider.dart';
import 'package:pos_system/providers/staff_provider.dart';
import 'package:pos_system/providers/store_provider.dart';
import 'package:pos_system/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  ServiceLocator.setup();
  await PushNotifications.init(appRouter);

  // ── Pre-load theme before runApp ──
  final prefs = await SharedPreferences.getInstance();
  final saved = prefs.getString(ThemeProvider.themeKey);
  final initialMode = saved != null
      ? ThemeMode.values.firstWhere(
          (m) => m.name == saved,
          orElse: () => ThemeProvider.defaultThemeMode,
        )
      : ThemeProvider.defaultThemeMode;

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(MyApp(initialThemeMode: initialMode));
}

class MyApp extends StatelessWidget {
  final ThemeMode initialThemeMode;

  const MyApp({super.key, required this.initialThemeMode});

  @override
  Widget build(BuildContext context) {
    final api = ServiceLocator.apiClient;
    final apiService = ApiService(api);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(
            initialMode: initialThemeMode,
            initialLoaded: true, // 👈 critical
          ),
        ),
        ChangeNotifierProvider(create: (_) => AuthProvider(apiService)),
        ChangeNotifierProvider(create: (_) => CustomerProvider(apiService)),
        ChangeNotifierProvider(create: (_) => InventoryProvider(apiService)),
        ChangeNotifierProvider(create: (_) => OrderProvider(apiService)),
        ChangeNotifierProvider(create: (_) => ProductProvider(apiService)),
        ChangeNotifierProvider(create: (_) => RegisterProvider(apiService)),
        ChangeNotifierProvider(create: (_) => StaffProvider(apiService)),
        ChangeNotifierProvider(
          create: (context) => CartProvider(
            apiService,
            context.read<InventoryProvider>(),
            context.read<RegisterProvider>(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => StoreProvider(apiService)),
        ChangeNotifierProvider(create: (_) => SettingsProvider(apiService)),
        ChangeNotifierProvider(create: (_) => NotificationProvider(apiService)),
      ],
      // 👇 Watch BOTH providers — theme AND language
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, _) {
          // 👇 Gate on isLoaded — should always be true here, but if
          //    it ever isn't (e.g. someone constructs the app without
          //    pre-loading), show a theme-matched splash instead of
          //    the default white/black frame.
          if (!themeProvider.isLoaded) {
            return _buildSplashGate(context, themeProvider.themeMode);
          }

          final languageCode = languageProvider.currentLanguage;

          return MaterialApp.router(
            title: 'POS System',
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,
            theme: AppTheme.lightFor(languageCode).copyWith(
              scaffoldBackgroundColor: AppColors.background,
              extensions: const [AppThemeColors.light],
            ),
            darkTheme: AppTheme.darkFor(languageCode).copyWith(
              scaffoldBackgroundColor: AppThemeColors.dark.background,
              extensions: const [AppThemeColors.dark],
            ),
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }

  /// Minimal splash that matches the theme — so even if `isLoaded` is
  /// somehow false on the first frame, the user sees the right color,
  /// not a white flash.
  Widget _buildSplashGate(BuildContext context, ThemeMode mode) {
    final brightness = switch (mode) {
      ThemeMode.light => Brightness.light,
      ThemeMode.dark => Brightness.dark,
      ThemeMode.system => MediaQuery.platformBrightnessOf(context),
    };

    final bg = brightness == Brightness.dark
        ? AppThemeColors.dark.background
        : AppThemeColors.light.background;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ColoredBox(color: bg, child: const SizedBox.expand()),
    );
  }
}
