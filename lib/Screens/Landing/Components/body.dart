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
  String _username = "No name";
  String _enabled = "Unknown";
  List<String> _locations = List.empty(growable: true);

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
    return Background(
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/wehope_logo.jpg',
                width: size.width * 0.4,
              ),
            ],
          ),
        ),
        body: Column(
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
                  "You have the following events coming up ",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
              ],
            ),
            FutureBuilder<Calendar>(
              future: fetchCalendars(http.Client(), _locations),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error.toString());
                  return Center(
                    child:  Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  return EventList(calendar: snapshot.data!);
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
