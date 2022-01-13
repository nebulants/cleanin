import 'dart:io';
import 'dart:ui';

import 'package:cleanin/screens/calendar/event_calendar.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class CalendarParser {
  late ICalendar calendar;

  Future<List<Meeting>> getCalendarEntries(String sourceUrl) async {
    try {
      Uri url = Uri.parse(sourceUrl);
      final http.Response responseData = await http.get(url);
      var responseBytes = responseData.bodyBytes.buffer.asUint8List(
          responseData.bodyBytes.offsetInBytes,
          responseData.bodyBytes.lengthInBytes
      );
      final directory = await getTemporaryDirectory();
      final myPath = path.join(directory.path, "airbnb.ics");
      final file = await File(myPath).writeAsBytes(responseBytes);
      final lines = await file.readAsLines();
      // print('Lines: $lines');

      calendar = ICalendar.fromLines(lines);

      // print(calendar.data.map((e) => e['summary'].toString()));
      // print(calendar.data.map((e) => e['dtstart'].toDateTime()));
      // print(calendar.data.map((e) => e['dtend'].toDateTime()));

      final DateTime startTime = calendar.data.map((e) => e['dtstart'].toDateTime()).first;
      final DateTime endTime = calendar.data.map((e) => e['dtend'].toDateTime()).first;

      final List<Meeting> meetings = <Meeting>[];
      // ((type, dtend, dtstart, uid, summary))
      for(var item in calendar.data) {
        meetings.add(Meeting(
            item['summary'],
            item['dtstart'].toDateTime(),
            item['dtend'].toDateTime(),
            const Color(0xFF0F8644),
            true
        ));
      }
      return meetings;
    }
    catch (e) {
      throw 'Error: $e';
    }
  }

}