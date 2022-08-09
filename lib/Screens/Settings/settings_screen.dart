import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../components/rounded_button.dart';
import '../../constants.dart';
import '../Landing/landing_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _toggle_notifs = false;
  List<String> _loc_list = List.empty(growable: true);
  Map<String, bool> _toggles = new Map();
  bool _submitted = false;

  List<String> northBayLocs = ["UN Plaza", "Golden Gate Park"];
  List<String> southBayLocs = ["Stanford", "San Jose"];
  List<String> eastBayLocs = ["Fremont", "Bleep", "Oakland"];

  void _setToggles() {
    for (var loc in northBayLocs) {
      _toggles[loc] = false;
    }
    for (var loc in southBayLocs) {
      _toggles[loc] = false;
    }
    for (var loc in eastBayLocs) {
      _toggles[loc] = false;
    }
  }

  void _submit() {
    setState(() => _submitted = true);
    _saveLocations();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return LandingPage();
        },
      ),
    );
  }

  void _saveNotifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('notifs', _toggle_notifs);
  }

  void _saveLocations() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('locations', _loc_list);
  }

  void initState() {
    super.initState();
    _setToggles();
  }

  @override
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
              Text(
                "Settings    ",
                style: TextStyle(fontSize: 25),
              ),
              Image.asset(
                'assets/images/wehope_logo.jpg',
                width: size.width * 0.4,
              ),
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SettingsList(
                sections: [
                  SettingsSection(
                    title: Text('Enable Notifications'),
                    tiles: <SettingsTile>[
                      SettingsTile.switchTile(
                        onToggle: (value) {
                          setState(() {
                            _toggle_notifs = value;
                          });
                          _saveNotifs();
                        },
                        initialValue: _toggle_notifs,
                        leading: Icon(Icons.notification_add),
                        title: Text('Allow Notifications'),
                      ),
                    ],
                  ),
                  CustomSettingsSection(
                    child: Container(
                      child: Text(
                        "Select which locations and event types you'd like to see events for",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  SettingsSection(
                    title: Text('North Bay Locations'),
                    tiles: <SettingsTile>[
                      for (var loc in northBayLocs)
                        SettingsTile.switchTile(
                          initialValue: _toggles[loc],
                          onToggle: (value) {
                            setState(() {
                              _toggles[loc] = value;
                            });
                            _toggles[loc]!
                                ? _loc_list.add(loc)
                                : _loc_list.contains(loc)
                                    ? _loc_list.remove(loc)
                                    : {};
                          },
                          title: Text(loc),
                        )
                    ],
                  ),
                  SettingsSection(
                    title: Text('South Bay Locations'),
                    tiles: <SettingsTile>[
                      for (var loc in southBayLocs)
                        SettingsTile.switchTile(
                          initialValue: _toggles[loc],
                          onToggle: (value) {
                            setState(() {
                              _toggles[loc] = value;
                            });
                            _toggles[loc]!
                                ? _loc_list.add(loc)
                                : _loc_list.contains(loc)
                                    ? _loc_list.remove(loc)
                                    : {};

                          },
                          title: Text(loc),
                        )
                    ],
                  ),
                  SettingsSection(
                    title: Text('East Bay Locations'),
                    tiles: <SettingsTile>[
                      for (var loc in eastBayLocs)
                        SettingsTile.switchTile(
                          initialValue: _toggles[loc],
                          onToggle: (value) {
                            setState(() {
                              _toggles[loc] = value;
                            });
                            _toggles[loc]!
                                ? _loc_list.add(loc)
                                : _loc_list.contains(loc)
                                    ? _loc_list.remove(loc)
                                    : {};
                          },
                          title: Text(loc),
                        )
                    ],
                  ),
                  CustomSettingsSection(
                    child: Column(
                      children: <Widget>[
                        RoundedButton(
                          text: "Save Preferences",
                          press: () {_submit();},
                          color: kPrimaryColor,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
