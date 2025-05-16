import 'package:economiza/src/data/database/sqlite_database_manager.dart';

class EconomizaDatabaseManager {
  static final EconomizaDatabaseManager _instance = EconomizaDatabaseManager._internal();
  factory EconomizaDatabaseManager() => _instance;
  EconomizaDatabaseManager._internal();

  final SQLiteDatabaseManager dbManager = SQLiteDatabaseManager();

  Future<void> connect() async {
    await dbManager.getDatabase();
  }

  Future<void> disconnect() async {
    await dbManager.closeConnectionDB();
  }
}