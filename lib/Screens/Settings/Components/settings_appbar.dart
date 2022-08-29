import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:settings_ui/settings_ui.dart';

import '/../components/rounded_button.dart';
import '/../constants.dart';
import '../../Landing/landing_screen.dart';

class SettingsAppBar extends StatelessWidget with PreferredSizeWidget{
  const SettingsAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
  return AppBar(
    automaticallyImplyLeading: false,
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
    );
  }
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
