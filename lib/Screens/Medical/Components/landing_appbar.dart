import 'package:flutter/material.dart';
import 'package:wehope/Screens/Landing/Components/body.dart';
import 'package:wehope/Screens/Preferences/Components/body.dart';
import 'package:wehope/Screens/Settings/settings_screen.dart';

import '/../constants.dart';
import '../../Settings/Components/body.dart';
import '../../Settings/Components/settings_appbar.dart';
import '../Components/body.dart';

class MedLandingAppBar extends StatelessWidget with PreferredSizeWidget{
  const MedLandingAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AppBar(
      foregroundColor: Colors.black,
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Medical",
            style: TextStyle(fontSize: 18),
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
