import 'dart:ui';

import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:wehope/components/calendar_event.dart';
import 'package:wehope/constants.dart';

import '../../../components/calendar.dart';


class MeetingDataSource extends CalendarDataSource {
  List<Color> color_list = [];

  MeetingDataSource(List<Calendar> source, List<Color> colors) {
    int index = 0;
    List<Event> events = [];
      for (var cals in source) {
        Color color = colors[index];
        for (var event in cals.events) {
            if (!events.contains(event)) {
              events.add(event);
              color_list.add(color);
            }
        }
        index ++;
      }

    appointments = events;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].startTime;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].endTime;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    return color_list[index];
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
