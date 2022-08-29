import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:wehope/components/rounded_input_field.dart';
import 'package:wehope/Screens/Preferences/preferences_screen.dart';

import '../../../components/calendar.dart';
import '../../../components/extended_text.dart';
import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../Settings/settings_screen.dart';
import '../../../components/calendar_event.dart';

import 'package:http/http.dart' as http;

import 'package:maps_launcher/maps_launcher.dart';

import 'event_list.dart';

class LandingBody extends StatefulWidget {
  const LandingBody({Key? key}) : super(key: key);

  @override
  State<LandingBody> createState() => _PrefBodyState();
}

class _PrefBodyState extends State<LandingBody> {
  int currentIndex = 0;
  String _username = "No name";
  String _enabled = "Unknown";
  List<String> _locations = List.empty(growable: true);
  bool updated = false;
  void _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = (prefs.getString('username') ?? "??");
    });
  }

  void _getNotifPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _enabled = prefs.containsKey('notifs')
          ? prefs.getBool('notifs')!
              ? "Enabled"
              : "Disabled"
          : 'Disabled';
    });
  }

  void _getLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations = prefs.getStringList('locations')!;
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
    _getNotifPref();
    _getLocations();
  }

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Calendar> events = [];
    List<Color> colors = [];
    int count = 0;
    return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: <Widget>[
                  SizedBox(height: size.height * 0.05),
                  Text(
                    "Hello ",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                  Text(
                    _username,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  ),
                ],
              ),
              Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  SizedBox(height: size.height * 0.1),
                  Text(
                    textAlign: TextAlign.center,
                    "You have the following events today in: ",
                    style:
                        TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                  ),
                ],
              ),
              _locations.contains('SF')
                  ? FutureBuilder<Calendar>(
                      future: fetchCalendars(http.Client(),
                          'https://www.googleapis.com/calendar/v3/calendars/fdm09jjfsg4ll5lsbn4o24q6o8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          events.add(snapshot.data!);
                          colors.add(Colors.amber);
                          count++;
                          return Text(
                            textAlign: TextAlign.center,
                            "SF",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.amber),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : SizedBox.shrink(),
              _locations.contains('East Bay')
                  ? FutureBuilder<Calendar>(
                      future: fetchCalendars(http.Client(),
                          'https://www.googleapis.com/calendar/v3/calendars/03bgjolvc1prh750i0m9qujddc@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          events.add(snapshot.data!);
                          colors.add(Colors.deepPurple);
                          count++;
                          return Text(
                            textAlign: TextAlign.center,
                            "East Bay",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.deepPurple),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : SizedBox.shrink(),
              _locations.contains('South Bay')
                  ? FutureBuilder<Calendar>(
                      future: fetchCalendars(http.Client(),
                          'https://www.googleapis.com/calendar/v3/calendars/extreme.wehope@gmail.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          events.add(snapshot.data!);
                          colors.add(Colors.teal);
                          count++;
                          return Text(
                            textAlign: TextAlign.center,
                            "South Bay",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.teal),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : SizedBox.shrink(),
              _locations.contains('Peninsula')
                  ? FutureBuilder<Calendar>(
                      future: fetchCalendars(http.Client(),
                          'https://www.googleapis.com/calendar/v3/calendars/a01n633sb75lqben0i41uhmog8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY'),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(snapshot.error.toString()),
                          );
                        } else if (snapshot.hasData) {
                          events.add(snapshot.data!);
                          colors.add(kPrimaryLightColor);
                          count++;

                          return Text(
                            textAlign: TextAlign.center,
                            "Peninsula",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: kPrimaryLightColor),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                  : SizedBox.shrink(),
              Text("hello ddd"),
              EventList(
                calendars: events,
                colors: colors,
                count: count,
              ),
            ],
          );
  }
}
