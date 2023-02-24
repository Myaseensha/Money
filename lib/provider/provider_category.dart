import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../models/category_model/category_model.dart';
import '../view/screens/basescreen/defulte_category.dart';

const CATEGORY_DB_NAME = 'category-database';

class Providerinstence with ChangeNotifier {
  CategoryType selectedCategory = (CategoryType.income);

  List<CategoryModel> incomeCategoryList = [];
  List<CategoryModel> expenseCategoryList = [];
  Future<List<CategoryModel>> getCategories() async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    notifyListeners();
    return categoryDB.values.toList();
  }

  Future<void> insertCategory(CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(value.id, value);
    notifyListeners();
    refreshUI();
  }

  Future<void> refreshUI() async {
    final allCategories = await getCategories();
    incomeCategoryList.clear();
    expenseCategoryList.clear();
    expenseCategoryList.addAll(defultcategoryexpase);
    incomeCategoryList.addAll(defultcategoryincome);
    await Future.forEach(
      allCategories,
      (
        CategoryModel category,
      ) {
        if (category.type == CategoryType.income) {
          incomeCategoryList.add(category);
        } else {
          expenseCategoryList.add(category);
        }
      },
    );

    notifyListeners();
  }

  Future<void> deleteCategory(String categoryID) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    categoryDB.delete(categoryID);
    refreshUI();
    notifyListeners();
  }

  Future updateCategory(int id, CategoryModel value) async {
    final categoryDB = await Hive.openBox<CategoryModel>(CATEGORY_DB_NAME);
    await categoryDB.put(id, value);
    notifyListeners();
    refreshUI();
  }
}
