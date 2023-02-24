import 'dart:async';
import 'package:app_money/view/home/screen_home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/widgets/intro_screen.dart';
import 'decoration.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkRegister(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 169, 76, 186),
      body: SafeArea(
        child: Center(
          child: textBig(text: 'money'),
        ),
      ),
    );
  }

  Future<void> goToGetPage() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => const IntroScreenMain()));
  }

  Future<void> checkRegister(BuildContext context) async {
    final sharePrefs = await SharedPreferences.getInstance();
    final userRegistered = sharePrefs.getString('nameKey');
    if (userRegistered == null) {
      goToGetPage();
    } else {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) {
        return;
      }

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const ScreenHome()));
    }
  }
}
