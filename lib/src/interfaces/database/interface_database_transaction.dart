import 'package:economiza/src/interfaces/interface_uses_cases.dart';

enum DatabaseOperationType { insert, update, query, rawInsert, rawUpdate, rawQuery }

class DatabaseOperation {
  final DatabaseOperationType type;
  final String sql;
  final List<Object?> arguments;

  DatabaseOperation({
    required this.type,
    required this.sql,
    required this.arguments,
  });
}

class SimpleInsertTransactionModel {
  final String storage; // REQUERIDO: siempre necesitas saber la tabla
  final Map<String, dynamic> record; // REQUERIDO: siempre necesitas datos a insertar

  SimpleInsertTransactionModel({
    required this.storage,
    required this.record,
  });
}

class SimpleQueryTransactionModel {
  final String storage; // REQUERIDO
  final bool? distinct; // OPCIONAL
  final List<String>? columns; // OPCIONAL
  final String? where; // OPCIONAL
  final List<dynamic>? whereArgs; // OPCIONAL
  final String? orderBy; // OPCIONAL
  final String? groupBy; // OPCIONAL
  final String? having; // OPCIONAL
  final int? limit; // OPCIONAL
  final int? offset; // OPCIONAL

  SimpleQueryTransactionModel({
    required this.storage,
    this.distinct,
    this.columns,
    this.where,
    this.whereArgs,
    this.orderBy,
    this.groupBy,
    this.having,
    this.limit,
    this.offset,
  });
}

class SimpleUpdateTransactionModel {
  final String storage; // REQUERIDO
  final Map<String, dynamic> record; // REQUERIDO
  final String? where; // OPCIONAL
  final List<dynamic>? whereArgs; // OPCIONAL

  SimpleUpdateTransactionModel({
    required this.storage,
    required this.record,
    this.where,
    this.whereArgs,
  });
}

abstract class IDatabaseSimpleTransactionManager {
  Future<UseCaseResult<int>> insert(SimpleInsertTransactionModel transaction);
  Future<UseCaseResult<int>> update(SimpleUpdateTransactionModel transaction);
  Future<UseCaseResult<List<Map<String, dynamic>>>> query(SimpleQueryTransactionModel transaction);
}