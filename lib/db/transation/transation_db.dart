import 'package:app_money/models/transaction_model/transaction_model.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/category_model/category_model.dart';
import 'package:month_year_picker/month_year_picker.dart';

// ignore: constant_identifier_names
const TRANSACTION_DB_NAME = 'tansaction-db';

ValueNotifier<List<TransactionModel>> transactionlist = ValueNotifier([]);
ValueNotifier<List<TransactionModel>> incometransationNotifier =
    ValueNotifier([]);
ValueNotifier<List<TransactionModel>> expensetransationNotifier =
    ValueNotifier([]);

class TransactionDb {
  TransactionDb._instance();
  late DateTime startDate;
  late DateTime endDate;
  late List<TransactionModel> filterList;
  late List<TransactionModel> list;
  bool isFilterEnable = false;
  static TransactionDb instance = TransactionDb._instance();
  factory TransactionDb() {
    return instance;
  }

  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.put(obj.id, obj);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    transactionlist.notifyListeners();

    refreshUI();
  }

  Future<List<TransactionModel>> getalltransaction() async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    transactionlist.notifyListeners();
    return db.values.toList();
  }

  Future<void> refreshUI() async {
    final alltransaction = await getalltransaction();
    incometransationNotifier.value.clear();
    expensetransationNotifier.value.clear();

    await Future.forEach(alltransaction, (TransactionModel transaction) {
      if (transaction.type == CategoryType.income) {
        incometransationNotifier.value.add(transaction);
      } else if (transaction.type == CategoryType.expense) {
        expensetransationNotifier.value.add(transaction);
      }

      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      incometransationNotifier.notifyListeners();
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      expensetransationNotifier.notifyListeners();
    });
    transactionlist.value.clear();

    transactionlist.value.addAll(alltransaction);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    incometransationNotifier.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    expensetransationNotifier.notifyListeners();
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    transactionlist.notifyListeners();
  }

  Future<void> deletTransaction(String transactionId) async {
    final transaction =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);

    transaction.delete(transactionId);

    refreshUI();
  }

  Future updateTransaction(int id, TransactionModel value) async {
    final categoryDB =
        await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    categoryDB.putAt(id, value);

    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    transactionlist.notifyListeners();
    refreshUI();
  }

  setFilter(DateTime start, DateTime end) {
    startDate = start;
    endDate = end;
    isFilterEnable = true;
    refreshUI();
  }

  clearFilter() {
    isFilterEnable = false;
    refreshUI();
  }

  DateTime selectedmonth = DateTime.now();

  transactionPickDate(context) async {
    final selected = await showMonthYearPicker(
      context: context,
      initialDate: selectedmonth,
      firstDate: DateTime(2021),
      lastDate: DateTime(2030),
    );

    selectedmonth = selected!;
    DateTime start = DateTime(selectedmonth.year, selectedmonth.month, 1);
    DateTime end = DateTime(start.year, start.month + 1, start.day);
    setFilter(start, end);
  }
}
