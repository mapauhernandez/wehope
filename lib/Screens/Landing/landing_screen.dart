import 'package:flutter/material.dart';
import 'package:wehope/Screens/Landing/Components/body.dart';
import 'package:wehope/Screens/Preferences/Components/body.dart';
import 'package:wehope/Screens/Settings/settings_screen.dart';

import '../../constants.dart';
import '../Calendar/Components/body.dart';
import '../Calendar/Components/calendar_appbar.dart';
import '../Settings/Components/body.dart';
import '../Settings/Components/settings_appbar.dart';
import 'Components/body.dart';
import 'Components/landing_appbar.dart';

class LandingPage extends StatefulWidget {
  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  int currentIndex = 0;
  final List<PreferredSizeWidget> scaffolds = [
    LandingAppBar(),
    CalendarAppBar(),
    SettingsAppBar(),
  ];
  final screens = [
    LandingBody(),
    CalendarBody(),
    SettingsBody(),
  ];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
  return Scaffold(
      appBar: scaffolds[currentIndex],
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(()=>currentIndex = index),
        backgroundColor: Colors.white,
        iconSize: 25,
        selectedItemColor: kPrimaryColor,
        unselectedItemColor: kPrimaryLightColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_sharp),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_sharp),
            label: "Settings",
          ),
        ],
      )
    );
  }
}