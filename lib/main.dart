import 'package:chatmcp/dao/init_db.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart' as wm;
import './logger.dart';
import './page/layout/layout.dart';
import './provider/provider_manager.dart';
import 'package:logging/logging.dart';
import 'utils/platform.dart';
import 'package:chatmcp/provider/settings_provider.dart';
import 'utils/init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:chatmcp/generated/app_localizations.dart';
import 'package:bot_toast/bot_toast.dart';

final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// Add global navigator key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeLogger();

  await initNonWeb();

  if (kIsDesktop) {
    await wm.windowManager.ensureInitialized();

    final wm.WindowOptions windowOptions = wm.WindowOptions(
      size: Size(1200, 800),
      minimumSize: Size(400, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: wm.TitleBarStyle.hidden,
      windowButtonVisibility: true,
      alwaysOnTop: false,
      fullScreen: false,
    );

    await wm.windowManager.waitUntilReadyToShow(windowOptions, () async {
      try {
        await wm.windowManager.show();
        await wm.windowManager.focus();
        // Add a small delay to ensure window is properly initialized
        await Future.delayed(const Duration(milliseconds: 100));
      } catch (e) {
        Logger.root.warning('Window initialization error: $e');
      }
    });
  }

  try {
    await Future.wait([ProviderManager.init(), initDb()]);

    var app = MyApp();

    runApp(MultiProvider(providers: [...ProviderManager.providers], child: app));
  } catch (e, stackTrace) {
    Logger.root.severe('Main error: $e\nStack trace:\n$stackTrace');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Get default font for current platform
  String getPlatformFontFamily() {
    if (kIsWindows) {
      return 'Microsoft YaHei'; // Microsoft YaHei font
    }
    return ''; // Use Flutter default font for other platforms
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: _scaffoldMessengerKey,
          navigatorKey: navigatorKey,
          title: 'ARIA',
          theme: ThemeData(useMaterial3: true, brightness: Brightness.light, fontFamily: getPlatformFontFamily()),
          darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, fontFamily: getPlatformFontFamily()),
          themeMode: _getThemeMode(settings.generalSetting.theme),
          home: LayoutPage(),
          locale: Locale(settings.generalSetting.locale),
          builder: BotToastInit(), //1.调用BotToastInit
          navigatorObservers: [BotToastNavigatorObserver()], //2.注册路由观察者
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('zh'), Locale('tr'), Locale('de')],
        );
      },
    );
  }

  ThemeMode _getThemeMode(String theme) {
    switch (theme) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }
}
