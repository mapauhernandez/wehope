import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';

import 'calendar.dart';
import 'extended_text.dart';
import 'rounded_button.dart';
import 'text_field_container.dart';
import '../constants.dart';
import '../Screens/Settings/settings_screen.dart';
import 'calendar_event.dart';
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
  final String eventType;

  @override
  State<EventList> createState() => _EventListState();
}

class _EventListState extends State<EventList> {
  bool calculateDifference(DateTime date, int weekday, String recurrence, DateTime endDate, DateTime startDate) {
    DateTime now = widget.day;
    bool expired = false;
    bool early = false;

    DateTime _formatToday = DateTime(widget.day.year, widget.day.month, widget.day.day);

    if(endDate.compareTo(_formatToday) < 0 ){
      expired = true;
    }

    if(startDate.compareTo(_formatToday) > 0 ){
      early = true;
    }
    var ans = now.weekday == weekday;
    return (ans & !expired & !early);
  }

  Widget build(BuildContext context) {
    List<Event> events = [];
    List<Color> color_list = [];
    List<String> cancelled_IDs = [];

    for (var cals in widget.calendars) {
      for (var event in cals.events) {
        if (event.cancelled == true) {
          cancelled_IDs.add(event.code);
        }
      }
    }

    for (var cals in widget.calendars) {
      for (var event in cals.events) {
        if (calculateDifference(event.startTime, event.weekday, event.recurrence, event.endDate, event.startDate) == true && event.startTime != event.endTime) {
          if (events.contains(event) == false && !cancelled_IDs.contains(event.code)) {
            events.add(event);
            if (cals.name == widget.eventType + '-SF') {
              color_list.add(kPrimaryLightColor);
            }
            if (cals.name == widget.eventType + '-East Bay') {
              color_list.add(Colors.amber);
            }
            if (cals.name == widget.eventType + '-South Bay') {
              color_list.add(Colors.deepPurpleAccent);
            }
            if (cals.name == widget.eventType + '-Peninsula') {
              color_list.add(Colors.red);
            }
            if (cals.name == widget.eventType + '-LA') {
              color_list.add(Colors.orangeAccent);
            }
            if (cals.name == widget.eventType + '-Marin') {
              color_list.add(Colors.pink);
            }
          }
        }
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
