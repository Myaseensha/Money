import 'package:app_money/screens/basescreen/decoration.dart';
import 'package:app_money/screens/transactions/widget/all_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../db/category/category_db.dart';
import '../../../db/transation/transation_db.dart';
import '../../../home/widgets/search.dart';
import '../../../models/transaction_model/transaction_model.dart';

class HistroyPage extends StatefulWidget {
  const HistroyPage({super.key});

  @override
  State<HistroyPage> createState() => _HistroyPageState();
}

class _HistroyPageState extends State<HistroyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    CategoryDB().refreshUI();
    transactionlist;
    expensetransationNotifier;
    incometransationNotifier;
    results = transactionlist.value;
    super.initState();
    _tabController.addListener(() {
      final DateTime now = DateTime.now();
      setState(() {
        if (dropDownVale == 'All') {
          setState(() {
            results = (_tabController.index == 0
                ? transactionlist.value.toList()
                : _tabController.index == 1
                    ? incometransationNotifier.value.toList()
                    : expensetransationNotifier.value.toList());
          });
        } else if (dropDownVale == 'today') {
          setState(() {
            results = (_tabController.index == 0
                    ? transactionlist.value.toList()
                    : _tabController.index == 1
                        ? incometransationNotifier.value.toList()
                        : expensetransationNotifier.value.toList())
                .where((element) => parseDate(element.calender)
                    .toLowerCase()
                    .contains(parseDate(DateTime.now()).toLowerCase()))
                .toList();
          });
        } else if (dropDownVale == 'yesterday') {
          setState(() {
            DateTime start = DateTime(now.year, now.month, now.day - 1);
            DateTime end = start.add(const Duration(days: 1));
            results = (_tabController.index == 0
                    ? transactionlist.value
                    : _tabController.index == 1
                        ? incometransationNotifier.value
                        : expensetransationNotifier.value)
                .where((element) =>
                    (element.calender.isAfter(start) ||
                        element.calender == start) &&
                    element.calender.isBefore(end))
                .toList();
          });
        } else if (dropDownVale == 'week') {
          setState(() {
            DateTime start = DateTime(now.year, now.month, now.day - 6);
            DateTime end = DateTime(start.year, start.month, start.day + 7);
            results = (_tabController.index == 0
                    ? transactionlist.value
                    : _tabController.index == 1
                        ? incometransationNotifier.value
                        : expensetransationNotifier.value)
                .where((element) =>
                    (element.calender.isAfter(start) ||
                        element.calender == start) &&
                    element.calender.isBefore(end))
                .toList();
          });
        } else {
          setState(() {
            DateTime start =
                DateTime(selectedmonth.year, selectedmonth.month, 1);
            DateTime end = DateTime(start.year, start.month + 1, start.day);
            results = (_tabController.index == 0
                    ? transactionlist.value
                    : _tabController.index == 1
                        ? incometransationNotifier.value
                        : expensetransationNotifier.value)
                .where((element) =>
                    (element.calender.isAfter(start) ||
                        element.calender == start) &&
                    element.calender.isBefore(end))
                .toList();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  dynamic dropDownVale = 'All';
  List items = ['All', 'today', 'yesterday', 'week', 'custom'];
  DateTime selectedmonth = DateTime.now();
  void _selectDate(context) async {
    final DateTime? picked = await showDatePicker(
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: Color.fromARGB(
                    212, 158, 13, 231), // header background color
                onPrimary: Colors.white, // header text color
                onSurface: Color.fromARGB(212, 158, 13, 231), // body text color
              ),
            ),
            child: child!,
          );
        },
        context: context,
        initialDate: selectedmonth,
        firstDate: DateTime(2021),
        lastDate: DateTime(2030));

    if (picked != null && picked != selectedmonth) {
      setState(() {
        selectedmonth = picked;
      });
    }
  }

  String parseDate(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  List<TransactionModel> results = [];

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await TransactionDb.instance.refreshUI();
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                showSearch(context: context, delegate: MainSerchDelegate()),
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  alignment: Alignment.centerRight,
                  child: DropdownButton(
                      icon: const Icon(
                        Icons.menu_outlined,
                        color: Colors.purple,
                      ),
                      underline: Container(),
                      elevation: 0,
                      borderRadius: BorderRadius.circular(10),
                      items: items.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue == 'custom') {
                          _selectDate(context);
                        }

                        setState(() {
                          dropDownVale = newValue;
                        });
                        final DateTime now = DateTime.now();
                        if (dropDownVale == 'All') {
                          setState(() {
                            results = (_tabController.index == 0
                                ? transactionlist.value.toList()
                                : _tabController.index == 1
                                    ? incometransationNotifier.value.toList()
                                    : expensetransationNotifier.value.toList());
                          });
                        } else if (dropDownVale == 'today') {
                          setState(() {
                            results = (_tabController.index == 0
                                    ? transactionlist.value.toList()
                                    : _tabController.index == 1
                                        ? incometransationNotifier.value
                                            .toList()
                                        : expensetransationNotifier.value
                                            .toList())
                                .where((element) => parseDate(element.calender)
                                    .toLowerCase()
                                    .contains(parseDate(DateTime.now())
                                        .toLowerCase()))
                                .toList();
                          });
                        } else if (dropDownVale == 'yesterday') {
                          setState(() {
                            DateTime start =
                                DateTime(now.year, now.month, now.day - 1);
                            DateTime end = start.add(const Duration(days: 1));
                            results = (_tabController.index == 0
                                    ? transactionlist.value
                                    : _tabController.index == 1
                                        ? incometransationNotifier.value
                                        : expensetransationNotifier.value)
                                .where((element) =>
                                    (element.calender.isAfter(start) ||
                                        element.calender == start) &&
                                    element.calender.isBefore(end))
                                .toList();
                          });
                        } else if (dropDownVale == 'week') {
                          setState(() {
                            DateTime start =
                                DateTime(now.year, now.month, now.day - 6);
                            DateTime end = DateTime(
                                start.year, start.month, start.day + 7);
                            results = (_tabController.index == 0
                                    ? transactionlist.value
                                    : _tabController.index == 1
                                        ? incometransationNotifier.value
                                        : expensetransationNotifier.value)
                                .where((element) =>
                                    (element.calender.isAfter(start) ||
                                        element.calender == start) &&
                                    element.calender.isBefore(end))
                                .toList();
                          });
                        } else {
                          setState(() {
                            DateTime start = DateTime(
                                selectedmonth.year, selectedmonth.month, 1);
                            DateTime end = DateTime(
                                start.year, start.month + 1, start.day);
                            results = (_tabController.index == 0
                                    ? transactionlist.value
                                    : _tabController.index == 1
                                        ? incometransationNotifier.value
                                        : expensetransationNotifier.value)
                                .where((element) =>
                                    (element.calender.isAfter(start) ||
                                        element.calender == start) &&
                                    element.calender.isBefore(end))
                                .toList();
                          });
                        }
                      }),
                ),
                Container(
                    padding: const EdgeInsets.only(right: 22, left: 5),
                    child: textBig(
                        text: "Filter", size: 17, color: Colors.purple)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 5.0, left: 10, right: 10, bottom: 10),
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
                    labelStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                    labelPadding: const EdgeInsets.only(
                        left: 25, right: 25, top: 10, bottom: 10),
                    indicator: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(20)),
                    controller: _tabController,
                    tabs: const [
                      Tab(
                        text: 'All',
                      ),
                      Tab(
                        text: 'Income',
                      ),
                      Tab(
                        text: 'Expense',
                      )
                    ]),
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  RecentTransaction(result: results),
                  RecentTransaction(result: results),
                  RecentTransaction(result: results),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
