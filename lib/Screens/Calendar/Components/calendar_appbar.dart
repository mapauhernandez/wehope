import 'package:flutter/material.dart';
import 'package:wehope/Screens/Landing/Components/body.dart';
import 'package:wehope/Screens/Preferences/Components/body.dart';
import 'package:wehope/Screens/Settings/settings_screen.dart';

import '/../constants.dart';


class CalendarAppBar extends StatelessWidget with PreferredSizeWidget{
  const CalendarAppBar({Key? key}) : super(key: key);

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
            "Calendar    ",
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
