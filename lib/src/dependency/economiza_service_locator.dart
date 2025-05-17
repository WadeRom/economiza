import 'package:economiza/src/data/database/economiza_database_manager.dart';
import 'package:economiza/src/data/repositories/economiza_database_transaction.dart';

class EconomizaServiceLocator {
  static final EconomizaServiceLocator _instance =
      EconomizaServiceLocator._internal();

  late final EconomizaDatabaseTransaction databaseTransaction;

  EconomizaServiceLocator._internal();

  factory EconomizaServiceLocator() {
    return _instance;
  }

  Future<void> init() async {
    final dbManager = EconomizaDatabaseManager();
    try {
      await dbManager.connect();
    } catch (e) {
      throw('Error connecting to the database: $e');
    }; // Asegúrate de que connect sea asíncrono
    databaseTransaction = EconomizaDatabaseTransaction(dbManager);
  }
}

final economizaServiceLocator = EconomizaServiceLocator();