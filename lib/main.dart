import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/navigation/app_router.dart';
import 'features/deeplink/services/deep_link_service.dart';
import 'features/profile/services/expert_profile_service.dart';
import 'features/family/services/family_board_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  final deepLinkService = DeepLinkService.instance;
  await deepLinkService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ExpertProfileService.instance),
        ChangeNotifierProvider(create: (_) => FamilyBoardService.instance),
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
    return MaterialApp.router(
      title: 'TaxLien Swipe - Deal Detective',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: AppRouter.router,
    );
  }
}