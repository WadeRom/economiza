import 'package:economiza/src/interfaces/database/interface_database_transaction.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseTransaction implements IDatabaseSimpleTransactionManager {
  final Database _database;
  SqliteDatabaseTransaction(this._database);

  // Método privado para validar la cantidad de placeholders en la consulta SQL
  void _validatePlaceholders(String sql, List<Object?> arguments) {
    final placeholderCount = RegExp(r'\?').allMatches(sql).length;
    
    if (placeholderCount != arguments.length) {
      throw ArgumentError(
        'El número de placeholders (?) en el SQL ($placeholderCount) '
        'no coincide con la cantidad de argumentos (${arguments.length}).'
      );
    }

  }

  // Método privado para validar sentencias SQL y tablas permitidas
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

  Future<int> rawInsert(String sql, List<Object?> arguments) async {
    const allowedTables = ['transaction_category', 'transaction_state', 'transaction_type', 'transaction'];
    
    _validatePlaceholders(sql, arguments);
    _validateRawSql(
      sql: sql,
      operation: 'INSERT',
      tableRegExp: RegExp(r'INSERT\s+INTO\s+(\w+)', caseSensitive: false),
      allowedTables: allowedTables,
      errorMsgOperation: 'Entrada no válida, configuración no válida',
      errorMsgTable: 'Tabla no disponible',
    );

    return await _database.rawInsert(sql, arguments);
  }

  Future<int> rawUpdate(String sql, List<Object?> arguments) async {
    const allowedTables = ['transaction_category', 'transaction_state', 'transaction_type', 'transaction'];
    
    _validatePlaceholders(sql, arguments);
    _validateRawSql(
      sql: sql,
      operation: 'UPDATE',
      tableRegExp: RegExp(r'UPDATE\s+(\w+)', caseSensitive: false),
      allowedTables: allowedTables,
      errorMsgOperation: 'Entrada no válida, configuración no válida',
      errorMsgTable: 'Tabla no disponible',
    );
    

    return await _database.rawUpdate(sql, arguments);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql, List<Object?> arguments) async {
    const allowedTables = ['transaction_category', 'transaction_state', 'transaction_type', 'transaction'];
    
    _validatePlaceholders(sql, arguments);
    _validateRawSql(
      sql: sql,
      operation: 'SELECT',
      tableRegExp: RegExp(r'FROM\s+(\w+)', caseSensitive: false),
      allowedTables: allowedTables,
      errorMsgOperation: 'Entrada no válida, configuración no válida',
      errorMsgTable: 'Tabla no disponible',
    );

    return await _database.rawQuery(sql, arguments);
  }

  @override
  Future<int> insert(SimpleInsertTransactionModel transaction, {String nullColumnHack = ""}) async {
    return await _database.insert(
      transaction.storage,
      transaction.record,
      nullColumnHack: nullColumnHack,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<int> update(SimpleUpdateTransactionModel transaction) async {
    return await _database.update(
      transaction.storage,
      transaction.record,
      where: transaction.where,
      whereArgs: transaction.whereArgs,
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> query(SimpleQueryTransactionModel transaction) async {
    return await _database.query(
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
  }

  //Metodo para ejecutar transacciones atomicas
  //Si una de las operaciones falla, se revertiran todas las operaciones
  //Esto es util para mantener la integridad de los datos
  Future<T> runTransaction<T>(Future<T> Function(Transaction txn) operations) async {
    return await _database.transaction((txn) async {
      return await operations(txn);
    });
  }

  //Metodo para ejecutar operaciones en una transaccion
  //Esto es util para mantener la integridad de los datos
  Future<List<dynamic>> batchTransaction(Future<void> Function(Batch batch) operations) async {
    final Batch batch = _database.batch();
    await operations(batch); // El callback recibe el batch para agregar operaciones
    return await batch.commit(noResult: false); // Devuelve los resultados del batch
  }

  
}
