import 'package:flutter/material.dart';

import '../../screens/basescreen/decoration.dart';
import 'login_screen.dart';

class IntroScreenMain extends StatelessWidget {
  const IntroScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Image.asset(
                "assets/image/money-removebg-preview.png",
                height: 300,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: textBigB(
                text: 'Gain total control of your money',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 30, right: 30),
              child: textBigG(
                  text:
                      'Become your own money manager and make every cent count'),
            ),
            botton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => const Loginscreen()));
                },
                titel: 'cotinue')
          ],
        ),
      ),
    );
  }
}
