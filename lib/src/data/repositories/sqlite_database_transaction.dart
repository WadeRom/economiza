import 'package:economiza/src/interfaces/database/interface_database_transaction.dart';
import 'package:economiza/src/interfaces/interface_uses_cases.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseTransaction implements IDatabaseSimpleTransactionManager {
  final Database _database;
  SqliteDatabaseTransaction(this._database);

  void _validatePlaceholders(String sql, List<Object?> arguments) {
    final placeholderCount = RegExp(r'\?').allMatches(sql).length;
    
    if (placeholderCount != arguments.length) {
      throw ArgumentError(
        'El número de placeholders (?) en el SQL ($placeholderCount) '
        'no coincide con la cantidad de argumentos (${arguments.length}).'
      );
    }
  }

  void _validateRawSql({
    required String sql,
    required String operation,
    required RegExp tableRegExp,
    required List<String> allowedTables,
    required String errorMsgOperation,
    required String errorMsgTable,
  }) {
    final normalized = sql.trimLeft().toUpperCase();
    if (!normalized.startsWith(operation)) {
      throw Exception(errorMsgOperation);
    }
    final tableMatch = tableRegExp.firstMatch(normalized);
    if (tableMatch == null || !allowedTables.contains(tableMatch.group(1)?.toLowerCase())) {
      throw Exception('$errorMsgTable: ${tableMatch?.group(1)}');
    }
  }

  Future<UseCaseResult<int>> rawInsert(String sql, List<Object?> arguments) async {
    try {
      _validatePlaceholders(sql, arguments);
      _validateRawSql(
        sql: sql,
        operation: 'INSERT',
        tableRegExp: RegExp(r'INSERT\s+INTO\s+(\w+)', caseSensitive: false),
        allowedTables: ['transaction_category', 'transaction_state', 'transaction_type', 'transaction'],
        errorMsgOperation: 'Entrada no válida, configuración no válida',
        errorMsgTable: 'Tabla no disponible',
      );

      int result = await _database.rawInsert(sql, arguments);
      return SuccessUseCaseResult(message: "Inserción exitosa", data: result);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error al insertar: ${e.toString()}");
    }
  }

  Future<UseCaseResult<int>> rawUpdate(String sql, List<Object?> arguments) async {
    try {
      _validatePlaceholders(sql, arguments);
      _validateRawSql(
        sql: sql,
        operation: 'UPDATE',
        tableRegExp: RegExp(r'UPDATE\s+(\w+)', caseSensitive: false),
        allowedTables: ['transaction_category', 'transaction_state', 'transaction_type', 'transaction'],
        errorMsgOperation: 'Entrada no válida, configuración no válida',
        errorMsgTable: 'Tabla no disponible',
      );

      int result = await _database.rawUpdate(sql, arguments);
      return SuccessUseCaseResult(message: "Actualización exitosa", data: result);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error al actualizar: ${e.toString()}");
    }
  }

  Future<UseCaseResult<List<Map<String, dynamic>>>> rawQuery(String sql, List<Object?> arguments) async {
    try {
      _validatePlaceholders(sql, arguments);
      _validateRawSql(
        sql: sql,
        operation: 'SELECT',
        tableRegExp: RegExp(r'FROM\s+(\w+)', caseSensitive: false),
        allowedTables: ['transaction_category', 'transaction_state', 'transaction_type', 'transaction'],
        errorMsgOperation: 'Entrada no válida, configuración no válida',
        errorMsgTable: 'Tabla no disponible',
      );

      List<Map<String, dynamic>> result = await _database.rawQuery(sql, arguments);
      return SuccessUseCaseResult(message: "Consulta exitosa", data: result);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error en la consulta: ${e.toString()}");
    }
  }

  @override
  Future<UseCaseResult<int>> insert(SimpleInsertTransactionModel transaction, {String nullColumnHack = ""}) async {
    
    try {

      int result = await _database.insert(
        transaction.storage,
        transaction.record,
        nullColumnHack: nullColumnHack,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      return SuccessUseCaseResult(message: "Inserción exitosa", data: result);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error al insertar: ${e.toString()}");
    }
  }

  @override
  Future<UseCaseResult<int>> update(SimpleUpdateTransactionModel transaction) async {
    try {
      int result = await _database.update(
        transaction.storage,
        transaction.record,
        where: transaction.where,
        whereArgs: transaction.whereArgs,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
      return SuccessUseCaseResult(message: "Actualización exitosa", data: result);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error al actualizar: ${e.toString()}");
    }
  }

  @override
  Future<UseCaseResult<List<Map<String, dynamic>>>> query(SimpleQueryTransactionModel transaction) async {
    try {
      List<Map<String, dynamic>> result = await _database.query(
        transaction.storage,
        distinct: transaction.distinct,
        columns: transaction.columns,
        where: transaction.where,
        whereArgs: transaction.whereArgs,
        groupBy: transaction.groupBy,
        having: transaction.having,
        orderBy: transaction.orderBy,
        limit: transaction.limit,
        offset: transaction.offset,
      );
      return SuccessUseCaseResult(message: "Consulta exitosa", data: result);
    } catch (e) {
      throw FailureUseCaseResult(message: "Error en la consulta: ${e.toString()}");
    }
  }
}
