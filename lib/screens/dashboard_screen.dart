import 'package:cleanin/screens/components/HomeContainer.dart';
import 'package:flutter/material.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:cleanin/screens/components/HomeCard.dart';

class DashboardScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<DashboardScreen> {
  final List<HomeContainer> _homes = <HomeContainer> [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: _homes,
        key: UniqueKey(),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            _homes.add(const HomeContainer());
          });
        },
      ),
    );
  }
}