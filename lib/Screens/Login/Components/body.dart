import 'package:flutter/material.dart';
import 'package:wehope/Screens/Login/Components/background.dart';
import 'package:wehope/components/rounded_input_field.dart';
import 'package:wehope/Screens/Preferences/preferences_screen.dart';

import '../../../components/rounded_button.dart';
import '../../../components/text_field_container.dart';
import '../../../constants.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

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
              Image.asset(
                'assets/images/wehope_logo.jpg',
                width: size.width * 0.4,
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/icons/login.png",
                width: size.width,
                height: size.height * 0.4,
              ),
              Text(
                "What do you want us to call you?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: size.height * 0.005),
              UserName(onSubmit: (value) => print(value))
            ],
          ),
        ),
      ),
    );
  }
}

class UserName extends StatefulWidget {
  const UserName({Key? key, required this.onSubmit}) : super(key: key);
  final ValueChanged<String> onSubmit;

  @override
  State<UserName> createState() => _UserName();
}

class _UserName extends State<UserName> {
  final _controller = TextEditingController();
  bool _submitted = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    setState(() => _submitted = true);
    widget.onSubmit(_controller.value.text);
    _saveName();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return PreferenceScreen();
        },
      ),
    );
  }

  void _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', _controller.value.text);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _controller,
        builder: (context, TextEditingValue value, __) {
          return Column(
            children: [
              RoundedInputField(
                controller: _controller,
                hintText: "Preferred Name",
                icon: Icons.person,
                onChanged: (value) {},
              ),
              RoundedButton(
                text: "Next",
                press: _controller.value.text.isNotEmpty ? _submit : null,
                color: kPrimaryColor,
                textColor: Colors.white,
              ),
            ],
          );
        });
  }
}
