import 'package:hive_flutter/hive_flutter.dart';
part 'category_model.g.dart';

@HiveType(typeId: 2)
enum CategoryType {
  @HiveField(0)
  income,
  @HiveField(1)
  expense,
}

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final bool isDelete;
  @HiveField(3)
  final CategoryType type;
  @HiveField(4)
  final String? image;

  CategoryModel(
      {required this.name,
      this.isDelete = false,
      required this.type,
      this.image}) {
    id = DateTime.now().microsecondsSinceEpoch.toString();
  }
}
