import 'package:flutter/material.dart';
import 'package:flutter_firebase/auth.dart';
import 'package:flutter_firebase/regis.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _BottomNavigationBarState();
}

class _BottomNavigationBarState extends State<Home> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const Regis(),
    const Auth(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: "Регистрация"),
          BottomNavigationBarItem(
              icon: Icon(Icons.accessibility_new), label: "Авторизация"),
        ],
        currentIndex: currentIndex,
        onTap: ((value) {
          setState(() {
            currentIndex = value;
          });
        }),
      ),
      body: pages[currentIndex],
    );
  }
}
