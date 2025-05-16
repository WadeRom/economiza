import 'package:economiza/src/interfaces/database/interface_database_serializable.dart';

class EconomizaCategorySummary implements Serializable{
  final int id;
  final String category;
  final String description;

  EconomizaCategorySummary({
    required this.id,
    required this.category,
    required this.description,
  });
  
  factory EconomizaCategorySummary.fromJson(Map<String, dynamic> json) {
    return EconomizaCategorySummary(
      id: json['id'] as int,
      category: json['category'] as String,
      description: json['description'] as String,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description 
    };
  }

}
