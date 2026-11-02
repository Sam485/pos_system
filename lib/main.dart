import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pos_system/core/routes/app_router.dart';
import 'package:pos_system/core/services/api_service.dart';
import 'package:pos_system/core/services/service_locator.dart';
import 'package:pos_system/core/theme/app_colors.dart';
import 'package:pos_system/core/theme/app_theme.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.setup();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final api = ServiceLocator.apiClient;
    final apiService = ApiService(api);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
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
          final languageCode = languageProvider.currentLanguage;

          return MaterialApp.router(
            title: 'Miko Delivery',
            debugShowCheckedModeBanner: false,
            routerConfig: appRouter,

            // ── Light theme — font family follows the active language ──
            theme: AppTheme.lightFor(languageCode).copyWith(
              scaffoldBackgroundColor: AppColors.background,
              extensions: const [AppThemeColors.light],
            ),

            // ── Dark theme — same, for dark mode ────────────────
            darkTheme: AppTheme.darkFor(languageCode).copyWith(
              scaffoldBackgroundColor: AppThemeColors.dark.background,
              extensions: const [AppThemeColors.dark],
            ),

            // ── Theme mode from provider ────────────────────────
            themeMode: themeProvider.themeMode,
          );
        },
      ),
    );
  }
}
