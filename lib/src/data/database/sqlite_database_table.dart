import 'package:economiza/src/interfaces/database/interface_database_schema.dart';
import 'package:sqflite/sqlite_api.dart';

class SQLiteTableManager implements IDatabaseTableManager {
  final Database db;

  SQLiteTableManager(this.db);

  Future<bool> tableExists(String tableName) async {
    final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      [tableName],
    );
    return result.isNotEmpty;
  }

  @override
  Future<void> createTable(String tableName, List<String> columns) async {
    if (tableName.isEmpty || columns.isEmpty) {
      print("❌ Error: Nombre de tabla o columnas vacías.");
      return;
    }

    // Verifica si la tabla ya existe
    if (await tableExists(tableName)) {
      print("⚠️ La tabla '$tableName' ya existe.");
      return;
    }

    try {
      String query = "CREATE TABLE IF NOT EXISTS $tableName (${columns.join(", ")})";
      await db.execute(query);
      print("✅ Tabla '$tableName' creada exitosamente.");
    } catch (e) {
      print("❌ Error al crear la tabla '$tableName': $e");
    }
  }

  @override
  Future<void> alterTable(String tableName, String operation, String columnDefinition) async {
    String query = "ALTER TABLE $tableName $operation COLUMN $columnDefinition";
    await db.execute(query);
    print("✅ Tabla '$tableName' modificada: $operation $columnDefinition.");
  }
}
