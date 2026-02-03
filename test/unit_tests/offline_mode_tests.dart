import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file/file.dart';
import 'package:sqflite/sqflite.dart';

import 'package:taxlien_swipe_app/core/database/database_service.dart';
import 'package:taxlien_swipe_app/core/repositories/data_repository.dart';
import 'package:taxlien_swipe_app/services/tax_lien_service.dart';
import 'package:taxlien_swipe_app/services/image_cache_service.dart';
import 'package:taxlien_swipe_app/core/models/tax_lien_models.dart';
import 'package:taxlien_swipe_app/core/models/device_capabilities.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// === Mocks ===
class FakeDeviceCapabilities extends Fake implements DeviceCapabilities {}
class FakePathProviderPlatform extends PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async => '/test/documents';
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockDatabaseService extends Mock implements DatabaseService {}
class MockTaxLienService extends Mock implements TaxLienService {}
class MockImageCacheService extends Mock implements ImageCacheService {}
class MockConnectivity extends Mock implements Connectivity {}
class MockDefaultCacheManager extends Mock implements DefaultCacheManager {}

// New Mock for sqflite.Database (for DataRepository tests)
class MockDatabase extends Mock implements Database {}

// === Fakes ===
// FakeDatabase is now only used where explicitly needed (e.g., in DatabaseService test itself if I were to mock db.query etc.)
// For DataRepository, we use MockDatabase to have more control over stubbing and verification.

class FakeFile extends Fake implements File {
  final String _mockPath;
  FakeFile(this._mockPath);

  @override
  String get path => _mockPath;

  @override
  bool existsSync() => true;

