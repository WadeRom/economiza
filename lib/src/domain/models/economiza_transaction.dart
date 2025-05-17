import 'package:economiza/src/interfaces/interface_serializable.dart';
import 'package:uuid/uuid.dart';

class EconomizaTransaction implements Serializable{
  final String id;
  final String? description;
  final double amount;
  final DateTime date;
  final int typeId;
  final int stateId;
  final int categoryId;

  EconomizaTransaction({
    String? id,
    this.description,
    required this.amount,
    required this.date,
    required this.typeId,
    required this.stateId,
    required this.categoryId,
  }) : id = id ?? Uuid().v4();

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'amount': amount,
      'description': description,
      'type_id': typeId,
      'state_id': stateId,
      'category_id': categoryId,
    };
  }

  factory EconomizaTransaction.fromJson(Map<String, dynamic> json) {
    return EconomizaTransaction(
      id: json['id'] as String,
      description: json['description'] as String?,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      typeId: json['type_id'] as int,
      stateId: json['state_id'] as int,
      categoryId: json['category_id'] as int,
    );
  }
}