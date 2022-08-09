import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:wehope/components/rounded_input_field.dart';
import 'package:wehope/Screens/Preferences/preferences_screen.dart';

import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';
import '../../Settings/settings_screen.dart';

class PrefBody extends StatefulWidget {
  const PrefBody({Key? key}) : super(key: key);

  @override
  State<PrefBody> createState() => _PrefBodyState();
}

class _PrefBodyState extends State<PrefBody> {
  String _username = "No name";

  void _getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = (prefs.getString('username') ?? "??");
    });
  }

  @override
  void initState() {
    super.initState();
    _getUsername();
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
          children: <Widget>[
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.end,
              children: <Widget>[
                SizedBox(height: size.height * 0.1),
                Text(
                  "Welcome ",
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
                ),
                Text(
                  _username,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ],
            ),
            Image.asset(
              "assets/icons/preferences.png",
              width: size.width,
              height: size.height * 0.4,
            ),
            Text(
              "Let's configure your settings ",
              style: TextStyle(fontWeight: FontWeight.normal, fontSize: 20),
            ),
            RoundedButton(
              text: "Next",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SettingsScreen();
                    },
                  ),
                );
              },
              color: kPrimaryColor,
              textColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
