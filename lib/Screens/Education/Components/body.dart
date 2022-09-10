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

import '../../../components/event_list.dart';

class BeautyLandingBody extends StatefulWidget {
  const BeautyLandingBody({Key? key}) : super(key: key);

  @override
  State<BeautyLandingBody> createState() => _PrefBodyState();
}

class _PrefBodyState extends State<BeautyLandingBody> {
  Map apis = new Map();
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
    for (var loc in _locations) {

      if (loc == 'SF') {
        apis['SF'] =
            'https://www.googleapis.com/calendar/v3/calendars/oh9js5h72kmckifvfssmtqifks@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'East Bay') {
        apis['East Bay'] =
            'https://www.googleapis.com/calendar/v3/calendars/gc6dohpkvj46n5rk46knvj3db8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'South Bay') {
        apis['South Bay'] =
            'https://www.googleapis.com/calendar/v3/calendars/sdg0qu3hl65hsv5jisqm26jirk@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'Peninsula') {
        apis['Peninsula'] =
            'https://www.googleapis.com/calendar/v3/calendars/l1mujfljoeotcvicg03bv5cnt4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'LA') {
        apis['LA'] =
        'https://www.googleapis.com/calendar/v3/calendars/0gi1b8ab2n2absjvi7lan73us0@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'Marin') {
        apis['Marin'] =
        'https://www.googleapis.com/calendar/v3/calendars/nvrdg2lfipapcjdocgcvr9j1v4@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
    _getNotifPref();
    _getLocations();
  }

  bool _wifi = true;
  Widget build(BuildContext context) {
    final children = <Widget>[];
    Color col = Colors.black;

    for (var i = 0; i < _locations.length; i++) {
      if (_locations[i] == 'SF') {
        col = kPrimaryLightColor;
      }
      if (_locations[i] == 'East Bay') {
        col = Colors.amber;
      }
      if (_locations[i] == 'South Bay') {
        col = Colors.deepPurpleAccent;
      }
      if (_locations[i] == 'Peninsula') {
        col = Colors.red;
      }
      if (_locations[i] == 'LA') {
        col = Colors.orangeAccent;
      }
      if (_locations[i] == 'Marin') {
        col = Colors.pink;
      }
      children.add(new Text(
        textAlign: TextAlign.center,
        _locations[i],
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: col,
        ),
      ));
      children.add(new Text(
        textAlign: TextAlign.center,
        ' ',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: col,
        ),
      ));
    }

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
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
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
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
        FutureBuilder<List<Calendar>>(
          future: fetchCalendars(http.Client(), apis),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else if (snapshot.hasData) {
              return EventList(
                  calendars: snapshot.data!, colors: colors, count: count, day: DateTime.now(), eventType: "Education",);
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )

      ],
    );
  }
}
