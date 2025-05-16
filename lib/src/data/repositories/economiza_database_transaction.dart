import 'package:economiza/src/interfaces/database/interface_database_transaction.dart';

class EconomizaDatabaseTransaction {
  final IDatabaseSimpleTransactionManager _databaseTransactionManager;
  EconomizaDatabaseTransaction(this._databaseTransactionManager);

  Future<int> insert(SimpleInsertTransactionModel transaction) async {
    return await _databaseTransactionManager.insert(transaction);
  }

  Future<List<Map<String, dynamic>>> query(SimpleQueryTransactionModel transaction) async {
    return await _databaseTransactionManager.query(transaction);
  }

  Future<int> update(SimpleUpdateTransactionModel transaction) async {
    return await _databaseTransactionManager.update(transaction);
  }

}