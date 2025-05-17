import 'package:economiza/src/data/database/economiza_database_manager.dart';
import 'package:economiza/src/data/repositories/sqlite_database_transaction.dart';
import 'package:economiza/src/interfaces/database/interface_database_transaction.dart';

class EconomizaDatabaseTransaction implements IDatabaseSimpleTransactionManager {
  final Future<SqliteDatabaseTransaction> _sqliteTransactionFuture;

  EconomizaDatabaseTransaction(EconomizaDatabaseManager manager)
      : _sqliteTransactionFuture = manager.dbManager.getDatabase().then(
            (db) => SqliteDatabaseTransaction(db),
          );

  @override
  Future<int> insert(SimpleInsertTransactionModel transaction) async {
    final sqliteTransaction = await _sqliteTransactionFuture;
    return await sqliteTransaction.insert(transaction);
  }

  @override
  Future<List<Map<String, dynamic>>> query(SimpleQueryTransactionModel transaction) async {
    final sqliteTransaction = await _sqliteTransactionFuture;
    return await sqliteTransaction.query(transaction);
  }

  @override
  Future<int> update(SimpleUpdateTransactionModel transaction) async {
    final sqliteTransaction = await _sqliteTransactionFuture;
    return await sqliteTransaction.update(transaction);
  }
}