import 'package:economiza/src/data/database/economiza_database_manager.dart';
import 'package:economiza/src/data/repositories/sqlite_database_transaction.dart';
import 'package:economiza/src/interfaces/database/interface_database_transaction.dart';
import 'package:economiza/src/interfaces/interface_uses_cases.dart';

class EconomizaDatabaseTransaction implements IDatabaseSimpleTransactionManager {
  final Future<SqliteDatabaseTransaction> _sqliteTransactionFuture;

  EconomizaDatabaseTransaction(EconomizaDatabaseManager manager)
      : _sqliteTransactionFuture = manager.dbManager.getDatabase().then(
            (db) => SqliteDatabaseTransaction(db),
          );

  @override
  Future<UseCaseResult<int>> insert(SimpleInsertTransactionModel transaction) async {
    try {
      final sqliteTransaction = await _sqliteTransactionFuture;
      return await sqliteTransaction.insert(transaction);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error al insertar: ${e.toString()}");
    }
  }

  @override
  Future<UseCaseResult<List<Map<String, dynamic>>>> query(SimpleQueryTransactionModel transaction) async {
    try {
      final sqliteTransaction = await _sqliteTransactionFuture;
      return await sqliteTransaction.query(transaction);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error en la consulta: ${e.toString()}");
    }
  }

  @override
  Future<UseCaseResult<int>> update(SimpleUpdateTransactionModel transaction) async {
    try {
      final sqliteTransaction = await _sqliteTransactionFuture;
      return await sqliteTransaction.update(transaction);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error al actualizar: ${e.toString()}");
    }
  }
}
