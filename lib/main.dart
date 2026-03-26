import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workjournel/router.dart';
import 'package:workjournel/services/journal_storage_service.dart';
import 'package:workjournel/services/local_llm_service.dart';
import 'package:workjournel/theme/app_theme.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await JournalStorageService.initialize();
  LocalLlmService.initialize();
  await HardwareKeyboard.instance.syncKeyboardState();
  await _configureDesktopWindow();
  runApp(const MyApp());
}

Future<void> _configureDesktopWindow() async {
  if (kIsWeb) {
    return;
  }

  final isDesktop =
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows ||
      defaultTargetPlatform == TargetPlatform.linux;

  if (!isDesktop) {
    return;
  }

  await windowManager.ensureInitialized();
  const options = WindowOptions(
    minimumSize: Size(AppBreakpoints.desktopMinWidth, 700),
  );

  await windowManager.waitUntilReadyToShow(options, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      HardwareKeyboard.instance.syncKeyboardState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WorkJournel.ai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          surface: AppColors.surfaceContainerLowest,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.surfaceContainerLowest,
      ),
      routerConfig: goRouter,
    );
  }
}
