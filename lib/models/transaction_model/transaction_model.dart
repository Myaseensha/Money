import 'package:hive_flutter/adapters.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../category_model/category_model.dart';
part 'transaction_model.g.dart';

@HiveType(typeId: 3)
class TransactionModel {
  @HiveField(0)
  String? id;

  @HiveField(1)
  final CategoryModel category;

  @HiveField(2)
  final int amount;

  @HiveField(3)
  late final CategoryType type;

  @HiveField(4)
  final String description;

  @HiveField(5)
  late final DateTime calender;

  TransactionModel({
    required this.category,
    required this.type,
    required this.amount,
    required this.description,
    required this.calender,
  }) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
