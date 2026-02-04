import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // New Import

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:taxlien_swipe_app/l10n/app_localizations.dart';

import 'core/navigation/app_router.dart';
import 'core/localization/locale_provider.dart';
import 'features/deeplink/services/deep_link_service.dart';
import 'features/profile/services/expert_profile_service.dart';
import 'features/family/services/family_board_service.dart';
import 'features/swipe/providers/swipe_provider.dart';

import 'core/database/database_service.dart'; // New Import
import 'core/repositories/data_repository.dart'; // New Import
import 'services/tax_lien_service.dart'; // Existing but will be used by DataRepository
import 'services/image_cache_service.dart'; // New Import
import 'services/sync_manager.dart'; // New Import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  final deepLinkService = DeepLinkService.instance;
  await deepLinkService.init();

  // Instantiate core services
  final databaseService = DatabaseService();
  final taxLienService = TaxLienService();
  final imageCacheService = ImageCacheService();
  final connectivity = Connectivity();
  final localeProvider = LocaleProvider();

  await localeProvider.loadSavedLocale();

  // Instantiate DataRepository and SyncManager with their dependencies
  final dataRepository = DataRepository(
    dbService: databaseService,
    apiService: taxLienService,
    imageCacheService: imageCacheService,
  );
  final syncManager = SyncManager(
    dataRepository: dataRepository,
    connectivity: connectivity,
  );

  runApp(
    MultiProvider(
      providers: [
        // Core services
        ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
        Provider<DatabaseService>(create: (_) => databaseService),
        Provider<TaxLienService>(create: (_) => taxLienService),
        Provider<ImageCacheService>(create: (_) => imageCacheService),
        Provider<Connectivity>(create: (_) => connectivity),
        Provider<IDataRepository>(create: (_) => dataRepository),
        Provider<SyncManager>(create: (_) => syncManager),

        // Existing providers
        ChangeNotifierProvider(create: (_) => ExpertProfileService.instance),
        ChangeNotifierProvider(create: (_) => FamilyBoardService.instance),
        ChangeNotifierProxyProvider2<IDataRepository, SyncManager, SwipeProvider>(
          create: (context) => SwipeProvider(
            dataRepository: Provider.of<IDataRepository>(context, listen: false),
            syncManager: Provider.of<SyncManager>(context, listen: false),
          ),
          update: (context, dataRepo, syncMan, previousProvider) => previousProvider ?? SwipeProvider(
            dataRepository: dataRepo,
            syncManager: syncMan,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
    });
  }

  void _initDeepLinks() {
    DeepLinkService.instance.uriStream.listen((uri) {
      if (mounted) {
        final path = uri.path;
        if (path.isNotEmpty) {
          AppRouter.router.go(path);
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
      routerConfig: AppRouter.router,
      locale: localeProvider.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}