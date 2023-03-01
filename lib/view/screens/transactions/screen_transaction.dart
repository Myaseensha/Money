import 'package:app_money/provider/provider_transaction.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/category_model/category_model.dart';
import '../basescreen/decoration.dart';
import 'expense_add.dart';
import 'incom_add.dart';
import 'widget/all_transaction.dart';

class Screentransaction extends StatelessWidget {
  const Screentransaction({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 233, 252),
        body: Consumer<ProviderTransaction>(
          builder: (context, value, child) {
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
                                  child:
                                      Image.asset('assets/image/expenss.jpg'),
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
                    result: value.transactionlist,
                  )),
                ],
              ),
            );
          },
        ));
  }

  void getBalance(context) async {
    currentBalance = 0;
    totalIncome = 0;
    totalExpense = 0;
    for (var element
        in Provider.of<ProviderTransaction>(context).transactionlist) {
      if (element.type == CategoryType.income) {
        currentBalance = currentBalance + element.amount;
        totalIncome = totalIncome + element.amount;
      } else {
        currentBalance = currentBalance - element.amount;
        totalExpense = totalExpense + element.amount;
      }
    }
  }
}
