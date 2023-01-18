import 'package:app_money/db/transation/transation_db.dart';
import 'package:app_money/screens/category/category_graph_screen.dart';
import 'package:app_money/screens/transactions/widget/histroy.dart';
import 'package:app_money/screens/transactions/screen_transaction.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../setting/settings_screen.dart';

double currentBalance = 0;
double totalIncome = 0;
double totalExpense = 0;

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  static ValueNotifier<int> selectedIndexNotifire = ValueNotifier(0);

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final _pages = [
    const Screentransaction(),
    const HistroyPage(),
    const GraphScreen(),
    const Profile()
  ];
  @override
  void initState() {
    TransactionDb.instance.refreshUI();
    super.initState();
  }

  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 249, 233, 252),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(10),
          child: SafeArea(
            child: GNav(
              duration: const Duration(milliseconds: 700),
              gap: 10,
              tabBackgroundColor: Colors.purple,
              padding: const EdgeInsets.all(9),
              color: Colors.purple,
              activeColor: Colors.white,
              onTabChange: (newIndex) {
                setState(() {
                  currentindex = newIndex;
                });
              },
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Transaction',
                ),
                GButton(
                  icon: Icons.history,
                  text: 'History',
                ),
                GButton(
                  icon: Icons.auto_graph,
                  text: 'Graph',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                )
              ],
            ),
          ),
        ),
        body: SafeArea(child: _pages[currentindex]));
  }
}
