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
        SfCalendar(
          view: CalendarView.week,
          dataSource: MeetingDataSource(_getDataSource()),
          monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment),
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
      ],
    );
  }
}

List<Meeting> _getDataSource() {
  final List<Meeting> meetings = <Meeting>[];
  DateTime today = DateTime.now();
  DateTime startTime = DateTime(today.year, today.month, today.day, 9, 0, 0);
  DateTime endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('DoW', startTime, endTime, kPrimaryLightColor, false));

  startTime = DateTime(today.year, today.month, 2, 9, 0, 0);
  endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('Hair Care', startTime, endTime, Colors.amber, false));

  startTime = DateTime(today.year, DateTime.august, 31, 9, 0, 0);
  endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('HHM', startTime, endTime, Colors.deepPurpleAccent, false));


  startTime = DateTime(today.year, DateTime.august, 30, 9, 0, 0);
  endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('DoW', startTime, endTime, kPrimaryLightColor, false));

  startTime = DateTime(today.year, DateTime.august, 29, 9, 0, 0);
  endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('Eye Clinic', startTime, endTime, Colors.red, false));

  startTime = DateTime(today.year, DateTime.august, 28, 9, 0, 0);
  endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('Dental Clinic', startTime, endTime, Colors.orangeAccent, false));

  startTime = DateTime(today.year, DateTime.september, 3, 9, 0, 0);
  endTime = startTime.add(const Duration(hours: 2));

  meetings.add(Meeting('DoW Clinic', startTime, endTime, kPrimaryLightColor, false));
  return meetings;
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return appointments![index].isAllDay;
  }
}

class Meeting {
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;
}
