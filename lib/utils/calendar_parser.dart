import 'dart:io';
import 'dart:ui';

import 'package:cleanin/screens/calendar/event_calendar.dart';
import 'package:icalendar_parser/icalendar_parser.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:mutex/mutex.dart';

Mutex m = Mutex();

class CalendarParser {
  late ICalendar calendar;

  Future<List<Meeting>> getCalendarEntries(String sourceUrl) async {
    try {
      Uri url = Uri.parse(sourceUrl);
      final http.Response responseData = await m.protect(() => http.get(url));
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

      if(calendar.data.isEmpty) return [];

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