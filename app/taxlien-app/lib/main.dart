import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';

import 'core/navigation/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'features/analytics/analytics_route_observer.dart';
import 'features/analytics/firebase_analytics_service.dart';
import 'features/deeplink/services/deep_link_service.dart';
import 'features/profile/services/expert_profile_service.dart';
import 'features/family/services/family_board_service.dart';
import 'features/swipe/providers/swipe_provider.dart';
import 'features/swipe/providers/filter_provider.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/tutorial/services/tutorial_service.dart';
import 'features/tutorial/services/achievement_service.dart';
import 'features/tutorial/widgets/achievement_toast.dart';

import 'core/database/database_service.dart';
import 'core/repositories/data_repository.dart';
import 'services/tax_lien_service.dart';
import 'services/image_cache_service.dart';
import 'services/sync_manager.dart';
import 'services/analytics_service.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/firebase_auth_service.dart';
import 'features/auth/no_op_auth_service.dart';
import 'features/analytics/att_service.dart';
import 'features/analytics/facebook_app_events_impl.dart';
import 'features/analytics/facebook_app_events_service.dart';
import 'core/config/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  // Optional Firebase (no crash if config missing)
  try {
    await Firebase.initializeApp();
  } catch (_) {
    // App runs without Firebase when google-services.json / GoogleService-Info.plist absent
  }

  if (Firebase.apps.isNotEmpty) {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    };
  }

  final deepLinkService = DeepLinkService.instance;
  await deepLinkService.init();

  final databaseService = DatabaseService();
  final taxLienService = TaxLienService();
  final imageCacheService = ImageCacheService();
  final connectivity = Connectivity();
  final localeProvider = LocaleProvider();

  await localeProvider.loadSavedLocale();

  final dataRepository = DataRepository(
    dbService: databaseService,
    apiService: taxLienService,
    imageCacheService: imageCacheService,
  );

  final analyticsService = Firebase.apps.isEmpty
      ? NoOpAnalyticsService() as AnalyticsService
      : FirebaseAnalyticsServiceImpl();

  final AuthService authService = Firebase.apps.isEmpty
      ? NoOpAuthService()
      : FirebaseAuthService();
  final authProvider = AuthProvider(authService: authService);

  final syncManager = SyncManager(
    dataRepository: dataRepository,
    connectivity: connectivity,
    analytics: analyticsService,
    isSignedIn: () => authProvider.isSignedIn,
  );

  final router = AppRouter.createRouter(
    observers: [AnalyticsRouteObserver(analyticsService)],
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
        Provider<DatabaseService>(create: (_) => databaseService),
        Provider<TaxLienService>(create: (_) => taxLienService),
        Provider<ImageCacheService>(create: (_) => imageCacheService),
        Provider<Connectivity>(create: (_) => connectivity),
        Provider<IDataRepository>(create: (_) => dataRepository),
        Provider<SyncManager>(create: (_) => syncManager),
        Provider<AnalyticsService>(create: (_) => analyticsService),
        ChangeNotifierProvider<AuthProvider>.value(value: authProvider),
        Provider<TutorialService>(create: (_) => TutorialServiceImpl()),
        Provider<AchievementService>(
          create: (c) => AchievementServiceImpl(tutorialService: c.read<TutorialService>()),
        ),

        ChangeNotifierProvider(
          create: (context) => FilterProvider(
            analytics: context.read<AnalyticsService>(),
          )..loadFromPreferences(),
        ),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ExpertProfileService.instance),
        ChangeNotifierProvider(create: (_) => FamilyBoardService.instance),
        ChangeNotifierProxyProvider2<IDataRepository, SyncManager, SwipeProvider>(
          create: (context) => SwipeProvider(
            dataRepository: Provider.of<IDataRepository>(context, listen: false),
            syncManager: Provider.of<SyncManager>(context, listen: false),
            analytics: context.read<AnalyticsService>(),
            fbEvents: context.read<FacebookAppEventsService>(),
            tutorial: context.read<TutorialService>(),
            achievement: context.read<AchievementService>(),
          ),
          update: (context, dataRepo, syncMan, previousProvider) =>
              previousProvider ??
              SwipeProvider(
                dataRepository: dataRepo,
                syncManager: syncMan,
                analytics: context.read<AnalyticsService>(),
                fbEvents: context.read<FacebookAppEventsService>(),
                tutorial: context.read<TutorialService>(),
                achievement: context.read<AchievementService>(),
              ),
        ),
      ],
      child: MyApp(router: router),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.router});

  final GoRouter router;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initDeepLinks();
    // Initialize SyncManager with context after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SyncManager>(context, listen: false).initialize(context);
      // ATT: request iOS tracking permission (no-op on Android, when disabled)
      if (EnvConfig.isFacebookEnabled) {
        AttService.instance.requestTrackingPermission();
      }
    });
  }

  void _initDeepLinks() {
    DeepLinkService.instance.uriStream.listen((uri) {
      if (mounted) {
        final path = uri.path;
        if (path.isNotEmpty) {
          widget.router.go(path);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp.router(
      title: 'TaxLien Swipe - Deal Detective',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: widget.router,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return AchievementToastListener(
          unlockStream: context.read<AchievementService>().onAchievementUnlocked,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}