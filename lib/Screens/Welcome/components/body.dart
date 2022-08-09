import 'package:flutter/material.dart';
import 'package:wehope/Screens/Welcome/components/background.dart';
import 'package:wehope/constants.dart';

import '../../../components/rounded_button.dart';
import '../../Login/login_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; //height and width of our screen
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/images/wehope_logo.jpg',
            width: size.width * 0.7,
          ),
          const Text(
            "Welcome to the WeHope App ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.005),
          Image.asset(
            "assets/icons/landing.png",
            width: size.width,
            height: size.height * 0.4,
          ),
          SizedBox(height: size.height * 0.005),
          RoundedButton(
            text: "Get Started",
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return LoginScreen();
                  },
                ),
              );
            },
            color: kPrimaryColor,
            textColor: Colors.white,
          ),
        ],
      );
  }
}
