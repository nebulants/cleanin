import 'package:cleanin/screens/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:cleanin/screens/side_menu.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hello cleanin!"),
      ),
      drawer: SideMenu(),
      body: SafeArea(
        child: DashboardScreen(),
      ),
    );
  }
}