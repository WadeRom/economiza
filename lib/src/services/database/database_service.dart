import 'package:economiza/src/services/base_service.dart';
import 'package:economiza/src/services/database/sql_scripts.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService extends BaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  @override
  Future<void> initService() async {
    await database; // Inicializa la base de datos cuando se llame a initService()
  }

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'economiza.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(createTransactionCategoryTable);
        await db.execute(createTransactionStateTable);
        await db.execute(createTransactionTypeTable);
        await db.execute(createTransactionTable);
      },
    );
  }
}
