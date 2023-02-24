import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:month_year_picker/month_year_picker.dart';
import '../models/category_model/category_model.dart';
import '../models/transaction_model/transaction_model.dart';
import 'package:intl/intl.dart';

// ignore: constant_identifier_names
const TRANSACTION_DB_NAME = 'tansaction-db';

class ProviderTransaction with ChangeNotifier {
  List<TransactionModel> transactionlist = ([]);
  List<TransactionModel> incometransationNotifier = ([]);
  List<TransactionModel> expensetransationNotifier = ([]);
  List<TransactionModel> results = [];
  late DateTime startDate;
  late DateTime endDate;
  late List<TransactionModel> filterList;
  late List<TransactionModel> list;
  bool isFilterEnable = false;

  Future<void> addTransaction(TransactionModel obj) async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    await db.put(obj.id, obj);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

    refreshUI();
  }

  Future<List<TransactionModel>> getalltransaction() async {
    final db = await Hive.openBox<TransactionModel>(TRANSACTION_DB_NAME);
    // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
    notifyListeners();
    return db.values.toList();
  }

  Future<void> refreshUI() async {
    final alltransaction = await getalltransaction();
    incometransationNotifier.clear();
    expensetransationNotifier.clear();

    await Future.forEach(alltransaction, (TransactionModel transaction) {
      if (transaction.type == CategoryType.income) {
        incometransationNotifier.add(transaction);
      } else if (transaction.type == CategoryType.expense) {
        expensetransationNotifier.add(transaction);
      }
      notifyListeners();
    });
    transactionlist.clear();

    transactionlist.addAll(alltransaction);
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

    notifyListeners();
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

  menu({required dropDownVale, required tabController}) {
    final DateTime now = DateTime.now();

    String parseDate(DateTime date) {
      return DateFormat.MMMd().format(date);
    }

    if (dropDownVale == 'All') {
      results = (tabController.index == 0
          ? transactionlist.toList()
          : tabController.index == 1
              ? incometransationNotifier.toList()
              : expensetransationNotifier.toList());
    } else if (dropDownVale == 'today') {
      results = (tabController.index == 0
              ? transactionlist.toList()
              : tabController.index == 1
                  ? incometransationNotifier.toList()
                  : expensetransationNotifier.toList())
          .where((element) => parseDate(element.calender)
              .toLowerCase()
              .contains(parseDate(DateTime.now()).toLowerCase()))
          .toList();
    } else if (dropDownVale == 'yesterday') {
      DateTime start = DateTime(now.year, now.month, now.day - 1);
      DateTime end = start.add(const Duration(days: 1));
      results = (tabController.index == 0
              ? transactionlist
              : tabController.index == 1
                  ? incometransationNotifier
                  : expensetransationNotifier)
          .where((element) =>
              (element.calender.isAfter(start) || element.calender == start) &&
              element.calender.isBefore(end))
          .toList();
    } else if (dropDownVale == 'week') {
      DateTime start = DateTime(now.year, now.month, now.day - 6);
      DateTime end = DateTime(start.year, start.month, start.day + 7);
      results = (tabController.index == 0
              ? transactionlist
              : tabController.index == 1
                  ? incometransationNotifier
                  : expensetransationNotifier)
          .where((element) =>
              (element.calender.isAfter(start) || element.calender == start) &&
              element.calender.isBefore(end))
          .toList();
    } else {
      DateTime start = DateTime(selectedmonth.year, selectedmonth.month, 1);
      DateTime end = DateTime(start.year, start.month + 1, start.day);
      results = (tabController.index == 0
              ? transactionlist
              : tabController.index == 1
                  ? incometransationNotifier
                  : expensetransationNotifier)
          .where((element) =>
              (element.calender.isAfter(start) || element.calender == start) &&
              element.calender.isBefore(end))
          .toList();
    }
    notifyListeners();
    log("$results///////////////////////////////////////////////////");
  }
}
