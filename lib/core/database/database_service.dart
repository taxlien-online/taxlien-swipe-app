import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService({String? databasePath}) => _instance._init(databasePath);
  DatabaseService._internal();

  Database? _database;
  String? _testDatabasePath; // Used only for testing

  DatabaseService _init(String? databasePath) {
    if (databasePath != null) {
      _testDatabasePath = databasePath;
      _database = null; // Reset database for new path
    }
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = _testDatabasePath ?? join((await getApplicationDocumentsDirectory()).path, 'taxlien_offline.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Table for properties
    await db.execute('''
      CREATE TABLE properties(
        id TEXT PRIMARY KEY,
        data TEXT,
        priority_score REAL,
        is_liked INTEGER DEFAULT 0,
        is_priority INTEGER DEFAULT 0,
        last_accessed INTEGER,
        filter_context_hash TEXT
      )
    ''');

    // Table for action queue
    await db.execute('''
      CREATE TABLE action_queue(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        action_type TEXT,
        payload TEXT,
        timestamp INTEGER,
        retry_count INTEGER DEFAULT 0
      )
    ''');

    // Table for sync metadata
    await db.execute('''
      CREATE TABLE sync_metadata(
        key TEXT PRIMARY KEY,
        value TEXT
      )
    ''');

    // Index for LRU and priority
    await db.execute('CREATE INDEX idx_properties_priority ON properties (priority_score DESC)');
    await db.execute('CREATE INDEX idx_properties_lru ON properties (last_accessed)');
  }

  // --- Helper Methods ---

  Future<void> saveProperty(Map<String, dynamic> property, {String? contextHash}) async {
    final db = await database;
    await db.insert(
      'properties',
      {
        'id': property['id'],
        'data': json.encode(property),
        'priority_score': property['priority_score'] ?? 0.0,
        'is_liked': (property['is_liked'] == true) ? 1 : 0,
        'is_priority': (property['is_priority'] == true) ? 1 : 0,
        'last_accessed': DateTime.now().millisecondsSinceEpoch,
        'filter_context_hash': contextHash,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getProperties({String? contextHash, int limit = 100}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'properties',
      where: contextHash != null ? 'filter_context_hash = ?' : null,
      whereArgs: contextHash != null ? [contextHash] : null,
      orderBy: 'priority_score DESC, last_accessed DESC',
      limit: limit,
    );

    // Update last_accessed for LRU
    if (maps.isNotEmpty) {
      final ids = maps.map((m) => m['id']).toList();
      await db.update(
        'properties',
        {'last_accessed': DateTime.now().millisecondsSinceEpoch},
        where: 'id IN (${ids.map((_) => '?').join(',')})',
        whereArgs: ids,
      );
    }

    return maps.map((m) {
      final data = json.decode(m['data']) as Map<String, dynamic>;
      data['is_liked'] = m['is_liked'] == 1;
      return data;
    }).toList();
  }

  Future<void> queueAction(String type, Map<String, dynamic> payload) async {
    final db = await database;
    await db.insert('action_queue', {
      'action_type': type,
      'payload': json.encode(payload),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> getQueuedActions() async {
    final db = await database;
    return await db.query('action_queue', orderBy: 'timestamp ASC');
  }

  Future<void> removeAction(int id) async {
    final db = await database;
    await db.delete('action_queue', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearOldProperties(int keepCount) async {
    final db = await database;

    // 1. Get IDs of liked or priority properties
    final likedAndPriorityIds = (await db.query(
      'properties',
      columns: ['id'],
      where: 'is_liked = 1 OR is_priority = 1',
    )).map((e) => e['id'] as String).toList();

    // 2. Get IDs of the most recently accessed non-liked/non-priority properties
    final lruNonProtectedIds = (await db.query(
      'properties',
      columns: ['id'],
      where: 'is_liked = 0 AND is_priority = 0',
      orderBy: 'last_accessed DESC',
      limit: keepCount,
    )).map((e) => e['id'] as String).toList();

    // 3. Combine all IDs to keep
    final allIdsToKeep = {...likedAndPriorityIds, ...lruNonProtectedIds}.toList();

    // 4. Delete properties that are not in allIdsToKeep and are non-liked/non-priority
    if (allIdsToKeep.isNotEmpty) {
      // Delete properties that are NOT in allIdsToKeep
      await db.delete(
        'properties',
        where: 'id NOT IN (${allIdsToKeep.map((_) => '?').join(',')})',
        whereArgs: allIdsToKeep,
      );
    } else {
      // If no properties to keep, delete all properties
      await db.delete('properties');
    }
  }

  Future<int> getPropertyCount({String? contextHash}) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'properties',
      columns: ['COUNT(*) as count'],
      where: contextHash != null ? 'filter_context_hash = ?' : null,
      whereArgs: contextHash != null ? [contextHash] : null,
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<Map<String, dynamic>?> getPropertyById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'properties',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      final data = json.decode(maps.first['data']) as Map<String, dynamic>;
      data['is_liked'] = maps.first['is_liked'] == 1; // Re-add is_liked from DB column
      return data;
    }
    return null;
  }
}
