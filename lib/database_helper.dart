import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = "Ashray.db";
  static const _databaseVersion = 13;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // --- Database Initialization and Schema ---

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
        onConfigure: _onConfigure);
  }

  Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _onCreate(Database db, int version) async {
    await _createDbSchema(db);
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      final tables = [
        'tasks',
        'vaccinations',
        'visits',
        'womens_health',
        'child_care',
        'maternal_care',
        'medical_history',
        'members',
        'families'
      ];
      final batch = db.batch();
      for (final table in tables) {
        batch.execute('DROP TABLE IF EXISTS $table');
      }
      await batch.commit();
      await _onCreate(db, newVersion);
    }
  }

  Future<void> _createDbSchema(Database db) async {
    final batch = db.batch();
    batch.execute('''
      CREATE TABLE families (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        name TEXT NOT NULL,
        village TEXT,
        loginId TEXT,
        password TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        familyId INTEGER,
        familyServerId TEXT,
        aadharNumber TEXT UNIQUE,
        name TEXT NOT NULL,
        age INTEGER,
        gender TEXT,
        phoneNumber TEXT,
        dateOfBirth TEXT,
        weight REAL,
        height REAL,
        bmi REAL,
        bloodGroup TEXT,
        allergies TEXT,
        isPregnant INTEGER DEFAULT 0,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE medical_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        memberId INTEGER NOT NULL,
        memberServerId TEXT,
        condition TEXT,
        notes TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        familyId INTEGER,
        familyServerId TEXT,
        type TEXT NOT NULL,
        description TEXT,
        dueDate TEXT,
        completed INTEGER NOT NULL DEFAULT 0,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE maternal_care (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        memberId INTEGER NOT NULL,
        memberServerId TEXT,
        visitType TEXT,
        visitDate TEXT,
        notes TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE child_care (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        memberId INTEGER NOT NULL,
        memberServerId TEXT,
        visitDate TEXT,
        notes TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE womens_health (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        memberId INTEGER NOT NULL,
        memberServerId TEXT,
        method TEXT,
        details TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE visits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        memberId INTEGER NOT NULL,
        memberServerId TEXT,
        visitDate TEXT,
        notes TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    batch.execute('''
      CREATE TABLE vaccinations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        serverId TEXT UNIQUE,
        memberId INTEGER NOT NULL,
        memberServerId TEXT,
        vaccineName TEXT,
        dateGiven TEXT,
        timestamp INTEGER,
        synced INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await batch.commit();
  }

  // --- Sync Service Helpers ---
  Future<List<Map<String, dynamic>>> getUnsyncedData(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName, where: 'synced = ?', whereArgs: [0]);
  }

  Future<void> markAsSynced(
      String tableName, int localId, String serverId) async {
    Database db = await instance.database;
    await db.update(tableName, {'synced': 1, 'serverId': serverId},
        where: 'id = ?', whereArgs: [localId]);
  }

  Future<void> upsert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    final serverId = data['serverId'];
    if (serverId == null) return;

    if (data['timestamp'] is Timestamp) {
      data['timestamp'] =
          (data['timestamp'] as Timestamp).millisecondsSinceEpoch;
    }

    if (data.containsKey('familyServerId')) {
      final familyServerId = data['familyServerId'];
      if (familyServerId != null) {
        data['familyId'] =
            await getLocalIdByServerId('families', familyServerId);
      }
    }
    if (data.containsKey('memberServerId')) {
      final memberServerId = data['memberServerId'];
      if (memberServerId != null) {
        data['memberId'] =
            await getLocalIdByServerId('members', memberServerId);
      }
    }

    final existing =
        await db.query(tableName, where: 'serverId = ?', whereArgs: [serverId]);
    data['synced'] = 1;

    if (existing.isNotEmpty) {
      await db.update(tableName, data,
          where: 'serverId = ?', whereArgs: [serverId]);
    } else {
      await db.insert(tableName, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<int?> getLocalIdByServerId(String tableName, String serverId) async {
    final db = await database;
    final result = await db.query(tableName,
        columns: ['id'], where: 'serverId = ?', whereArgs: [serverId]);
    return result.isNotEmpty ? result.first['id'] as int? : null;
  }

  // --- Family Methods ---
  Future<int> insertFamily(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('families', row);
  }

  Future<Map<String, dynamic>?> getFamily(int id) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps =
        await db.query('families', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<List<String>> getVillages() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('families', distinct: true, columns: ['village']);
    if (maps.isEmpty) return [];
    return maps
        .map((map) => map['village'] as String?)
        .where((v) => v != null && v.isNotEmpty)
        .cast<String>()
        .toList();
  }

  Future<List<Map<String, dynamic>>> getFamiliesByVillage(
      String village, String query) async {
    final db = await database;
    return await db.query('families',
        where: 'village = ? AND name LIKE ?',
        whereArgs: [village, '%$query%'],
        orderBy: 'name ASC');
  }

  Future<bool> verifyFamilyCredentials(
      int familyId, String loginId, String password) async {
    final db = await database;
    final result = await db.query(
      'families',
      where: 'id = ? AND loginId = ? AND password = ?',
      whereArgs: [familyId, loginId, password],
    );
    return result.isNotEmpty;
  }

  // --- Member Methods ---
  Future<int> insertMember(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('members', row);
  }

  Future<Map<String, dynamic>?> getMember(int id) async {
    Database db = await instance.database;
    final maps = await db.query('members', where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty ? maps.first : null;
  }

  Future<List<Map<String, dynamic>>> getMembers(int familyId) async {
    Database db = await instance.database;
    return await db
        .query('members', where: 'familyId = ?', whereArgs: [familyId]);
  }

  Future<int> updateMember(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['id'];
    row['synced'] = 0;
    return await db.update('members', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteMember(int id) async {
    Database db = await instance.database;
    return await db.delete('members', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getMemberByAadhar(String aadharNumber) async {
    final db = await database;
    final result = await db
        .query('members', where: 'aadharNumber = ?', whereArgs: [aadharNumber]);
    return result.isNotEmpty ? result.first : null;
  }

  // --- Task Methods ---
  Future<int> insertTask(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert('tasks', row);
  }

  Future<List<Map<String, dynamic>>> getPendingTasks() async {
    Database db = await instance.database;
    return await db.query('tasks', where: 'completed = ?', whereArgs: [0]);
  }

  Future<List<Map<String, dynamic>>> getPendingTasksWithFamily() async {
    Database db = await instance.database;
    return await db.rawQuery('''
      SELECT T.*, F.name as familyName 
      FROM tasks T 
      JOIN families F ON T.familyId = F.id 
      WHERE T.completed = 0
    ''');
  }

  Future<int> updateTask(int id, Map<String, dynamic> data) async {
    Database db = await instance.database;
    data['synced'] = 0;
    return await db.update('tasks', data, where: 'id = ?', whereArgs: [id]);
  }

  // --- Health Record Methods ---
  Future<List<Map<String, dynamic>>> getHealthRecords(
      String tableName, int memberId) async {
    final db = await database;
    return db.query(tableName, where: 'memberId = ?', whereArgs: [memberId]);
  }

  Future<int> insertHealthRecord(
      String tableName, Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(tableName, row);
  }

  Future<int> updateHealthRecord(
      String tableName, Map<String, dynamic> row) async {
    final db = await database;
    final id = row['id'];
    row['synced'] = 0;
    return await db.update(tableName, row, where: 'id = ?', whereArgs: [id]);
  }
}
