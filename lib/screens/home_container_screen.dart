import 'package:flutter/material.dart';
import 'package:cleanin/screens/home_status_screen.dart';
import 'package:cleanin/screens/calendar/event_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';

class HomeContainerScreen extends StatefulWidget {
  const HomeContainerScreen({Key? key, required this.reference}) : super(key: key);

  final DocumentReference<Home> reference;

  @override
  State createState() => _HomeContainerScreenState();
}

class _HomeContainerScreenState extends State<HomeContainerScreen> {
  late final List<Widget> _homeContainerViews;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _homeContainerViews = [
      CalendarScreen(reference: widget.reference),
      HomeStatusScreen(reference: widget.reference),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _homeContainerViews[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
        }),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "calendar"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "home"
          ),
        ],
      ),
    );
  }
}