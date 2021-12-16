import 'package:flutter/material.dart';
import 'package:cleanin/screens/main_screen.dart';
import 'package:calendar_view/calendar_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarControllerProvider(
        controller: EventController(),
        child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MainScreen(),
      )
    );
  }
}
