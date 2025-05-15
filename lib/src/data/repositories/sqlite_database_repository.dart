import 'package:economiza/src/interfaces/database/interface_database_repository.dart';
import 'package:economiza/src/data/database/sqlite_database_manager.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDatabaseRepository implements IDatabaseRepository {
  final SQLiteDatabaseManagerService _databaseService = SQLiteDatabaseManagerService.instance;
  
  @override
  Future<R> transaction<R>(Future<R> Function(Transaction txn) operation) async {
    final db = await _databaseService.database;
    try {
      return await db.transaction((txn) async {
        return await operation(txn);
      });
    } catch (e) {
      print("❌ Error en la transacción: $e");
      throw Exception("Falló la transacción en la base de datos.");
    }
  }

  @override
  Future<int> insert(String table, dynamic data, {Map<String, dynamic>? config}) async {
    if (data is Map<String, Object?>) {
      return await transaction((txn) async {
        return await txn.insert(
          table,
          data,
          nullColumnHack: config?["nullColumnHack"] as String?,
          conflictAlgorithm: config?["conflictAlgorithm"] as ConflictAlgorithm?,
        );
      });
    } else {
      throw Exception("❌ SQLite requiere `Map<String, Object?>` para `insert`.");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> select(String table, dynamic config) async {
    return await transaction((txn) async {
      return await txn.query(
        table,
        distinct: config["distinct"] as bool?,
        columns: config["columns"] as List<String>?,
        where: config["where"] as String?,
        whereArgs: config["whereArgs"] as List<dynamic>?,
        groupBy: config["groupBy"] as String?,
        having: config["having"] as String?,
        orderBy: config["orderBy"] as String?,
        limit: config["limit"] as int?,
        offset: config["offset"] as int?,
      );
    });
  }

  @override
  Future<bool> update(String table, dynamic data, Map<String, dynamic> config) async {
    return await transaction((txn) async {
      return await txn.update(
        table,
        data as Map<String, dynamic>,
        where: config["where"] as String?,
        whereArgs: config["whereArgs"] as List<dynamic>?,
        conflictAlgorithm: config["conflictAlgorithm"] as ConflictAlgorithm?,
      ) > 0;
    });
  }

} 

