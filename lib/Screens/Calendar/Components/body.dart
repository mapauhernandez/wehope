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
import '../../../constants.dart';
import '../../../constants.dart';
import '../../Settings/settings_screen.dart';
import '../../../components/calendar_event.dart';

import 'package:http/http.dart' as http;

import 'package:maps_launcher/maps_launcher.dart';

import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'datasource.dart';

class CalendarBody extends StatefulWidget {
  const CalendarBody({Key? key}) : super(key: key);

  @override
  State<CalendarBody> createState() => _CalendarBodyState();
}

class _CalendarBodyState extends State<CalendarBody> {
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

  bool _wifi = true;

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
              "This is what your week looks like",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ],
        ),
      ],
    );
  }
}
