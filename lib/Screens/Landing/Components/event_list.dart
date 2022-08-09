
import 'package:maps_launcher/maps_launcher.dart';
import 'package:flutter/material.dart';

import '../../../components/calendar.dart';
import '../../../components/extended_text.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../Settings/settings_screen.dart';
import '../../../components/calendar_event.dart';

class EventList extends StatelessWidget {
  EventList({super.key, required this.calendar, required this.locations});

  final Calendar calendar;
  final List<String> locations;

  @override
  Widget build(BuildContext context) {
      List<Event> events = calendar.events;
      if (true) {
        return Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 1.3,
            ),
            itemCount: events.length,
            itemBuilder: (context, index) {
              return Card(
                color: kPrimaryLightColor,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white70, width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(20.0),
                    color: kPrimaryLightColor,
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
                            DescriptionTextWidget(
                              text: events[index].description,
                              color: Colors.white,
                              icon_color: kPrimaryColor,)
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
}
