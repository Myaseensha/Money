import 'package:app_money/setting/terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model/category_model.dart';
import '../models/transaction_model/transaction_model.dart';
import '../screens/basescreen/decoration.dart';
import '../screens/basescreen/splash_screen.dart';
import 'about.dart';
import 'privacy.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

String username = '';

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    autoLogIn();
    super.initState();
  }

  void autoLogIn() async {
    WidgetsFlutterBinding.ensureInitialized();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('nameKey').toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        elevation: 0.0,
      ),
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5),
            child: Container(
              alignment: Alignment.centerLeft,
              child: textBigG(text: 'Username'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 50),
            child: Container(
              alignment: Alignment.centerLeft,
              child: textBig(text: username, color: Colors.black, size: 25),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.black),
            title: textBigB(text: 'About', size: 15, align: TextAlign.start),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const MyAbout();
                },
              ),
            ),
          ),
          ListTile(
            leading:
                const Icon(Icons.privacy_tip_outlined, color: Colors.black),
            title: textBigB(
                text: 'Privacy policy', size: 15, align: TextAlign.start),
            trailing: const Icon(Icons.arrow_forward, color: Colors.black),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const privacy();
                },
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.message, color: Colors.black),
            title: textBigB(
                text: 'Trems and Condition', size: 15, align: TextAlign.start),
            trailing: const Icon(
              Icons.arrow_forward,
              color: Colors.black,
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const myTerms();
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: ListTile(
                onTap: () async {
                  showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            backgroundColor:
                                const Color.fromRGBO(206, 147, 216, 1),
                            content:
                                textBig(text: 'Do you want logout ', size: 20),
                            actions: [
                              MaterialButton(
                                color: Colors.purple,
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: const Text(
                                  'No',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              MaterialButton(
                                color: Colors.white,
                                onPressed: () async {
                                  Navigator.pushAndRemoveUntil(context,
                                      MaterialPageRoute(
                                    builder: (context) {
                                      return const SplashScreen();
                                    },
                                  ), (route) => false);
                                  final categoryDB =
                                      await Hive.openBox<CategoryModel>(
                                          'category-database');
                                  categoryDB.clear();
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();
                                  await preferences.clear();
                                  final trans =
                                      await Hive.openBox<TransactionModel>(
                                          'name');
                                  await trans.clear();
                                },
                                child: const Text(
                                  'Yes',
                                  style: TextStyle(color: Colors.purple),
                                ),
                              )
                            ],
                          ));
                },
                title: textBigB(text: 'Logout', size: 18),
                trailing: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/image/logout.jpg'),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
