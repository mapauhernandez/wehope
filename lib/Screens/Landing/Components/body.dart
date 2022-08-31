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
import '../../DoW/landing_screen.dart';
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
  Map apis = new Map();
  Map icons = new Map();
  Map cols = new Map();
  int currentIndex = 0;
  String _username = "No name";
  String _enabled = "Unknown";
  List<String> _locations = List.empty(growable: true);
  List<String> _prefs = List.empty(growable: true);

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

  void _getPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _prefs = prefs.getStringList('types')!;
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
            'https://www.googleapis.com/calendar/v3/calendars/fdm09jjfsg4ll5lsbn4o24q6o8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'East Bay') {
        apis['East Bay'] =
            'https://www.googleapis.com/calendar/v3/calendars/03bgjolvc1prh750i0m9qujddc@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'South Bay') {
        apis['South Bay'] =
            'https://www.googleapis.com/calendar/v3/calendars/extreme.wehope@gmail.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'Peninsula') {
        apis['Peninsula'] =
            'https://www.googleapis.com/calendar/v3/calendars/a01n633sb75lqben0i41uhmog8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
      if (loc == 'LA') {
        apis['LA'] =
            'https://www.googleapis.com/calendar/v3/calendars/o58iv89dhfspkqo50pkrvtjho8@group.calendar.google.com/events?key=AIzaSyDSHlQAm5r_ePot45JDg3TFDbKSU3evQmY';
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
    _getNotifPref();
    _getLocations();
    _getPreferences();
  }

  bool _wifi = true;
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    final children = <Widget>[];
    Color col = Colors.black;

    for (var pref in _prefs) {
      if (pref == 'Medical') {
        icons['Medical'] = Icons.medical_information;
        cols['Medical'] = Colors.lightGreen;
      }
      if (pref == 'Dignity on Wheels') {
        icons['Dignity on Wheels'] = Icons.car_repair_outlined;
        cols['Dignity on Wheels'] = kPrimaryLightColor;
      }
      if (pref == 'Beauty') {
        icons['Beauty'] = Icons.face_outlined;
        cols['Beauty'] = Colors.amber;
      }
    }

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
        col = Colors.lightGreen;
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
              "What kind of services are you interested in? ",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: List.generate(_prefs.length, (index) {
              return RawMaterialButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return DoWLandingPage();
                      },
                    ),
                  );
                },
                child: Card(
                  elevation: 10.0,
                  color: cols[_prefs[index]],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: size.width/2 - 20,
                      height: size.width/2 - 20,
                      padding: EdgeInsets.symmetric(),
                      color: cols[_prefs[index]],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: Icon(icons[_prefs[index]], size: 50)),
                          Expanded(
                            child: Text(
                              _prefs[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18)
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
