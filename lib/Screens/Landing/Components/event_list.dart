import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';

import '../../../components/calendar.dart';
import '../../../components/extended_text.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../Settings/settings_screen.dart';
import '../../../components/calendar_event.dart';
import 'package:intl/intl.dart';

class EventList extends StatelessWidget {
  EventList(
      {super.key,
      required this.calendars,
      required this.colors,
        required this.count,

      });

  final List<Calendar> calendars;
  final List<Color> colors;
  final int count;

  bool calculateDifference(DateTime date, int weekday) {
    DateTime now = DateTime.now();
    var ans = now.weekday == weekday;
    return ans;
  }

  int index = 0;
  List<Event> events = [];
  List<Color> color_list = [];

  Widget build(BuildContext context) {
    for (var cals in calendars) {
      Color color = colors[index];
      for (var event in cals.events) {
        if (calculateDifference(event.startTime, event.weekday) == true) {
          if (!events.contains(event)) {
            events.add(event);
            color_list.add(color);
          }
        }
      }
      index ++;
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
