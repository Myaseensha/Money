import 'package:app_money/provider/provider_transaction.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vertical_percent_indicator/vertical_percent_indicator.dart';

import '../../../provider/provider_category.dart';
import '../transactions/widget/all_transaction.dart';
import 'category_add_pop.dart';
import 'expense_category_list.dart';
import 'income_category_list.dart';
import '../basescreen/decoration.dart';

class GraphScreen extends StatefulWidget {
  const GraphScreen({super.key});

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<Providerinstence>(context).refreshUI();
    Provider.of<ProviderTransaction>(context).refreshUI();
    double expense = totalExpense / totalIncome;
    double income = currentBalance / totalIncome;
    if (expense.isNaN || expense.isInfinite || expense < 0) {
      expense = 0;
    }
    if (income.isNaN || income.isInfinite || income < 0) {
      income = 0;
    }
    return SafeArea(
      child: Column(children: [
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(top: 8, left: 60, right: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              VerticalBarIndicator(
                percent: expense,
                header: "${(expense * 100).toInt().round()}%",
                height: 200,
                width: 30,
                color: const [
                  Colors.yellow,
                  Colors.red,
                ],
                footer: 'Expense',
                footerStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black54),
              ),
              VerticalBarIndicator(
                percent: income,
                header: "${(income * 100).toInt().round()}%",
                height: 200,
                width: 30,
                color: const [
                  Colors.green,
                  Colors.yellow,
                ],
                footer: 'Income',
                footerStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black54),
              ),
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(top: 6.0, left: 15, right: 15, bottom: 5),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.purple[100]),
            height: 45,
            child: TabBar(
                isScrollable: true,
                indicatorPadding: const EdgeInsets.all(5),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.purple,
                labelStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                labelPadding: const EdgeInsets.only(
                    left: 45, right: 45, top: 10, bottom: 10),
                indicator: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(20)),
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'Expense',
                  ),
                  Tab(
                    text: 'Income',
                  )
                ]),
          ),
        ),
        Expanded(
          child: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: const [
              ExpenseCategoryList(),
              IncomeCategoryList(),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(180, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(60.0),
                ),
              ),
              onPressed: () {
                addPop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: textBig(
                    text: 'Add Category', size: 17, weight: FontWeight.w600),
              )),
        )
      ]),
    );
  }
}
