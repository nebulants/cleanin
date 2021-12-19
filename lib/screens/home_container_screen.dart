import 'package:cleanin/screens/components/table_calendar_basic.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeContainerScreen extends StatefulWidget {
  const HomeContainerScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeContainerScreen();
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    //'email',
    //'https://www.googleapis.com/auth/contacts.readonly',
    'https://www.googleapis.com/auth/calendar.readonly',
    'https://www.googleapis.com/auth/calendar.events.readonly'
  ],
);

class _HomeContainerScreen extends State<HomeContainerScreen> {
  final List<Widget> _homeContainerViews = [
    Center(
      child: ListView(
        children: [
          Center(
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
              ),
              onPressed: () {
                try {
                  _googleSignIn.signIn();
                  print("sign in successful");
                } catch (error) {
                  print(error);
                }
              },
              child: Text('SIGN IN'),
            ),
          ),
          Center(
            child: TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue)
              ),
              onPressed: () {
                try {
                  _googleSignIn.disconnect();
                  print("sign out successful");
                } catch (error) {
                  print(error);
                }
              },
              child: Text('SIGN OUT'),
            ),
          ),
        ],
      ),
    ),
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