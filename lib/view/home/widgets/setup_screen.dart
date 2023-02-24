import 'package:app_money/view/home/screen_home.dart';
import 'package:flutter/material.dart';

import '../../screens/basescreen/decoration.dart';

class Setup extends StatelessWidget {
  const Setup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Image.asset('assets/image/plan-removebg-preview.png'),
              ),
              const Text(
                'Let’s setup your account!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12, top: 30, right: 20),
                child: Text(
                  'Account can be your bank, credit card or your wallet.',
                  style: TextStyle(
                    color: Color.fromARGB(255, 61, 56, 56),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: botton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ScreenHome()));
                    },
                    titel: "Let's go"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
