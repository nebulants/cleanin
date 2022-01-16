import 'package:cleanin/screens/calendar/event_calendar.dart';
import 'package:cleanin/utils/calendar_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';

import 'dart:async';

class EventSynchronizer {
  EventSynchronizer({required this.reference});

  final DocumentReference<Home> reference;
  final CalendarParser calendarParser = CalendarParser();

  Future<List<Meeting>> getCalendarEntries() async {

    Home home = await reference.get().then((value) => value.data()!);

    List<Meeting> meetings = await calendarParser.getCalendarEntries(home.icalPermalink);

    if(meetings.isEmpty) return [];

    meetings.sort((a, b) => a.from.compareTo(b.from));

    print(meetings.map((e) => [e.eventName, e.from, e.to]));

    var filtered = meetings.where((e) => e.from.isAfter(DateTime.now()));

    home.nextCheckIn = filtered.first.from;

    var filteredHomeOccupied = meetings.where((element) =>
    element.from.isBefore(DateTime.now()) && element.to.isAfter(DateTime.now())
    );

    if(filteredHomeOccupied.isNotEmpty) {
      home.homeState = HomeState.occupied.name;
    }
    else if(home.homeState == HomeState.occupied.name) {
      home.homeState = HomeState.dirty.name;
    }

    await reference.update(home.toMap());

    return meetings;
  }
}