import 'package:economiza/src/domain/models/economiza_category_summary.dart';
import 'package:economiza/src/interfaces/interface_serializable.dart';

class EconomizaTransactionSummary implements Serializable {
  final double totalExpenses;
  final double totalIncome;
  final double totalBalance;
  final List<EconomizaCategorySummary> categorySummaries;

  EconomizaTransactionSummary({
    required this.totalExpenses,
    required this.totalIncome,
    required this.totalBalance,
    required this.categorySummaries,
  });

  factory EconomizaTransactionSummary.fromJson(Map<String, dynamic> json) {
    return EconomizaTransactionSummary(
      totalExpenses: json['total_expenses'] as double,
      totalIncome: json['total_income'] as double,
      totalBalance: json['total_balance'] as double,
      categorySummaries: (json['category_summaries'] as List)
          .map((e) => EconomizaCategorySummary.fromJson(e))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'total_expenses': totalExpenses,
      'total_income': totalIncome,
      'total_balance': totalBalance,
      'category_summaries': categorySummaries.map((e) => e.toJson()).toList(),
    };
  }

}