  @override
  Future<bool> exists() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeFileInfo extends Fake implements FileInfo {
  @override
  String get originalUrl => 'http://fake.com/image.jpg';
  @override
  File get file => FakeFile('fake_path');
  @override
  DateTime get validTill => DateTime.now().add(const Duration(days: 7));
  @override
  String get eTag => 'fake-etag';
}

// === Data ===
final testTaxLien = TaxLien(
  id: 'test_id',
  propertyAddress: '123 Test St',
  county: 'Test County',
  state: 'TS',
  taxAmount: 100.0,
  interestRate: 0.1,
  auctionDate: DateTime.now(),
  status: 'active',
  propertyType: 'Residential',
  estimatedValue: 100000.0,
  assessedValue: 90000.0,
  description: 'A test property',
  images: ['http://example.com/image1.jpg', 'http://example.com/image2.jpg'],
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
  miwScore: 0.8,
  foreclosureProbability: 0.7,
);

void main() {
  sqfliteFfiInit(); // Initialize FFI for testing

  setUpAll(() {
    dotenv.testLoad(fileInput: 'OFFLINE_BATCH_SIZE=100\nULTRA_RES_PERCENT=20');
    registerFallbackValue(FakeDeviceCapabilities());
  });

  group('DatabaseService', () {
    late DatabaseService databaseService;

    setUp(() async {
      PathProviderPlatform.instance = FakePathProviderPlatform();
      databaseService = DatabaseService(databasePath: inMemoryDatabasePath);
      databaseFactory = databaseFactoryFfi;
      await databaseService.database;
    });

    tearDown(() async {
      await databaseService.database.then((db) => db.close());
    });

    test('should save and retrieve a property', () async {
      final propertyMap = testTaxLien.toJson();
      propertyMap['priority_score'] = 0.8;
      propertyMap['is_liked'] = false;
      propertyMap['is_priority'] = false;
      propertyMap['last_accessed'] = DateTime.now().millisecondsSinceEpoch;
      propertyMap['filter_context_hash'] = 'default';
      await databaseService.saveProperty(propertyMap);
      final retrievedProperties = await databaseService.getProperties();

      expect(retrievedProperties.length, 1);
      expect(retrievedProperties.first['id'], testTaxLien.id);
      expect(retrievedProperties.first['is_liked'], false);
    });

    test('should retrieve a property by ID', () async {
      final propertyMap = testTaxLien.toJson();
      propertyMap['is_liked'] = true;
      propertyMap['priority_score'] = 0.9;
      propertyMap['is_priority'] = true;
      propertyMap['last_accessed'] = DateTime.now().millisecondsSinceEpoch;
      propertyMap['filter_context_hash'] = 'default';

      await databaseService.saveProperty(propertyMap);

      final retrievedProperty = await databaseService.getPropertyById(testTaxLien.id);
      expect(retrievedProperty, isNotNull);
      expect(retrievedProperty!['id'], testTaxLien.id);
      expect(retrievedProperty['is_liked'], true);
    });

    test('should queue and retrieve actions', () async {
      await databaseService.queueAction('LIKE', {'propertyId': 'prop1'});
      await databaseService.queueAction('PASS', {'propertyId': 'prop2'});

      final actions = await databaseService.getQueuedActions();
      expect(actions.length, 2);
      expect(actions.first['action_type'], 'LIKE');
      expect(actions.last['action_type'], 'PASS');
    });

    test('should remove an action', () async {
      await databaseService.queueAction('LIKE', {'propertyId': 'prop1'});
      final actions = await databaseService.getQueuedActions();
      final actionId = actions.first['id'];

      await databaseService.removeAction(actionId);
      final remainingActions = await databaseService.getQueuedActions();
      expect(remainingActions.length, 0);
    });

    test('should get property count', () async {
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p1'..['priority_score'] = 0.5..['last_accessed'] = 1..['filter_context_hash'] = 'default');
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p2'..['priority_score'] = 0.6..['last_accessed'] = 2..['filter_context_hash'] = 'default');
      final count = await databaseService.getPropertyCount();
      expect(count, 2);
    });

    test('should clear old properties but protect liked/priority items', () async {
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p1'..['propertyAddress'] = '1'..['priority_score'] = 0.1..['last_accessed'] = 1..['is_liked'] = false..['is_priority'] = false);
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p2'..['propertyAddress'] = '2'..['priority_score'] = 0.2..['last_accessed'] = 2..['is_liked'] = false..['is_priority'] = false);
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p3'..['propertyAddress'] = '3'..['priority_score'] = 0.3..['last_accessed'] = 3..['is_liked'] = true); // Liked
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p4'..['propertyAddress'] = '4'..['priority_score'] = 0.4..['last_accessed'] = 4..['is_priority'] = true); // Priority
      await databaseService.saveProperty(testTaxLien.toJson()..['id'] = 'p5'..['propertyAddress'] = '5'..['priority_score'] = 0.5..['last_accessed'] = 5..['is_liked'] = false..['is_priority'] = false);

      await databaseService.clearOldProperties(1);
      final remaining = await databaseService.getProperties(limit: 100);
      
      expect(remaining.length, 3);
      expect(remaining.any((p) => p['id'] == 'p3'), isTrue);
      expect(remaining.any((p) => p['id'] == 'p4'), isTrue);
      expect(remaining.any((p) => p['id'] == 'p5'), isTrue);
      expect(remaining.any((p) => p['id'] == 'p1'), isFalse);
      expect(remaining.any((p) => p['id'] == 'p2'), isFalse);
    });
  });

  group('DataRepository', () {
    late DataRepository dataRepository;
    late MockDatabaseService mockDbService;
    late MockTaxLienService mockApiService;
    late MockImageCacheService mockImageCacheService;
    late MockConnectivity mockConnectivity;
    late MockDatabase mockDatabase; // New Mock for the Database object

    setUp(() {
      mockDbService = MockDatabaseService();
      mockApiService = MockTaxLienService();
      mockImageCacheService = MockImageCacheService();
      mockConnectivity = MockConnectivity();
      mockDatabase = MockDatabase(); // Initialize MockDatabase

      // Stub DatabaseService methods
      when(() => mockDbService.database).thenAnswer((_) async => mockDatabase); // Return MockDatabase
      when(() => mockDbService.getProperties(limit: any(named: 'limit'), contextHash: any(named: 'contextHash')))
          .thenAnswer((_) async => []);
      when(() => mockDbService.getPropertyCount(contextHash: any(named: 'contextHash')))
          .thenAnswer((_) async => 0);
      when(() => mockDbService.saveProperty(any(that: isA<Map<String, dynamic>>()), contextHash: any(named: 'contextHash')))
          .thenAnswer((_) async {});
      when(() => mockDbService.getQueuedActions())
          .thenAnswer((_) async => []);
      when(() => mockDbService.removeAction(any()))
          .thenAnswer((_) async {});
      when(() => mockDbService.queueAction(any(), any())).thenAnswer((_) async {}); // NEW STUB: Added missing stub
      when(() => mockDbService.getPropertyById(any())).thenAnswer((_) async => testTaxLien.toJson());


      // Stub MockDatabase methods
      when(() => mockDatabase.update(any(), any(), where: any(named: 'where'), whereArgs: any(named: 'whereArgs'), conflictAlgorithm: any(named: 'conflictAlgorithm')))
          .thenAnswer((_) async => 1); // Stub update method

      // Stub TaxLienService methods
      when(() => mockApiService.searchLiens(limit: any(named: 'limit'), state: any(named: 'state'), county: any(named: 'county')))
          .thenAnswer((_) async => [testTaxLien]);

      // Stub ImageCacheService methods
      when(() => mockImageCacheService.prefetchImages(any(), ultraResCount: any(named: 'ultraResCount'), caps: any(named: 'caps')))
          .thenAnswer((_) async {});
      when(() => mockImageCacheService.buildOptimizedImageUrl(any(), any(), isUltraRes: any(named: 'isUltraRes')))
          .thenAnswer((invocation) => Uri.parse(invocation.positionalArguments[0] as String));
      
      // Stub Connectivity methods
      when(() => mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => [ConnectivityResult.wifi]);
      when(() => mockConnectivity.onConnectivityChanged)
          .thenAnswer((_) => Stream.fromIterable([[ConnectivityResult.wifi]]));

      dataRepository = DataRepository(
        dbService: mockDbService,
        apiService: mockApiService,
        imageCacheService: mockImageCacheService,
      );
    });

    test('getPropertiesStream emits data from DB', () async {
      final List<Map<String, dynamic>> dbData = [testTaxLien.toJson()..['is_liked'] = false];
      when(() => mockDbService.getProperties(limit: any(named: 'limit'), contextHash: any(named: 'contextHash')))
          .thenAnswer((_) async => dbData);

      final stream = dataRepository.getPropertiesStream('default');
      expect(await stream.first, contains(isA<TaxLien>()));
      verify(() => mockDbService.getProperties(limit: any(named: 'limit'))).called(greaterThanOrEqualTo(1));
    });

    test('queueAction saves to DB', () async {
      await dataRepository.queueAction('LIKE', {'prop': 'id'});
      verify(() => mockDbService.queueAction('LIKE', {'prop': 'id'})).called(1);
    });

    test('updatePropertyLikedStatus updates DB and refreshes stream', () async {
      final currentPropertyJson = testTaxLien.toJson()..['is_liked'] = false;
      when(() => mockDbService.getPropertyById(testTaxLien.id))
          .thenAnswer((_) async => currentPropertyJson);
      // Stub db.update on the MockDatabase
      when(() => mockDatabase.update(any(), any(that: isA<Map<String, dynamic>>()), where: any(named: 'where'), whereArgs: any(named: 'whereArgs'), conflictAlgorithm: any(named: 'conflictAlgorithm')))
          .thenAnswer((_) async => 1);
      when(() => mockDbService.getProperties(limit: any(named: 'limit'), contextHash: any(named: 'contextHash')))
          .thenAnswer((_) async => [testTaxLien.toJson()..['is_liked'] = true]);

      await dataRepository.updatePropertyLikedStatus(testTaxLien.id, true);
      verify(() => mockDbService.database).called(greaterThanOrEqualTo(1));
      verify(() => mockDatabase.update( // Verify update on the MockDatabase
          'properties',
          any(that: containsPair('is_liked', 1)),
          where: 'id = ?',
          whereArgs: [testTaxLien.id],
          conflictAlgorithm: any(named: 'conflictAlgorithm'),
      )).called(1);
      verify(() => mockDbService.getProperties(limit: any(named: 'limit'))).called(greaterThanOrEqualTo(1));
    });

    test('prefetchBatch fetches from API, saves to DB, and prefetches images', () async {
      final caps = DeviceCapabilities(maxWidth: 100, maxHeight: 200, pixelRatio: 1.0);
      await dataRepository.prefetchBatch(limit: 1, ultraResLimit: 0, caps: caps);

      verify(() => mockApiService.searchLiens(limit: 1)).called(1);
      verify(() => mockDbService.saveProperty(any(that: isA<Map<String, dynamic>>()), contextHash: any(named: 'contextHash')))
          .called(1);
      verify(() => mockImageCacheService.prefetchImages(
            [testTaxLien.images.first, testTaxLien.images.last],
            ultraResCount: 0,
            caps: caps,
          )).called(1);
    });

    test('syncQueuedActions syncs with API and removes from DB', () async {
      final action = {'id': 1, 'action_type': 'LIKE', 'payload': '{}', 'timestamp': 123};
      when(() => mockDbService.getQueuedActions()).thenAnswer((_) async => [action]);
      when(() => mockDbService.removeAction(1)).thenAnswer((_) async {});

      await dataRepository.syncQueuedActions();
      verify(() => mockDbService.getQueuedActions()).called(1);
      verify(() => mockDbService.removeAction(1)).called(1);
    });

    test('getPropertyById fetches from DB', () async {
      final propertyMap = testTaxLien.toJson()..['is_liked'] = true;
      when(() => mockDbService.getPropertyById(testTaxLien.id))
          .thenAnswer((_) async => propertyMap);
      when(() => mockDbService.saveProperty(any(that: isA<Map<String, dynamic>>()))).thenAnswer((_) async {});
      
      final result = await dataRepository.getPropertyById(testTaxLien.id);
      expect(result, isA<TaxLien>());
      expect(result?.id, testTaxLien.id);
      verify(() => mockDbService.getPropertyById(testTaxLien.id)).called(1);
      verify(() => mockDbService.saveProperty(any(that: isA<Map<String, dynamic>>()))).called(1); // To update last_accessed
    });
  });

  group('ImageCacheService', () {
    late ImageCacheService imageCacheService;
    late MockDefaultCacheManager mockCacheManager;
    late DeviceCapabilities testCaps;

    setUp(() {
      mockCacheManager = MockDefaultCacheManager();
      imageCacheService = ImageCacheService(cacheManager: mockCacheManager);
      testCaps = DeviceCapabilities(maxWidth: 400, maxHeight: 600, pixelRatio: 2.0);

      when(() => mockCacheManager.downloadFile(any(), key: any(named: 'key')))
          .thenAnswer((_) async => FakeFileInfo());
    });

    test('buildOptimizedImageUrl for device-max', () {
      final url = 'http://test.com/img.jpg';
      final optimizedUri = imageCacheService.buildOptimizedImageUrl(url, testCaps);
      expect(optimizedUri.toString(), contains('w=800'));
      expect(optimizedUri.toString(), contains('h=1200'));
      expect(optimizedUri.toString(), contains('dpr=2.0'));
      expect(optimizedUri.toString(), isNot(contains('quality=source')));
    });

    test('buildOptimizedImageUrl for ultra-res', () async {
      final url = 'http://test.com/img.jpg';
      final optimizedUri = imageCacheService.buildOptimizedImageUrl(url, testCaps, isUltraRes: true);
      expect(optimizedUri.toString(), contains('quality=source'));
      expect(optimizedUri.toString(), isNot(contains('w=')));
      expect(optimizedUri.toString(), isNot(contains('h=')));
      expect(optimizedUri.toString(), isNot(contains('dpr=')));
    });

    test('prefetchImages calls downloadFile with correct URLs', () async {
      final imageUrls = ['http://test.com/img1.jpg', 'http://test.com/img2.jpg', 'http://test.com/img3.jpg'];
      await imageCacheService.prefetchImages(imageUrls, ultraResCount: 1, caps: testCaps);

      verify(() => mockCacheManager.downloadFile(
        any(that: contains('quality=source')),
        key: any(named: 'key'),
      )).called(1);

      verify(() => mockCacheManager.downloadFile(
        any(that: allOf([contains('w=800'), isNot(contains('quality=source'))])),
        key: any(named: 'key'),
      )).called(2);
    });
  });
}