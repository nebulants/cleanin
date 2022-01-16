import 'dart:async';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cleanin/models/home.dart';
import 'package:cleanin/screens/calendar/event_synchronizer.dart';

class CalendarScreen extends StatefulWidget {
  /// Creates the home page to display the calendar widget.
  const CalendarScreen({Key? key, required this.reference}) : super(key: key);

  final DocumentReference<Home> reference;

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  List<Meeting> _dataSource = <Meeting>[];

  @override
  void initState() {
    super.initState();
    EventSynchronizer(reference: widget.reference).getCalendarEntries().then((value) => setState(() {
      _dataSource = value;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Event Calendar"),
          actions: [
            IconButton(
              onPressed: () async {
                EventSynchronizer(reference: widget.reference).getCalendarEntries().then((value) => setState(() {
                  _dataSource = value;
                }));
              },
              icon: const Icon(Icons.sync),
            )
          ],
        ),
        body: SfCalendar(
          view: CalendarView.month,
          dataSource: MeetingDataSource(_dataSource),
          // by default the month appointment display mode set as Indicator, we can
          // change the display mode as appointment using the appointment display
          // mode property
          monthViewSettings: const MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
            numberOfWeeksInView: 4
          ),
          allowedViews: const [
            CalendarView.day,
            CalendarView.week,
            CalendarView.month
          ],
          firstDayOfWeek: DateTime.monday,
          showDatePickerButton: true,
        )
        // body: CalendarAppointmentEditor(UniqueKey())
    );
  }
}

/// An object to set the appointment collection data source to calendar, which
/// used to map the custom appointment data to the calendar appointment, and
/// allows to add, remove or reset the appointment collection.
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}