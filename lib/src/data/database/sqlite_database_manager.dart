import 'package:economiza/src/interfaces/database/interface_database_manager.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteDatabaseManagerService implements IDatabaseService {
  static final SQLiteDatabaseManagerService _singleton = SQLiteDatabaseManagerService._internal();
  static Database? _db;

  SQLiteDatabaseManagerService._internal();
  static SQLiteDatabaseManagerService get instance => _singleton;

  @override
  Future<void> connect() async {
    if (_db != null) return;

    String path = join(await getDatabasesPath(), 'economiza.db');
    
    try {
      _db = await openDatabase(path, version: 1);
      print("✅ Base de datos conectada en $path");
    } catch (e) {
      print("❌ Error al conectar la BD: $e");
    }
  }

  @override
  Future<void> close() async {
    await _db?.close();
    _db = null;
    print("🚪 Conexión cerrada");
  }

  @override
  Future<Database> get database async {
    await connect();
    return _db!;
  }
}