import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';

import '../../../components/calendar.dart';
import '../../../components/extended_text.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../components/../constants.dart';
import '../../../components/../Screens/Settings/settings_screen.dart';
import '../../../components/calendar_event.dart';
import 'package:intl/intl.dart';

class EventList extends StatefulWidget {
  EventList({
    super.key,
    required this.calendars,
    required this.colors,
    required this.count,
    required this.day,
    required this.eventType,
  });

  final List<Calendar> calendars;
  final List<Color> colors;
  final int count;
  final DateTime day;
  final List<String> eventType;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool calculateDifference(
      DateTime date, int weekday, String recurrence, DateTime endDate) {
    DateTime now = widget.day;
    bool expired = false;

    DateTime _formatToday =
        DateTime(widget.day.year, widget.day.month, widget.day.day);

    if (endDate.compareTo(_formatToday) < 0) {
      expired = true;
    }
    var ans = now.weekday == weekday;
    return (ans & !expired);
  }

  Widget build(BuildContext context) {
    List<Event> events = [];
    List<Color> color_list = [];
    int i = 0;
    for (var cals in widget.calendars) {
      for (String type in widget.eventType) {
        for (var event in cals.events) {
          if (calculateDifference(event.startTime, event.weekday,
                  event.recurrence, event.endDate) ==
              true) {
            if (events.contains(event) == false) {
              events.add(event);
              if (cals.name.contains('SF')) {
                color_list.add(kPrimaryLightColor);
              }
              if (cals.name.contains('East Bay')) {
                color_list.add(Colors.amber);
              }
              if (cals.name.contains('South Bay')) {
                color_list.add(Colors.deepPurpleAccent);
              }
              if (cals.name.contains('Peninsula')) {
                color_list.add(Colors.red);
              }
              if (cals.name.contains('LA')) {
                color_list.add(Colors.orangeAccent);
              }
              if (cals.name.contains('Marin')) {
                color_list.add(Colors.pink);
              }
            }
          }
        }
        i++;
      }
    }
    return Expanded(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
        ),
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Card(
            color: color_list[index],
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.white70, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.all(20.0),
                color: color_list[index],
                child: Column(
                  children: <Widget>[
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold),
                          events[index].name,
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                          DateFormat.jm().format(events[index].startTime),
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                          " - ",
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontStyle: FontStyle.italic),
                          DateFormat.jm().format(events[index].endTime),
                        ),
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        DescriptionTextWidget(
                          text: events[index].description,
                          color: Colors.white,
                          icon_color: Colors.black,
                        )
                      ],
                    ),
                    Wrap(
                      alignment: WrapAlignment.start,
                      children: <Widget>[
                        Text(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                          events[index].location,
                        ),
                      ],
                    ),
                    RoundedButton(
                      text: "Get me directions",
                      press: () =>
                          MapsLauncher.launchQuery(events[index].location),
                      color: kPrimaryColor,
                      textColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
