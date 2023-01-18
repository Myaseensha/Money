import 'package:app_money/db/category/category_db.dart';
import 'package:app_money/home/screen_home.dart';

import 'package:flutter/material.dart';
import '../../db/transation/transation_db.dart';
import '../../models/category_model/category_model.dart';
import '../../models/transaction_model/transaction_model.dart';
import '../basescreen/decoration.dart';
import 'expense_add.dart';
import 'incom_add.dart';
import 'widget/all_transaction.dart';

class Screentransaction extends StatefulWidget {
  const Screentransaction({super.key});

  @override
  State<Screentransaction> createState() => _ScreentransactionState();
}

class _ScreentransactionState extends State<Screentransaction> {
  @override
  void initState() {
    CategoryDB.instance.refreshUI();
    transactionlist.value;
    CategoryDB.instance.expenseCategoryList.value;
    CategoryDB.instance.incomeCategoryList.value;
    TransactionDb.instance.refreshUI();
    getBalance();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      body: ValueListenableBuilder(
        valueListenable: transactionlist,
        builder:
            (BuildContext context, List<TransactionModel> newvalue, Widget? _) {
          return SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: textBigG(text: 'Account Balance'),
                ),
                textBigB(text: '₹ $currentBalance'),
                GestureDetector(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.green,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/image/incom.jpg'),
                              ),
                            ),
                            title: Title(
                              color: Colors.white,
                              child: const Text(
                                'Income',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ),
                            subtitle: Title(
                              color: Colors.white,
                              child: Text(
                                '₹ $totalIncome',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const IncomScreen()));
                  },
                ),
                GestureDetector(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Container(
                      height: 75,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.asset('assets/image/expenss.jpg'),
                              ),
                            ),
                            title: Title(
                              color: Colors.white,
                              child: const Text(
                                'Expense',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18),
                              ),
                            ),
                            subtitle: Title(
                              color: Colors.white,
                              child: Text(
                                '₹ $totalExpense',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ExpenssScreen()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: textBigB(
                        text: ' Recent Transactions',
                        size: 20,
                        weight: FontWeight.w600),
                  ),
                ),
                Expanded(
                    child: RecentTransaction(
                  result: newvalue,
                )),
              ],
            ),
          );
        },
      ),
    );
  }

  void getBalance() async {
    currentBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    for (var element in transactionlist.value) {
      if (element.type == CategoryType.income) {
        setState(() {
          currentBalance = currentBalance + element.amount;
          totalIncome = totalIncome + element.amount;
        });
      } else {
        setState(() {
          currentBalance = currentBalance - element.amount;
          totalExpense = totalExpense + element.amount;
        });
      }
    }
  }
}
