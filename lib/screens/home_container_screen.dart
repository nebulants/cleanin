import 'package:cleanin/screens/components/table_calendar_basic.dart';
import 'package:flutter/material.dart';
import 'package:cleanin/screens/login_screen.dart';

class HomeContainerScreen extends StatefulWidget {
  const HomeContainerScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeContainerScreen();
}

class _HomeContainerScreen extends State<HomeContainerScreen> {
  final List<Widget> _homeContainerViews = [
    const LoginScreen(),
    const TableBasicsExample(),
  ];
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homeContainerViews[_currentIndex],
      appBar: AppBar(
          title: const Text("Home container screen")
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "calendar"
          )
        ],
      ),
    );
  }
}