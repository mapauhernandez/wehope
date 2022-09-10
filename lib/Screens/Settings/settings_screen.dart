import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:wehope/Screens/Settings/Components/body.dart';

import '../../components/rounded_button.dart';
import '../../constants.dart';
import '../Landing/landing_screen.dart';
import 'Components/settings_appbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _toggle_notifs = false;
  List<String> _loc_list = List.empty(growable: true);
  List<String> _type_list = List.empty(growable: true);
  Map<String, bool> _toggles = new Map();
  bool _submitted = false;

  List<String> locs = ["South Bay", "East Bay", "Peninsula", "SF", "LA", "Marin",];
  List<String> types = ["Medical", "Beauty", "Dignity on Wheels", "Casework", "Education", "Other"];


  void _setToggles() {
    for (var loc in locs) {
      _toggles[loc] = false;
    }
    for (var type in types) {
      _toggles[type] = false;
    }
  }

  void _submit() {
    setState(() => _submitted = true);
    _saveLocations();
    _saveTypes();
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

  void _saveTypes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('types', _type_list);
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
        appBar: SettingsAppBar(),
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
                        style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  SettingsSection(
                    title: Text('Locations'),
                    tiles: <SettingsTile>[
                      for (var loc in locs)
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
                    title: Text('Event Types'),
                    tiles: <SettingsTile>[
                      for (var type in types)
                        SettingsTile.switchTile(
                          initialValue: _toggles[type],
                          onToggle: (value) {
                            setState(() {
                              _toggles[type] = value;
                            });
                            _toggles[type]!
                                ? _type_list.add(type)
                                : _type_list.contains(type)
                                ? _type_list.remove(type)
                                : {};
                          },
                          title: Text(type),
                        )
                    ],
                  ),
                  CustomSettingsSection(
                    child: Column(
                      children: <Widget>[
                        RoundedButton(
                          text: "Save Preferences",
                          press: () {
                            _submit();
                          },
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
