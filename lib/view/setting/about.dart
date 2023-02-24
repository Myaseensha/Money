import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../home/widgets/box.dart';

class MyAbout extends StatefulWidget {
  const MyAbout({super.key});

  @override
  State<MyAbout> createState() => _MyStatsState();
}

class _MyStatsState extends State<MyAbout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 249, 233, 252),
      appBar: AppBar(
        backgroundColor: Colors.purple.shade500,
        title: const Text('About'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            const SizedBox(
              height: 85,
            ),
            Box(
              child: Column(
                children: [
                  const SizedBox(
                    height: 18,
                  ),
                  const Text(
                    'MONEY',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.purple),
                  ),
                  const Divider(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.center,
                      '"This is an app where you can add your daily transactions according to the category which it belongs to."',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('Developed by'),
                      Text(
                        'YASEEN SHA',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade300),
                      ),
                    ],
                  ),
                  const Divider(),
                  const Text('Contact Me'),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          onPressed: () async {
                            launchUr(Uri.parse(
                                'https://instagram.com/_yaseensha?igshid=NTA5ZTk1NTc='));
                          },
                          icon: const Icon(FontAwesomeIcons.instagram)),
                      IconButton(
                          onPressed: () async {
                            launchUr(Uri.parse(
                                'https://www.linkedin.com/in/yaseen-sha-67285224b'));
                          },
                          icon: const Icon(FontAwesomeIcons.linkedin)),
                      IconButton(
                          onPressed: () async {
                            launchUr(
                                Uri.parse('https://github.com/Myaseensha'));
                          },
                          icon: const Icon(FontAwesomeIcons.github)),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> launchUr(Uri url) async {
    if (!await launchUrl(url)) {
      throw 'Could not launch ';
    }
  }
}
