import 'package:flutter/material.dart';
import '../constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final void Function()? press;
  final Color color, textColor;
  const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    required this.color,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            primary: color,
          ),
          onPressed: press,
          child: Text(
              text,
              style: TextStyle(color: textColor)
          ),
        ),
      ),
    );
  }
}
