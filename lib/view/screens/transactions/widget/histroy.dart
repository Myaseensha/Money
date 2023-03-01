import 'package:app_money/provider/provider_transaction.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../basescreen/decoration.dart';
import '../../../home/widgets/search.dart';
import 'all_transaction.dart';

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
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List items = ['All', 'today', 'yesterday', 'week', 'custom'];
  DateTime selectedmonth = DateTime.now();

  String parseDate(DateTime date) {
    return DateFormat.MMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await Provider.of<ProviderTransaction>(context, listen: false)
          .refreshUI();
    });
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        backgroundColor: Colors.purple,
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
        top: false,
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
                        Provider.of<ProviderTransaction>(context, listen: false)
                            .menu(
                                dropDownVale: newValue,
                                tabController: _tabController.index);
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
                  RecentTransaction(
                      result:
                          Provider.of<ProviderTransaction>(context).results),
                  RecentTransaction(
                      result:
                          Provider.of<ProviderTransaction>(context).results),
                  RecentTransaction(
                      result:
                          Provider.of<ProviderTransaction>(context).results),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
